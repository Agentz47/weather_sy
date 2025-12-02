import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/ui/components/loading_widget.dart';
import '../../../../core/ui/components/error_widget.dart';
import '../../../../core/ui/components/empty_state_widget.dart';
import '../../../../di/providers.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(favoritesVmProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(favoritesVmProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: state.when(
        data: (favorites) {
          if (favorites.isEmpty) return const EmptyStateWidget(message: 'No favorites yet');
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, i) {
              final city = favorites[i];
              return Dismissible(
                key: Key(city.id),
                onDismissed: (_) => ref.read(favoritesVmProvider.notifier).remove(city.id),
                child: Card(
                  child: ListTile(
                    leading: const Icon(Icons.favorite, color: Colors.red),
                    title: Text(city.name),
                    subtitle: Text('Lat: ${city.lat.toStringAsFixed(2)}, Lon: ${city.lon.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        ref.read(homeVmProvider.notifier).load(city.lat, city.lon);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const LoadingWidget(),
        error: (e, _) => AppErrorWidget(message: e.toString(), onRetry: () => ref.read(favoritesVmProvider.notifier).load()),
      ),
    );
  }
}
