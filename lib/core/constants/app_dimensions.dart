/// Centralized spacing, radius, and sizing scale.
///
/// Keeping every screen on this scale is what gives the app its
/// "perfect spacing" premium feel — never hardcode raw numbers in widgets.
abstract final class AppDimensions {
  // Spacing scale
  static const double space4 = 4;
  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space20 = 20;
  static const double space24 = 24;
  static const double space32 = 32;
  static const double space28 = 28;
  static const double space40 = 40;
  static const double space48 = 48;
  static const double space64 = 64;

  // Radius scale — soft, rounded, 20-28px on primary surfaces.
  static const double radiusSmall = 16;
  static const double radiusMedium = 20;
  static const double radiusLarge = 28;
  static const double radiusXLarge = 34;
  static const double radiusPill = 999;

  /// Wallpaper grid/thumbnail card corner radius — a touch larger than
  /// [radiusLarge] so cards read as the app's premium centerpiece.
  static const double radiusCard = 26;

  // Page padding
  static const double pageHorizontalPadding = 20;

  // Component sizing
  static const double buttonHeight = 56;
  static const double buttonHeightSmall = 44;
  static const double iconSizeSmall = 18;
  static const double iconSizeMedium = 24;
  static const double iconSizeLarge = 32;

  static const double categoryChipHeight = 46;
  static const double navBarHeight = 74;
  static const double appBarHeight = 64;

  // Grid
  static const double gridSpacing = 20;
  static const int gridCrossAxisCount = 2;
  static const double wallpaperCardAspectRatio = 0.65;

  // Elevation surrogate (used for shadow opacity, not Material elevation)
  static const double elevationLow = 0.06;
  static const double elevationMedium = 0.12;
  static const double elevationHigh = 0.24;

  // Animation durations (in milliseconds)
  static const int durationFast = 180;
  static const int durationMedium = 320;
  static const int durationSlow = 480;

  const AppDimensions._();
}
