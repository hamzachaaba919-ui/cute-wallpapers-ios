import '../../core/constants/app_constants.dart';
import '../../domain/entities/wallpaper_entity.dart';
import '../../domain/repositories/wallpaper_repository.dart';
import '../../services/local_storage_service.dart';
import '../datasources/wallpaper_local_data_source.dart';

/// Local-only implementation of [WallpaperRepository]: the catalog comes
/// from the bundled JSON asset, favorites are persisted on-device via
/// [LocalStorageService]. Nothing here ever touches the network.
class WallpaperRepositoryImpl implements WallpaperRepository {
  WallpaperRepositoryImpl({
    required WallpaperLocalDataSource dataSource,
    required LocalStorageService storage,
  })  : _dataSource = dataSource,
        _storage = storage;

  final WallpaperLocalDataSource _dataSource;
  final LocalStorageService _storage;

  @override
  Future<List<WallpaperEntity>> getAll() => _dataSource.loadCatalog();

  @override
  Future<WallpaperEntity?> getById(String id) async {
    final List<WallpaperEntity> all = await getAll();
    for (final WallpaperEntity wallpaper in all) {
      if (wallpaper.id == id) return wallpaper;
    }
    return null;
  }

  @override
  Future<List<WallpaperEntity>> getByCollection(String collection) async {
    final List<WallpaperEntity> all = await getAll();
    return all.where((wallpaper) => wallpaper.collection == collection).toList(growable: false);
  }

  @override
  Future<List<WallpaperEntity>> search(String query) async {
    final List<WallpaperEntity> all = await getAll();
    if (query.trim().isEmpty) return const [];
    return all.where((wallpaper) => wallpaper.matches(query)).toList(growable: false);
  }

  @override
  Future<Set<String>> getFavoriteIds() async {
    final List<String> stored = await _storage.getStringList(AppConstants.prefKeyFavorites);
    return stored.toSet();
  }

  @override
  Future<void> setFavoriteIds(Set<String> ids) {
    return _storage.setStringList(AppConstants.prefKeyFavorites, ids.toList(growable: false));
  }
}
