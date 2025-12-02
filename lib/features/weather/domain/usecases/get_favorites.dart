import '../entities/favorite_city.dart';
import '../repositories/weather_repository.dart';

class GetFavorites {
  final WeatherRepository repository;

  GetFavorites(this.repository);

  Future<List<FavoriteCity>> call() {
    return repository.getFavorites();
  }
}
