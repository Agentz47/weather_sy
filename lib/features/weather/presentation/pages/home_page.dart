import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ui/components/loading_widget.dart';
import '../../../../di/providers.dart';
import '../../../../app.dart';
import '../widgets/weather_summary_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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
            onSelected: (ThemeMode mode) {
              ref.read(themeModeProvider.notifier).state = mode;
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
      body: state.when(
        data: (weather) => RefreshIndicator(
          onRefresh: () => ref.read(homeVmProvider.notifier).refresh(weather.lat, weather.lon),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              WeatherSummaryCard(weather: weather),
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
              ElevatedButton(onPressed: () => context.push('/forecast'), child: const Text('5-Day Forecast')),
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
                Text(
                  'Oops!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString().replaceAll('Exception: ', ''),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => ref.read(homeVmProvider.notifier).loadCurrentLocation(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => context.push('/search'),
                  icon: const Icon(Icons.search),
                  label: const Text('Search for a City'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(homeVmProvider.notifier).loadCurrentLocation(),
        tooltip: 'Use My Location',
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
