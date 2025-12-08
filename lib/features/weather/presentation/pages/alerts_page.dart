import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/ui/components/empty_state_widget.dart';
import '../../../../core/ui/components/loading_widget.dart';
import '../../../../core/ui/components/error_widget.dart';
import '../../../../di/providers.dart';
import '../widgets/alert_card.dart';

class AlertsPage extends ConsumerStatefulWidget {
  const AlertsPage({super.key});

  @override
  ConsumerState<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends ConsumerState<AlertsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final homeState = ref.read(homeVmProvider);
      final weather = homeState.weather;
      if (weather != null) {
        ref.read(alertsVmProvider.notifier).checkAlerts(weather);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(alertsVmProvider);
    final homeState = ref.watch(homeVmProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Alerts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final weather = homeState.weather;
              if (weather != null) {
                ref.read(alertsVmProvider.notifier).checkAlerts(weather);
              }
            },
          ),
        ],
      ),
      body: state.when(
        data: (alerts) {
          if (alerts.isEmpty) {
            return const EmptyStateWidget(
              message: 'No weather alerts at this time',
              icon: Icons.check_circle_outline,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: alerts.length,
            itemBuilder: (context, i) => AlertCard(alert: alerts[i]),
          );
        },
        loading: () => const LoadingWidget(),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () {
            final weather = homeState.weather;
            if (weather != null) {
              ref.read(alertsVmProvider.notifier).checkAlerts(weather);
            }
          },
        ),
      ),
    );
  }
}
