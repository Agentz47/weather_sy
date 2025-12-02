import '../repositories/weather_repository.dart';

class RemoveFavorite {
  final WeatherRepository repository;

  RemoveFavorite(this.repository);

  Future<void> call(String id) {
    return repository.removeFavorite(id);
  }
}
