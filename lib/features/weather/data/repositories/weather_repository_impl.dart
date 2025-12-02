import '../../domain/entities/weather.dart';
import '../../domain/entities/forecast.dart';
import '../../domain/entities/favorite_city.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/remote/weather_remote_ds.dart';
import '../datasources/local/weather_local_ds.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;

  WeatherRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Weather> getCurrentWeather(double lat, double lon, {bool forceRefresh = false}) async {
    final key = 'weather_${lat}_$lon';
    
    if (!forceRefresh) {
      // Check cache first
      final cached = await localDataSource.getCachedWeather(key);
      if (cached != null) {
        // Check if cache is still fresh (within 10 minutes)
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(cached.timestamp * 1000);
        final now = DateTime.now();
        if (now.difference(cacheTime).inMinutes < 10) {
          return cached.toEntity();
        }
      }
    }
    
    // Fetch fresh data from API
    final weather = await remoteDataSource.fetchCurrentWeather(lat, lon);
    await localDataSource.cacheWeather(key, weather);
    return weather.toEntity();
  }

  @override
  Future<List<Forecast>> getForecast(double lat, double lon) async {
    final key = 'forecast_${lat}_$lon';
    // TODO: implement TTL logic (6 hours)
    final cached = await localDataSource.getCachedForecast(key);
    if (cached != null) {
      return cached.map((f) => f.toEntity()).toList();
    }
    final forecast = await remoteDataSource.fetchForecast(lat, lon);
    await localDataSource.cacheForecast(key, forecast);
    return forecast.map((f) => f.toEntity()).toList();
  }

  @override
  Future<List<FavoriteCity>> getFavorites() async {
    return localDataSource.getFavorites();
  }

  @override
  Future<void> addFavorite(FavoriteCity city) async {
    await localDataSource.addFavorite(city);
  }

  @override
  Future<void> removeFavorite(String id) async {
    await localDataSource.removeFavorite(id);
  }
}
