import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/exceptions.dart';
import '../../../domain/entities/city_search_result.dart';

class GeocodingDataSource {
  final ApiClient client;

  GeocodingDataSource(this.client);

  Future<List<CitySearchResult>> searchCity(String cityName) async {
    try {
      final response = await client.get(
        '/geo/1.0/direct',
        queryParameters: {'q': cityName, 'limit': 5},
      );
      
      final data = response.data as List;
      return data.map((item) {
        return CitySearchResult(
          name: item['name'],
          lat: (item['lat'] as num).toDouble(),
          lon: (item['lon'] as num).toDouble(),
          country: item['country'] ?? '',
        );
      }).toList();
    } catch (e) {
      throw NetworkFailure('Failed to search city: $e');
    }
  }
}
