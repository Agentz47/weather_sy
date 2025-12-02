import '../entities/weather.dart';
import '../entities/forecast.dart';
import '../entities/favorite_city.dart';

abstract class WeatherRepository {
  Future<Weather> getCurrentWeather(double lat, double lon, {bool forceRefresh = false});
  Future<List<Forecast>> getForecast(double lat, double lon);
  Future<List<FavoriteCity>> getFavorites();
  Future<void> addFavorite(FavoriteCity city);
  Future<void> removeFavorite(String id);
}
