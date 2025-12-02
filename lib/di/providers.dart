import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/api_client.dart';
import '../core/services/location_service.dart';
import '../features/weather/data/datasources/remote/weather_remote_ds.dart';
import '../features/weather/data/datasources/remote/geocoding_ds.dart';
import '../features/weather/data/datasources/local/weather_local_ds.dart';
import '../features/weather/data/repositories/weather_repository_impl.dart';
import '../features/weather/domain/repositories/weather_repository.dart';
import '../features/weather/domain/usecases/get_current_weather.dart';
import '../features/weather/domain/usecases/get_forecast.dart';
import '../features/weather/domain/usecases/add_favorite.dart';
import '../features/weather/domain/usecases/remove_favorite.dart';
import '../features/weather/domain/usecases/get_favorites.dart';
import '../features/weather/presentation/viewmodels/home_vm.dart';
import '../features/weather/presentation/viewmodels/search_vm.dart';
import '../features/weather/presentation/viewmodels/favorites_vm.dart';
import '../features/weather/presentation/viewmodels/forecast_vm.dart';
import '../features/weather/presentation/viewmodels/alerts_vm.dart';
import '../features/weather/domain/entities/weather.dart';
import '../features/weather/domain/entities/forecast.dart';
import '../features/weather/domain/entities/favorite_city.dart';
import '../features/weather/domain/entities/city_search_result.dart';
import '../features/weather/domain/entities/weather_alert.dart';

// Services
final locationServiceProvider = Provider<LocationService>((ref) => LocationService());

// Network
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

// Data sources
final weatherRemoteDataSourceProvider = Provider<WeatherRemoteDataSource>(
  (ref) => WeatherRemoteDataSource(ref.watch(apiClientProvider)),
);
final geocodingDataSourceProvider = Provider<GeocodingDataSource>(
  (ref) => GeocodingDataSource(ref.watch(apiClientProvider)),
);
final weatherLocalDataSourceProvider = Provider<WeatherLocalDataSource>(
  (ref) => WeatherLocalDataSource(),
);

// Repository
final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => WeatherRepositoryImpl(
    ref.watch(weatherRemoteDataSourceProvider),
    ref.watch(weatherLocalDataSourceProvider),
  ),
);

// Use cases
final getCurrentWeatherProvider = Provider<GetCurrentWeather>(
  (ref) => GetCurrentWeather(ref.watch(weatherRepositoryProvider)),
);
final getForecastProvider = Provider<GetForecast>(
  (ref) => GetForecast(ref.watch(weatherRepositoryProvider)),
);
final addFavoriteProvider = Provider<AddFavorite>(
  (ref) => AddFavorite(ref.watch(weatherRepositoryProvider)),
);
final removeFavoriteProvider = Provider<RemoveFavorite>(
  (ref) => RemoveFavorite(ref.watch(weatherRepositoryProvider)),
);
final getFavoritesProvider = Provider<GetFavorites>(
  (ref) => GetFavorites(ref.watch(weatherRepositoryProvider)),
);

// ViewModels
final homeVmProvider = StateNotifierProvider<HomeVm, AsyncValue<Weather>>(
  (ref) => HomeVm(
    ref.watch(getCurrentWeatherProvider),
    ref.watch(locationServiceProvider),
  ),
);
final searchVmProvider = StateNotifierProvider<SearchVm, AsyncValue<List<CitySearchResult>>>(
  (ref) => SearchVm(ref.watch(geocodingDataSourceProvider)),
);
final favoritesVmProvider = StateNotifierProvider<FavoritesVm, AsyncValue<List<FavoriteCity>>>(
  (ref) => FavoritesVm(
    ref.watch(getFavoritesProvider),
    ref.watch(addFavoriteProvider),
    ref.watch(removeFavoriteProvider),
  ),
);
final forecastVmProvider = StateNotifierProvider<ForecastVm, AsyncValue<List<Forecast>>>(
  (ref) => ForecastVm(ref.watch(getForecastProvider)),
);
final alertsVmProvider = StateNotifierProvider<AlertsVm, AsyncValue<List<WeatherAlert>>>(
  (ref) => AlertsVm(),
);
