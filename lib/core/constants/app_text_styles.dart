import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Premium typography system.
///
/// Font pairing: Plus Jakarta Sans (display / headings — geometric, modern,
/// confident) with Inter (body / labels — highly legible at small sizes).
/// This mirrors the pairing used by many premium consumer apps and avoids
/// the default, generic look of a single system font.
abstract final class AppTextStyles {
  static TextStyle get _displayBase => GoogleFonts.plusJakartaSans(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: -0.5,
      );

  static TextStyle get _bodyBase => GoogleFonts.inter(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w400,
        height: 1.4,
        letterSpacing: 0,
      );

  // Display
  static TextStyle get displayLarge =>
      _displayBase.copyWith(fontSize: 40, letterSpacing: -1.0);
  static TextStyle get displayMedium =>
      _displayBase.copyWith(fontSize: 32, letterSpacing: -0.8);

  // Headlines
  static TextStyle get headlineLarge =>
      _displayBase.copyWith(fontSize: 28, fontWeight: FontWeight.w700);
  static TextStyle get headlineMedium =>
      _displayBase.copyWith(fontSize: 24, fontWeight: FontWeight.w700);
  static TextStyle get headlineSmall =>
      _displayBase.copyWith(fontSize: 20, fontWeight: FontWeight.w600);

  // Titles
  static TextStyle get titleLarge => _displayBase.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      );
  static TextStyle get titleMedium => _displayBase.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
      );
  static TextStyle get titleSmall => _displayBase.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      );

  // Body
  static TextStyle get bodyLarge => _bodyBase.copyWith(fontSize: 16);
  static TextStyle get bodyMedium => _bodyBase.copyWith(fontSize: 14);
  static TextStyle get bodySmall => _bodyBase.copyWith(
        fontSize: 12,
        color: AppColors.textSecondary,
      );

  // Labels / buttons
  static TextStyle get labelLarge => _bodyBase.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      );
  static TextStyle get labelMedium => _bodyBase.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      );
  static TextStyle get labelSmall => _bodyBase.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.textTertiary,
        letterSpacing: 0.2,
      );

  static TextStyle get caption => _bodyBase.copyWith(
        fontSize: 12,
        color: AppColors.textTertiary,
      );

  static TextStyle get overline => _bodyBase.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 1.2,
      );

  const AppTextStyles._();
}
