import 'package:flutter/foundation.dart';

import '../core/constants/collections.dart';
import '../domain/entities/wallpaper_entity.dart';
import '../domain/repositories/wallpaper_repository.dart';

/// Owns the in-memory wallpaper catalog (loaded once from the bundled JSON
/// asset) plus the currently selected collection filter used by the Home
/// grid. Search is served from the same in-memory list — everything is
/// local, so there's no reason to hit the asset bundle more than once.
class WallpaperProvider extends ChangeNotifier {
  WallpaperProvider(this._repository) {
    _load();
  }

  final WallpaperRepository _repository;

  List<WallpaperEntity> _all = const [];
  bool _isLoading = true;
  Object? _loadError;
  String _selectedCollection = Collections.all;

  bool get isLoading => _isLoading;
  Object? get loadError => _loadError;
  List<WallpaperEntity> get all => _all;
  String get selectedCollection => _selectedCollection;

  List<WallpaperEntity> get featured =>
      _all.where((wallpaper) => wallpaper.isFeatured).toList(growable: false);

  /// Wallpapers matching the currently selected collection chip.
  List<WallpaperEntity> get visible {
    if (_selectedCollection == Collections.all) return _all;
    return _all
        .where((wallpaper) => wallpaper.collection == _selectedCollection)
        .toList(growable: false);
  }

  Future<void> _load() async {
    try {
      _all = await _repository.getAll();
      _loadError = null;
    } catch (error) {
      _loadError = error;
      _all = const [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> reload() async {
    _isLoading = true;
    notifyListeners();
    await _load();
  }

  void selectCollection(String collection) {
    if (_selectedCollection == collection) return;
    _selectedCollection = collection;
    notifyListeners();
  }

  WallpaperEntity? byId(String id) {
    for (final WallpaperEntity wallpaper in _all) {
      if (wallpaper.id == id) return wallpaper;
    }
    return null;
  }

  /// Local, in-memory search across title / collection / tags.
  List<WallpaperEntity> search(String query) {
    if (query.trim().isEmpty) return const [];
    return _all.where((wallpaper) => wallpaper.matches(query)).toList(growable: false);
  }
}
