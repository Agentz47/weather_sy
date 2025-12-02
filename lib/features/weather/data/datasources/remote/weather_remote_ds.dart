import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/exceptions.dart';
import '../../models/weather_model.dart';
import '../../models/forecast_model.dart';
import '../../models/weather_api_alert_model.dart';

class WeatherRemoteDataSource {
  final ApiClient client;

  WeatherRemoteDataSource(this.client);

  Future<WeatherModel> fetchCurrentWeather(double lat, double lon, {String units = 'metric'}) async {
    try {
      final response = await client.get(
        '/data/2.5/weather',
        queryParameters: {'lat': lat, 'lon': lon, 'units': units},
      );
      final data = response.data;
      // Parse the current weather
      return WeatherModel(
        city: data['name'] ?? 'Unknown',
        lat: lat,
        lon: lon,
        temperature: (data['main']['temp'] as num).toDouble(),
        description: data['weather'][0]['description'],
        icon: data['weather'][0]['icon'],
        humidity: data['main']['humidity'],
        windSpeed: (data['wind']['speed'] as num).toDouble(),
        timestamp: data['dt'],
      );
    } catch (e) {
      throw NetworkFailure('Failed to fetch weather: $e');
    }
  }

  Future<List<ForecastModel>> fetchForecast(double lat, double lon, {String units = 'metric'}) async {
    try {
      final response = await client.get(
        '/data/2.5/forecast',
        queryParameters: {'lat': lat, 'lon': lon, 'units': units, 'cnt': 40},
      );
      final list = response.data['list'] as List;
      
      // Group by day and get daily forecasts
      final Map<String, List<dynamic>> dailyData = {};
      for (var item in list) {
        final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
        final dateKey = '${date.year}-${date.month}-${date.day}';
        if (!dailyData.containsKey(dateKey)) {
          dailyData[dateKey] = [];
        }
        dailyData[dateKey]!.add(item);
      }
      
      // Take first 7 days and calculate min/max temps
      return dailyData.entries.take(7).map((entry) {
        final dayData = entry.value;
        final temps = dayData.map((d) => (d['main']['temp'] as num).toDouble()).toList();
        final firstItem = dayData.first;
        
        return ForecastModel(
          date: firstItem['dt'],
          tempMin: temps.reduce((a, b) => a < b ? a : b),
          tempMax: temps.reduce((a, b) => a > b ? a : b),
          description: firstItem['weather'][0]['description'],
          icon: firstItem['weather'][0]['icon'],
        );
      }).toList();
    } catch (e) {
      throw NetworkFailure('Failed to fetch forecast: $e');
    }
  }

  /// Fetch weather alerts from OpenWeather One Call API 3.0
  /// Note: This requires a paid subscription. Returns empty list if not available.
  Future<List<WeatherApiAlertModel>> fetchAlerts(double lat, double lon) async {
    try {
      final response = await client.get(
        '/data/3.0/onecall',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'exclude': 'current,minutely,hourly,daily',
        },
      );
      
      final alerts = response.data['alerts'] as List?;
      if (alerts == null || alerts.isEmpty) {
        return [];
      }
      
      return alerts.map((alert) => WeatherApiAlertModel.fromJson(alert)).toList();
    } catch (e) {
      // If One Call API is not available (401/403), return empty list
      // This allows the app to work without a paid subscription
      print('API alerts not available: $e');
      return [];
    }
  }
}
