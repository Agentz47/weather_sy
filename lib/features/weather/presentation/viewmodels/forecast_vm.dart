import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/forecast.dart';
import '../../domain/usecases/get_forecast.dart';

class ForecastVm extends StateNotifier<AsyncValue<List<Forecast>>> {
  final GetForecast getForecast;

  ForecastVm(this.getForecast) : super(const AsyncValue.loading());

  Future<void> load(double lat, double lon) async {
    state = const AsyncValue.loading();
    try {
      final forecast = await getForecast(lat, lon);
      state = AsyncValue.data(forecast);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
