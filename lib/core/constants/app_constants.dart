/// Global, non-visual app constants.
abstract final class AppConstants {
  static const String appName = 'Cute Wallpapers';
  static const String appTagline = 'Wallpapers, curated beautifully.';

  // Optional, outbound-only links (opened in the user's browser/mail app).
  // None of these are contacted automatically by the app — it never makes
  // a network request on its own.
  static const String supportEmail = 'hamzugutie@gmail.com';
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.cutewallpapers.cutekawaii';

  // TODO: Replace with the real App Store listing URL
  // (https://apps.apple.com/app/id<YOUR_APP_ID>) once this app has been
  // submitted and an App Store Connect app ID has been assigned. Until
  // then this points at the bundle ID's search results as a safe fallback.
  static const String appStoreUrl =
      'https://apps.apple.com/search?term=com.cutewallpapers.cutekawaii';

  // Local storage keys
  static const String prefKeyThemeMode = 'pref_theme_mode';
  static const String prefKeyFavorites = 'pref_favorites';
  static const String prefKeyRecentSearches = 'pref_recent_searches';

  // Search
  static const int maxRecentSearches = 10;

  const AppConstants._();
}
