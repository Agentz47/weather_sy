import 'package:dio/dio.dart';
import '../../constants.dart';
import 'interceptors.dart';

class ApiClient {
  final Dio _dio;

  ApiClient._(this._dio);

  factory ApiClient() {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.openweathermap.org'));
    dio.interceptors.addAll([AppInterceptor()]);
    return ApiClient._(dio);
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    final params = Map<String, dynamic>.from(queryParameters ?? {});
    params['appid'] = kOpenWeatherApiKey;
    return _dio.get(path, queryParameters: params);
  }
}
