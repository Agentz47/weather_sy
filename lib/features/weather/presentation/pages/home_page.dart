import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ui/components/loading_widget.dart';
import '../../../../di/providers.dart';
import '../../../../app.dart';
import '../../../../core/ui/components/error_message_mapper.dart';
import '../widgets/weather_summary_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
    // ...existing code...
  @override
  void initState() {
    super.initState();
    // Load weather using current location or fallback to default
    Future.microtask(() => ref.read(homeVmProvider.notifier).loadCurrentLocation());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeVmProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('WeatherSY'),
        actions: [
          PopupMenuButton<ThemeMode>(
            icon: Icon(
              themeMode == ThemeMode.dark
                  ? Icons.dark_mode
                  : themeMode == ThemeMode.light
                      ? Icons.light_mode
                      : Icons.brightness_auto,
            ),
            tooltip: 'Change Theme',
            onSelected: (ThemeMode mode) async {
              await ref.read(themeModeProvider.notifier).setThemeMode(mode);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: ThemeMode.light,
                child: Row(
                  children: [
                    Icon(Icons.light_mode),
                    SizedBox(width: 8),
                    Text('Light Theme'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: ThemeMode.dark,
                child: Row(
                  children: [
                    Icon(Icons.dark_mode),
                    SizedBox(width: 8),
                    Text('Dark Theme'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: ThemeMode.system,
                child: Row(
                  children: [
                    Icon(Icons.brightness_auto),
                    SizedBox(width: 8),
                    Text('System Default'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.lightBlue],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.cloud, size: 48, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'WeatherSY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Weather Alert System',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search City'),
              onTap: () {
                Navigator.pop(context);
                context.push('/search');
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorites'),
              onTap: () {
                Navigator.pop(context);
                context.push('/favorites');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.rule),
              title: const Text('Alert Rules'),
              onTap: () {
                Navigator.pop(context);
                context.push('/alert-rules');
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Alert History'),
              onTap: () {
                Navigator.pop(context);
                context.push('/alert-history');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notification Settings'),
              onTap: () async {
                Navigator.pop(context);
                
                // Request basic notification permissions
                await ref.read(notificationServiceProvider).requestPermissions();
                
                // Request exact alarm permission (Android 12+)
                final exactGranted = await ref.read(notificationServiceProvider).requestExactAlarmPermission();
                
                if (context.mounted) {
                  String message = 'Notification permissions updated';
                  if (!exactGranted) {
                    message += '. Note: Daily summaries require exact alarm permission (enable in Settings > Apps > WeatherSY > Alarms & reminders)';
                  }
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: state.asyncValue.when(
        data: (weather) => RefreshIndicator(
          onRefresh: () => ref.read(homeVmProvider.notifier).refresh(weather.lat, weather.lon),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              WeatherSummaryCard(
                weather: weather,
                usedLastKnownLocation: state.usedLastKnownLocation,
              ),
              // Display API alerts if any
              if (state.apiAlerts.isNotEmpty) ...[
                const SizedBox(height: 16),
                Card(
                  color: Colors.orange.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.warning_amber, color: Colors.orange.shade800),
                            const SizedBox(width: 8),
                            Text(
                              'Weather Alerts',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...state.apiAlerts.where((a) => a.isActive).map((alert) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alert.event,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(alert.description,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              )),
                              const SizedBox(height: 4),
                              Text(
                                'Valid until: ${alert.endTime}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.read(homeVmProvider.notifier).loadCurrentLocation(),
                icon: const Icon(Icons.my_location),
                label: const Text('Use My Location'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: ElevatedButton(onPressed: () => context.push('/search'), child: const Text('Search'))),
                  const SizedBox(width: 8),
                  Expanded(child: ElevatedButton(onPressed: () => context.push('/favorites'), child: const Text('Favorites'))),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: () => context.push('/forecast'), child: const Text('Forecast')),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: () => context.push('/alerts'), child: const Text('Alerts')),
            ],
          ),
        ),
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.shade300,
                ),
                const SizedBox(height: 16),
                Text(mapErrorToMessage(e),
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                if (e.toString().contains('NetworkFailure')) ...[
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => ref.read(homeVmProvider.notifier).loadCurrentLocation(),
                    child: const Text('Retry'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

  }}