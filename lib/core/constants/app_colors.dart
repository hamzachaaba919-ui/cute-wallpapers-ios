import 'package:flutter/material.dart';

/// Centralized color system for Cute Wallpapers.
///
/// A soft pastel palette — pink, lavender, peach, cream, white — built for
/// a premium-but-cute feel: clean light surfaces by default, with a softer
/// "plum dusk" dark mode as the secondary option (never AMOLED black).
abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFFFF8FAE); // soft pink
  static const Color primaryLight = Color(0xFFFFB0C9);
  static const Color primaryDark = Color(0xFFE56E92);

  static const Color secondary = Color(0xFFB6A6E8); // lavender
  static const Color secondaryLight = Color(0xFFD2C6F5);

  static const Color accent = Color(0xFFFFC29A); // peach
  static const Color accentLight = Color(0xFFFFD9BC);

  static const Color cream = Color(0xFFFFF6EE);

  // Light surfaces (default, primary experience)
  static const Color background = Color(0xFFFFF8F3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFFFDFB);
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFF3E3EC);

  // Dark surfaces ("plum dusk" — soft, not AMOLED black)
  static const Color backgroundDark = Color(0xFF261C2C);
  static const Color surfaceDark = Color(0xFF2F2236);
  static const Color cardDark = Color(0xFF3A2B42);
  static const Color cardBorderDark = Color(0xFF4B3A54);

  // Text — light theme
  static const Color textPrimary = Color(0xFF3B2C3E);
  static const Color textSecondary = Color(0xFF8C7B8C);
  static const Color textTertiary = Color(0xFFB6A6B6);

  // Text — dark theme
  static const Color textPrimaryDark = Color(0xFFF7EEF4);
  static const Color textSecondaryDark = Color(0xFFC2AFC8);
  static const Color textTertiaryDark = Color(0xFF9884A0);

  // Semantic
  static const Color success = Color(0xFF74C69D);
  static const Color error = Color(0xFFF07C88);
  static const Color warning = Color(0xFFF5B971);
  static const Color info = Color(0xFF9BB8F0);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, primary],
  );

  static const LinearGradient dreamyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFE3EC), Color(0xFFEFE2FA), Color(0xFFFFEBDD)],
  );

  /// A very subtle white → soft pink → lavender wash used behind the Home
  /// screen — barely-there tinting rather than a bold gradient.
  static const LinearGradient homeBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFFFF3F6), Color(0xFFF6F1FC)],
    stops: [0.0, 0.45, 1.0],
  );

  /// Legibility scrim behind text overlaid on a wallpaper thumbnail/photo.
  static const LinearGradient heroOverlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC000000)],
    stops: [0.3, 1.0],
  );

  /// Frosted-glass fill used by [GlassCard] — a soft white frost that reads
  /// consistently whether it sits over a pastel background or a photo.
  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xE6FFFFFF), Color(0xB3FFFFFF)],
  );

  static const Color glassBorder = Color(0x99FFFFFF);

  // Shimmer (soft pastel sweep — never a dark gray block)
  static const Color shimmerBase = Color(0xFFF4E7EF);
  static const Color shimmerHighlight = Color(0xFFFFFDFC);

  // Overlays / dividers
  static const Color divider = Color(0xFFF3E3EC);
  static const Color dividerDark = Color(0xFF4B3A54);
  static const Color overlayScrim = Color(0x8A2A1B2E);

  /// Warm, low-opacity shadow used for the "floating card" look — softer
  /// and warmer than a flat black shadow.
  static const Color shadow = Color(0x2ED88CA8);
  static const Color shadowStrong = Color(0x40C97E9C);

  const AppColors._();
}
