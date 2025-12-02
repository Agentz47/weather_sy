import 'package:flutter_test/flutter_test.dart';
import 'package:weather_sy/features/weather/domain/entities/weather.dart';
import 'package:weather_sy/features/weather/domain/entities/forecast.dart';
import 'package:weather_sy/features/weather/domain/entities/favorite_city.dart';
import 'package:weather_sy/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_sy/features/weather/domain/usecases/get_current_weather.dart';

class MockWeatherRepository implements WeatherRepository {
  @override
  Future<Weather> getCurrentWeather(double lat, double lon, {bool forceRefresh = false}) async {
    return Weather(
      city: 'Test City',
      lat: lat,
      lon: lon,
      temperature: 20.0,
      description: 'Clear sky',
      icon: '01d',
      humidity: 50,
      windSpeed: 5.0,
      timestamp: DateTime.now(),
    );
  }

  @override
  Future<List<Forecast>> getForecast(double lat, double lon) {
    throw UnimplementedError();
  }

  @override
  Future<List<FavoriteCity>> getFavorites() {
    throw UnimplementedError();
  }

  @override
  Future<void> addFavorite(FavoriteCity city) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeFavorite(String id) {
    throw UnimplementedError();
  }
}

void main() {
  late GetCurrentWeather useCase;
  late MockWeatherRepository repository;

  setUp(() {
    repository = MockWeatherRepository();
    useCase = GetCurrentWeather(repository);
  });

  test('should return current weather from repository', () async {
    final weather = await useCase(40.7128, -74.0060);
    expect(weather.city, 'Test City');
    expect(weather.temperature, 20.0);
  });
}
