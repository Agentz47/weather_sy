import 'package:hive/hive.dart';
import '../../../../../constants.dart';
import '../../../../../core/network/exceptions.dart';
import '../../../domain/entities/favorite_city.dart';
import '../../models/weather_model.dart';
import '../../models/forecast_model.dart';

class WeatherLocalDataSource {
  Future<void> cacheWeather(String key, WeatherModel weather) async {
    try {
      final box = await Hive.openBox(weatherCacheBox);
      await box.put(key, weather.toJson());
    } catch (e) {
      throw CacheFailure('Failed to cache weather: $e');
    }
  }

  Future<WeatherModel?> getCachedWeather(String key) async {
    try {
      final box = await Hive.openBox(weatherCacheBox);
      final data = box.get(key);
      if (data == null) return null;
      return WeatherModel.fromJson(Map<String, dynamic>.from(data));
    } catch (e) {
      throw CacheFailure('Failed to get cached weather: $e');
    }
  }

  Future<void> cacheForecast(String key, List<ForecastModel> forecast) async {
    try {
      final box = await Hive.openBox(forecastCacheBox);
      await box.put(key, forecast.map((f) => f.toJson()).toList());
    } catch (e) {
      throw CacheFailure('Failed to cache forecast: $e');
    }
  }

  Future<List<ForecastModel>?> getCachedForecast(String key) async {
    try {
      final box = await Hive.openBox(forecastCacheBox);
      final data = box.get(key);
      if (data == null) return null;
      return (data as List).map((item) => ForecastModel.fromJson(Map<String, dynamic>.from(item))).toList();
    } catch (e) {
      throw CacheFailure('Failed to get cached forecast: $e');
    }
  }

  Future<List<FavoriteCity>> getFavorites() async {
    try {
      final box = await Hive.openBox(favoritesBox);
      final favorites = box.values.map((item) {
        final map = Map<String, dynamic>.from(item);
        return FavoriteCity(
          id: map['id'],
          name: map['name'],
          lat: map['lat'],
          lon: map['lon'],
        );
      }).toList();
      return favorites;
    } catch (e) {
      throw CacheFailure('Failed to get favorites: $e');
    }
  }

  Future<void> addFavorite(FavoriteCity city) async {
    try {
      final box = await Hive.openBox(favoritesBox);
      await box.put(city.id, {
        'id': city.id,
        'name': city.name,
        'lat': city.lat,
        'lon': city.lon,
      });
    } catch (e) {
      throw CacheFailure('Failed to add favorite: $e');
    }
  }

  Future<void> removeFavorite(String id) async {
    try {
      final box = await Hive.openBox(favoritesBox);
      await box.delete(id);
    } catch (e) {
      throw CacheFailure('Failed to remove favorite: $e');
    }
  }
}
