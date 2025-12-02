import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/location_service.dart';
import '../../domain/entities/weather.dart';
import '../../domain/usecases/get_current_weather.dart';

class HomeVm extends StateNotifier<AsyncValue<Weather>> {
  final GetCurrentWeather getCurrentWeather;
  final LocationService locationService;

  HomeVm(this.getCurrentWeather, this.locationService) : super(const AsyncValue.loading());

  Future<void> loadCurrentLocation() async {
    state = const AsyncValue.loading();
    try {
      final position = await locationService.getCurrentLocation();
      if (position != null) {
        final weather = await getCurrentWeather(position.latitude, position.longitude);
        state = AsyncValue.data(weather);
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
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
