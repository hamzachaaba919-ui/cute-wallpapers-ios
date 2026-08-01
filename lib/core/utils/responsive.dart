import 'package:flutter/material.dart';

/// Breakpoints and helpers for building a layout that scales gracefully
/// from small phones up to tablets/foldables.
abstract final class Responsive {
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileMaxWidth;

  static bool isTablet(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return width >= mobileMaxWidth && width < tabletMaxWidth;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletMaxWidth;

  /// Number of columns for the wallpaper grid based on available width.
  static int gridColumns(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    if (width >= tabletMaxWidth) return 4;
    if (width >= mobileMaxWidth) return 3;
    return 2;
  }

  /// Horizontal page padding that grows slightly on larger screens.
  static double pagePadding(BuildContext context) {
    if (isDesktop(context)) return 48;
    if (isTablet(context)) return 32;
    return 20;
  }

  /// Clamps content to a comfortable reading/viewing width on very large
  /// screens instead of letting cards stretch edge-to-edge.
  static double maxContentWidth(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return width >= tabletMaxWidth ? 960 : width;
  }

  const Responsive._();
}
