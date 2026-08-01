/// Central registry of route paths and names, referenced instead of raw
/// strings anywhere navigation happens.
abstract final class RouteNames {
  static const String splash = '/';
  static const String home = '/home';
  static const String search = '/search';
  static const String favorites = '/favorites';
  static const String settings = '/settings';

  // Named routes pushed on top of the shell.
  static const String wallpaperDetail = 'wallpaper-detail';
  static const String privacyPolicy = 'privacy-policy';
  static const String termsOfService = 'terms-of-service';
  static const String about = 'about';

  /// Builds the path for a wallpaper detail push, e.g. `/wallpaper/cute-01`.
  static String wallpaperDetailPath(String id) => '/wallpaper/$id';

  const RouteNames._();
}
