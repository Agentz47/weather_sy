import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote/geocoding_ds.dart';
import '../../domain/entities/city_search_result.dart';

class SearchVm extends StateNotifier<AsyncValue<List<CitySearchResult>>> {
  final GeocodingDataSource geocodingDataSource;

  SearchVm(this.geocodingDataSource) : super(const AsyncValue.data([]));

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    
    state = const AsyncValue.loading();
    try {
      final results = await geocodingDataSource.searchCity(query);
      state = AsyncValue.data(results);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  void clear() {
    state = const AsyncValue.data([]);
  }
}
