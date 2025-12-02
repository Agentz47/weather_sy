import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

class GetCurrentWeather {
  final WeatherRepository repository;

  GetCurrentWeather(this.repository);

  Future<Weather> call(double lat, double lon) {
    return repository.getCurrentWeather(lat, lon);
  }
}
