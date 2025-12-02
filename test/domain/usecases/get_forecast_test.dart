import 'package:flutter_test/flutter_test.dart';
import 'package:weather_sy/features/weather/domain/entities/forecast.dart';
import 'package:weather_sy/features/weather/domain/entities/weather.dart';
import 'package:weather_sy/features/weather/domain/entities/favorite_city.dart';
import 'package:weather_sy/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_sy/features/weather/domain/usecases/get_forecast.dart';

class MockWeatherRepository implements WeatherRepository {
  @override
  Future<List<Forecast>> getForecast(double lat, double lon) async {
    return [
      Forecast(date: DateTime.now(), tempMin: 15.0, tempMax: 25.0, description: 'Sunny', icon: '01d'),
    ];
  }

  @override
  Future<Weather> getCurrentWeather(double lat, double lon, {bool forceRefresh = false}) {
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
  late GetForecast useCase;
  late MockWeatherRepository repository;

  setUp(() {
    repository = MockWeatherRepository();
    useCase = GetForecast(repository);
  });

  test('should return forecast from repository', () async {
    final forecast = await useCase(40.7128, -74.0060);
    expect(forecast.length, 1);
    expect(forecast.first.description, 'Sunny');
  });
}
