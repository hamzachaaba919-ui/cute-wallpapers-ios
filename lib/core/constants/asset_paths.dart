/// Centralized asset path references.
///
/// Referencing paths through this class (instead of inline strings) means a
/// renamed or moved asset only needs to be updated in one place.
abstract final class AssetPaths {
  /// The local wallpaper catalog. Every image referenced inside it lives
  /// under `assets/images/wallpapers/`.
  static const String wallpapersData = 'assets/data/wallpapers.json';

  const AssetPaths._();
}
