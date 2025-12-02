import '../entities/favorite_city.dart';
import '../repositories/weather_repository.dart';

class AddFavorite {
  final WeatherRepository repository;

  AddFavorite(this.repository);

  Future<void> call(FavoriteCity city) {
    return repository.addFavorite(city);
  }
}
