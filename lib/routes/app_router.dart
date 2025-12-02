import 'package:go_router/go_router.dart';
import '../features/weather/presentation/pages/home_page.dart';
import '../features/weather/presentation/pages/search_page.dart';
import '../features/weather/presentation/pages/favorites_page.dart';
import '../features/weather/presentation/pages/forecast_page.dart';
import '../features/weather/presentation/pages/alerts_page.dart';
import '../features/weather/presentation/pages/alert_rules_page.dart';
import '../features/weather/presentation/pages/alert_history_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(path: '/search', builder: (context, state) => const SearchPage()),
      GoRoute(path: '/favorites', builder: (context, state) => const FavoritesPage()),
      GoRoute(path: '/forecast', builder: (context, state) => const ForecastPage()),
      GoRoute(path: '/alerts', builder: (context, state) => const AlertsPage()),
      GoRoute(path: '/alert-rules', builder: (context, state) => const AlertRulesPage()),
      GoRoute(path: '/alert-history', builder: (context, state) => const AlertHistoryPage()),
    ],
  );
}
