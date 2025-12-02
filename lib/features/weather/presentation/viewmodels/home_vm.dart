import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/location_service.dart';
import '../../domain/entities/weather.dart';
import '../../domain/usecases/get_current_weather.dart';
import '../../data/services/alert_evaluation_service.dart';

class HomeVm extends StateNotifier<AsyncValue<Weather>> {
  final GetCurrentWeather getCurrentWeather;
  final LocationService locationService;
  final AlertEvaluationService? alertEvaluationService;

  HomeVm(
    this.getCurrentWeather,
    this.locationService, {
    this.alertEvaluationService,
  }) : super(const AsyncValue.loading());

  Future<void> loadCurrentLocation() async {
    state = const AsyncValue.loading();
    try {
      final position = await locationService.getCurrentLocation();
      if (position != null) {
        final weather = await getCurrentWeather(position.latitude, position.longitude);
        state = AsyncValue.data(weather);
        // Evaluate alert rules after loading weather
        await _evaluateAlerts(weather);
      }
    } catch (e, st) {
      // If location fails, show the error (it now has user-friendly messages)
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> load(double lat, double lon) async {
    state = const AsyncValue.loading();
    try {
      final weather = await getCurrentWeather(lat, lon);
      state = AsyncValue.data(weather);
      // Evaluate alert rules after loading weather
      await _evaluateAlerts(weather);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh(double lat, double lon) async {
    // Force refresh from API by skipping cache
    state = const AsyncValue.loading();
    try {
      final weather = await getCurrentWeather.call(lat, lon);
      state = AsyncValue.data(weather);
      // Evaluate alert rules after refreshing weather
      await _evaluateAlerts(weather);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
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
