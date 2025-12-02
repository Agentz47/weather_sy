import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/favorite_city.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/add_favorite.dart';
import '../../domain/usecases/remove_favorite.dart';

class FavoritesVm extends StateNotifier<AsyncValue<List<FavoriteCity>>> {
  final GetFavorites getFavorites;
  final AddFavorite addFavorite;
  final RemoveFavorite removeFavorite;

  FavoritesVm(this.getFavorites, this.addFavorite, this.removeFavorite)
      : super(const AsyncValue.loading());

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final favorites = await getFavorites();
      state = AsyncValue.data(favorites);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> add(FavoriteCity city) async {
    await addFavorite(city);
    await load();
  }

  Future<void> remove(String id) async {
    await removeFavorite(id);
    await load();
  }
}
