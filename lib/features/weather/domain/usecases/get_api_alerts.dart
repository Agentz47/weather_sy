import '../entities/weather_api_alert.dart';
import '../repositories/weather_repository.dart';

class GetApiAlerts {
  final WeatherRepository repository;

  GetApiAlerts(this.repository);

  Future<List<WeatherApiAlert>> call(double lat, double lon) {
    return repository.getApiAlerts(lat, lon);
  }
}
