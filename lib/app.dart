import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/ui/theme/app_theme.dart';
import 'core/ui/theme/theme_mode_service.dart';
import 'routes/app_router.dart';

// Async provider for theme mode
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) => ThemeModeNotifier());

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final mode = await ThemeModeService.loadThemeMode();
    state = mode;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await ThemeModeService.saveThemeMode(mode);
  }
}


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: const AppContent(),
    );
  }
}

class AppContent extends ConsumerWidget {
  const AppContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'WeatherSY',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
