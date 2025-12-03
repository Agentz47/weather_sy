import 'package:flutter/material.dart';
import 'package:weather_sy/core/network/api_client.dart';
import 'package:weather_sy/features/weather/data/datasources/local/weather_local_ds.dart';
import 'package:weather_sy/features/weather/data/datasources/remote/weather_remote_ds.dart';
import 'package:weather_sy/features/weather/data/repositories/alert_event_repository.dart';
import 'package:weather_sy/features/weather/data/repositories/alert_rule_repository.dart';
import 'package:weather_sy/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weather_sy/features/weather/data/services/alert_evaluation_service.dart';
import 'package:workmanager/workmanager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'features/weather/domain/entities/alert_rule.dart';
import 'features/weather/domain/entities/alert_event.dart';
import 'core/services/notification_service.dart';
import 'di/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Workmanager for background tasks
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true, // Set to false in production
  );
  // Register periodic background task
  await Workmanager().registerPeriodicTask(
    'weatherAlertTask',
    'weatherAlertTask',
    frequency: const Duration(hours: 1), // Check every hour
    initialDelay: const Duration(minutes: 5),
    constraints: Constraints(networkType: NetworkType.connected),
  );
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(AlertRuleAdapter());
  Hive.registerAdapter(AlertEventAdapter());
  
  // Initialize timezone data for scheduled notifications
  tz.initializeTimeZones();
  
  // Initialize notification service
  await NotificationService().initialize();
  
  // Create a container to initialize repositories
  final container = ProviderContainer();
  
  // Initialize repositories
  await container.read(alertRuleRepositoryProvider).init();
  await container.read(alertEventRepositoryProvider).init();
  
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const App(),
    ),
  );
}

// Background callback for Workmanager
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Initialize Hive (required in background isolate)
    await Hive.initFlutter();

    // Load last known location
    final locationBox = await Hive.openBox('locationBox');
    final lat = locationBox.get('lat');
    final lon = locationBox.get('lon');
    await locationBox.close();

    if (lat == null || lon == null) {
      // No location saved, skip background check
      return Future.value(true);
    }

    // Initialize notification service
    final notificationService = NotificationService();
    await notificationService.initialize();

    // Initialize repositories and services
    final apiClient = ApiClient();
    final weatherRemoteDs = WeatherRemoteDataSource(apiClient);
    final weatherLocalDs = WeatherLocalDataSource();
    final weatherRepo = WeatherRepositoryImpl(weatherRemoteDs, weatherLocalDs);
    final alertRuleRepo = AlertRuleRepository();
    final alertEventRepo = AlertEventRepository();
    final alertEvaluationService = AlertEvaluationService(
      alertRuleRepo,
      alertEventRepo,
      notificationService,
    );

    // Fetch current weather
    final weather = await weatherRepo.getCurrentWeather(lat, lon, forceRefresh: true);

    // Evaluate alert rules and trigger notifications
    await alertEvaluationService.evaluateRules(weather);

    return Future.value(true);
  });
}
