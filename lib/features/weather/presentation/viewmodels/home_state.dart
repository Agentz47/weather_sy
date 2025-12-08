import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/weather.dart';
import '../../domain/entities/weather_api_alert.dart';


class HomeState {
  final Weather? weather;
  final List<WeatherApiAlert> apiAlerts;
  final bool isLoading;
  final Object? error;
  final StackTrace? stackTrace;
  final bool usedLastKnownLocation;

  HomeState({
    this.weather,
    this.apiAlerts = const [],
    this.isLoading = false,
    this.error,
    this.stackTrace,
    this.usedLastKnownLocation = false,
  });

  HomeState copyWith({
    Weather? weather,
    List<WeatherApiAlert>? apiAlerts,
    bool? isLoading,
    Object? error,
    StackTrace? stackTrace,
    bool? usedLastKnownLocation,
  }) {
    return HomeState(
      weather: weather ?? this.weather,
      apiAlerts: apiAlerts ?? this.apiAlerts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      stackTrace: stackTrace,
      usedLastKnownLocation: usedLastKnownLocation ?? this.usedLastKnownLocation,
    );
  }

  AsyncValue<Weather> get asyncValue {
    if (isLoading) {
      return const AsyncValue.loading();
    } else if (error != null) {
      return AsyncValue.error(error!, stackTrace ?? StackTrace.current);
    } else if (weather != null) {
      return AsyncValue.data(weather!);
    } else {
      return const AsyncValue.loading();
    }
  }
}
