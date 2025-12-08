import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/location_service.dart';
import 'home_state.dart';
import '../../domain/entities/weather.dart';
import '../../domain/usecases/get_current_weather.dart';
import '../../domain/usecases/get_api_alerts.dart';
import '../../data/services/alert_evaluation_service.dart';
import 'package:hive/hive.dart';

class HomeVm extends StateNotifier<HomeState> {
  final GetCurrentWeather getCurrentWeather;
  final GetApiAlerts getApiAlerts;
  final LocationService locationService;
  final AlertEvaluationService? alertEvaluationService;

  HomeVm(
    this.getCurrentWeather,
    this.getApiAlerts,
    this.locationService, {
    this.alertEvaluationService,
  }) : super(HomeState());

  Future<void> loadCurrentLocation() async {
    state = state.copyWith(isLoading: true, error: null, usedLastKnownLocation: false);
    try {
      final position = await locationService.getCurrentLocation();
      if (position != null) {
        final weather = await getCurrentWeather(position.latitude, position.longitude);
        final alerts = await getApiAlerts(position.latitude, position.longitude);
        state = state.copyWith(weather: weather, apiAlerts: alerts, isLoading: false, usedLastKnownLocation: false);
        await _evaluateAlerts(weather);
        // Save last known location
        final locationBox = await Hive.openBox('locationBox');
        await locationBox.put('lat', position.latitude);
        await locationBox.put('lon', position.longitude);
        await locationBox.close();
        return;
      }
    } catch (e, st) {
      // Try to load last known location from Hive
      try {
        final locationBox = await Hive.openBox('locationBox');
        final lat = locationBox.get('lat');
        final lon = locationBox.get('lon');
        await locationBox.close();
        if (lat != null && lon != null) {
          final weather = await getCurrentWeather(lat, lon);
          final alerts = await getApiAlerts(lat, lon);
          state = state.copyWith(weather: weather, apiAlerts: alerts, isLoading: false, usedLastKnownLocation: true);
          await _evaluateAlerts(weather);
          return;
        }
      } catch (_) {
        // Ignore fallback errors, show original error below
      }
      // If both fail, show the error
      state = state.copyWith(isLoading: false, error: e, stackTrace: st, usedLastKnownLocation: false);
    }
  }

  Future<void> load(double lat, double lon) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final weather = await getCurrentWeather(lat, lon);
      final alerts = await getApiAlerts(lat, lon);
      state = state.copyWith(weather: weather, apiAlerts: alerts, isLoading: false);
      await _evaluateAlerts(weather);
    } catch (e, st) {
      state = state.copyWith(isLoading: false, error: e, stackTrace: st);
    }
  }

  Future<void> refresh(double lat, double lon) async {
    // Force refresh from API by skipping cache
    state = state.copyWith(isLoading: true, error: null);
    try {
      final weather = await getCurrentWeather.call(lat, lon, forceRefresh: true);
      final alerts = await getApiAlerts(lat, lon);
      state = state.copyWith(weather: weather, apiAlerts: alerts, isLoading: false);
      await _evaluateAlerts(weather);
    } catch (e, st) {
      state = state.copyWith(isLoading: false, error: e, stackTrace: st);
    }
  }

  Future<void> _evaluateAlerts(Weather weather) async {
    if (alertEvaluationService != null) {
      try {
        await alertEvaluationService!.evaluateRules(weather);
        // Schedule daily summary at 6 PM
        await alertEvaluationService!.scheduleDailySummary(hour: 18);
      } catch (e) {
        // Don't fail the whole operation if alert evaluation fails
        print('Alert evaluation failed: $e');
      }
    }
  }
}
