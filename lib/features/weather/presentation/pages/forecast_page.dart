import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/ui/components/loading_widget.dart';
import '../../../../core/ui/components/error_widget.dart';
import '../../../../core/ui/components/error_message_mapper.dart';
import '../../../../di/providers.dart';
import '../widgets/forecast_day_tile.dart';
import '../widgets/forecast_chart.dart';

class ForecastPage extends ConsumerStatefulWidget {
  const ForecastPage({super.key});

  @override
  ConsumerState<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends ConsumerState<ForecastPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final homeState = ref.read(homeVmProvider);
      final weather = homeState.weather;
      if (weather != null) {
        ref.read(forecastVmProvider.notifier).load(weather.lat, weather.lon);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forecastVmProvider);
    final homeState = ref.watch(homeVmProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Forecast')),
      body: state.when(
        data: (forecast) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ForecastChart(forecasts: forecast),
            const SizedBox(height: 16),
            ...forecast.map((f) => ForecastDayTile(forecast: f)),
          ],
        ),
        loading: () => const LoadingWidget(),
        error: (e, _) => AppErrorWidget(
          message: mapErrorToMessage(e),
          onRetry: () {
            final weather = homeState.weather;
            if (weather != null) {
              ref.read(forecastVmProvider.notifier).load(weather.lat, weather.lon);
            }
          },
        ),
      ),
    );
  }
}
