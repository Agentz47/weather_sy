import 'package:flutter/material.dart';
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
