import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/weather.dart';
import '../../domain/entities/weather_alert.dart';

class AlertsVm extends StateNotifier<AsyncValue<List<WeatherAlert>>> {
  AlertsVm() : super(const AsyncValue.data([]));

  void checkAlerts(Weather weather) {
    state = const AsyncValue.loading();
    
    try {
      final alerts = <WeatherAlert>[];
      final now = DateTime.now();

      // Check for extreme temperatures
      if (weather.temperature > 40) {
        alerts.add(WeatherAlert(
          id: 'extreme_heat_${now.millisecondsSinceEpoch}',
          title: 'Extreme Heat Warning',
          description: 'Temperature is ${weather.temperature.toStringAsFixed(1)}°C, which is dangerously high.',
          timestamp: now,
          severity: 'extreme',
          type: 'temperature',
          recommendation: 'Stay indoors, drink plenty of water, and avoid strenuous activities.',
        ));
      } else if (weather.temperature > 35) {
        alerts.add(WeatherAlert(
          id: 'high_heat_${now.millisecondsSinceEpoch}',
          title: 'High Temperature Alert',
          description: 'Temperature is ${weather.temperature.toStringAsFixed(1)}°C.',
          timestamp: now,
          severity: 'moderate',
          type: 'temperature',
          recommendation: 'Stay hydrated and limit outdoor activities during peak hours.',
        ));
      }

      if (weather.temperature < -10) {
        alerts.add(WeatherAlert(
          id: 'extreme_cold_${now.millisecondsSinceEpoch}',
          title: 'Extreme Cold Warning',
          description: 'Temperature is ${weather.temperature.toStringAsFixed(1)}°C, which is dangerously low.',
          timestamp: now,
          severity: 'extreme',
          type: 'temperature',
          recommendation: 'Stay indoors, dress in layers if going outside, and watch for frostbite.',
        ));
      } else if (weather.temperature < 0) {
        alerts.add(WeatherAlert(
          id: 'freezing_${now.millisecondsSinceEpoch}',
          title: 'Freezing Temperature',
          description: 'Temperature is below freezing at ${weather.temperature.toStringAsFixed(1)}°C.',
          timestamp: now,
          severity: 'moderate',
          type: 'temperature',
          recommendation: 'Dress warmly and be cautious of icy conditions.',
        ));
      }

      // Check for high wind speeds
      if (weather.windSpeed > 20) {
        alerts.add(WeatherAlert(
          id: 'high_wind_${now.millisecondsSinceEpoch}',
          title: 'High Wind Warning',
          description: 'Wind speed is ${weather.windSpeed.toStringAsFixed(1)} m/s.',
          timestamp: now,
          severity: 'severe',
          type: 'wind',
          recommendation: 'Secure loose objects and avoid outdoor activities.',
        ));
      } else if (weather.windSpeed > 15) {
        alerts.add(WeatherAlert(
          id: 'strong_wind_${now.millisecondsSinceEpoch}',
          title: 'Strong Wind Advisory',
          description: 'Wind speed is ${weather.windSpeed.toStringAsFixed(1)} m/s.',
          timestamp: now,
          severity: 'moderate',
          type: 'wind',
          recommendation: 'Be cautious when driving and secure outdoor items.',
        ));
      }

      // Check for severe weather conditions
      final condition = weather.description.toLowerCase();
      if (condition.contains('thunderstorm') || condition.contains('storm')) {
        alerts.add(WeatherAlert(
          id: 'thunderstorm_${now.millisecondsSinceEpoch}',
          title: 'Thunderstorm Alert',
          description: 'Severe thunderstorm conditions detected.',
          timestamp: now,
          severity: 'severe',
          type: 'condition',
          recommendation: 'Stay indoors, avoid windows, and unplug electronic devices.',
        ));
      }

      if (condition.contains('tornado')) {
        alerts.add(WeatherAlert(
          id: 'tornado_${now.millisecondsSinceEpoch}',
          title: 'Tornado Warning',
          description: 'Tornado conditions detected in your area.',
          timestamp: now,
          severity: 'extreme',
          type: 'condition',
          recommendation: 'Seek shelter immediately in a basement or interior room.',
        ));
      }

      if (condition.contains('snow') || condition.contains('blizzard')) {
        alerts.add(WeatherAlert(
          id: 'snow_${now.millisecondsSinceEpoch}',
          title: 'Snow/Winter Weather Advisory',
          description: 'Snowy conditions may affect travel.',
          timestamp: now,
          severity: 'moderate',
          type: 'condition',
          recommendation: 'Drive carefully, maintain safe distances, and avoid unnecessary travel.',
        ));
      }

      if (condition.contains('fog') || condition.contains('mist')) {
        alerts.add(WeatherAlert(
          id: 'fog_${now.millisecondsSinceEpoch}',
          title: 'Low Visibility Advisory',
          description: 'Foggy conditions reducing visibility.',
          timestamp: now,
          severity: 'minor',
          type: 'condition',
          recommendation: 'Use headlights and drive slowly with increased following distance.',
        ));
      }

      // Check for poor air quality based on humidity
      if (weather.humidity > 90) {
        alerts.add(WeatherAlert(
          id: 'high_humidity_${now.millisecondsSinceEpoch}',
          title: 'High Humidity Alert',
          description: 'Humidity is at ${weather.humidity}%, which may cause discomfort.',
          timestamp: now,
          severity: 'minor',
          type: 'condition',
          recommendation: 'Stay cool and hydrated, use air conditioning if available.',
        ));
      }

      state = AsyncValue.data(alerts);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}
