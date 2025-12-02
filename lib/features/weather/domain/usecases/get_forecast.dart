import '../entities/forecast.dart';
import '../repositories/weather_repository.dart';

class GetForecast {
  final WeatherRepository repository;

  GetForecast(this.repository);

  Future<List<Forecast>> call(double lat, double lon) {
    return repository.getForecast(lat, lon);
  }
}
