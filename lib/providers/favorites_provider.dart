import 'package:flutter/foundation.dart';

import '../domain/entities/wallpaper_entity.dart';
import '../domain/repositories/wallpaper_repository.dart';

/// Persisted, offline favorites. Ids are stored locally via
/// [WallpaperRepository.setFavoriteIds] (backed by SharedPreferences) — no
/// account, no sync, nothing ever leaves the device.
class FavoritesProvider extends ChangeNotifier {
  FavoritesProvider(this._repository) {
    _restore();
  }

  final WallpaperRepository _repository;

  Set<String> _favoriteIds = <String>{};
  bool _isRestored = false;

  bool get isRestored => _isRestored;
  Set<String> get favoriteIds => _favoriteIds;

  bool isFavorite(String id) => _favoriteIds.contains(id);

  List<WallpaperEntity> filter(List<WallpaperEntity> catalog) {
    return catalog.where((wallpaper) => _favoriteIds.contains(wallpaper.id)).toList(growable: false);
  }

  Future<void> _restore() async {
    _favoriteIds = await _repository.getFavoriteIds();
    _isRestored = true;
    notifyListeners();
  }

  Future<void> toggle(String id) async {
    final Set<String> updated = Set<String>.from(_favoriteIds);
    if (!updated.remove(id)) {
      updated.add(id);
    }
    _favoriteIds = updated;
    notifyListeners();
    await _repository.setFavoriteIds(updated);
  }
}
