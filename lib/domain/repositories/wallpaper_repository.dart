import '../entities/wallpaper_entity.dart';

/// Contract for reading the bundled wallpaper catalog and managing local
/// favorites. The single implementation ([WallpaperRepositoryImpl]) reads
/// everything from `assets/data/wallpapers.json` and [SharedPreferences] —
/// there is no network-backed implementation.
abstract interface class WallpaperRepository {
  /// Loads (and caches in memory) the full local catalog.
  Future<List<WallpaperEntity>> getAll();

  Future<WallpaperEntity?> getById(String id);

  Future<List<WallpaperEntity>> getByCollection(String collection);

  Future<List<WallpaperEntity>> search(String query);

  /// Ids of wallpapers the user has favorited, persisted locally.
  Future<Set<String>> getFavoriteIds();

  Future<void> setFavoriteIds(Set<String> ids);
}
