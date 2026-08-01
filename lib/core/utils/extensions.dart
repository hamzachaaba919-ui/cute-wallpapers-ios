import 'package:flutter/material.dart';

/// Small, focused extensions used throughout the presentation layer to keep
/// widget code terse and readable.
extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Size get screenSize => MediaQuery.sizeOf(this);
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);
  double get statusBarHeight => MediaQuery.viewPaddingOf(this).top;
  double get bottomSafeArea => MediaQuery.viewPaddingOf(this).bottom;

  void showSnack(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

extension DateTimeGreetingX on DateTime {
  /// A time-aware greeting used on the Home header.
  String get greeting {
    final int h = hour;
    if (h < 5) return 'Good night';
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    if (h < 21) return 'Good evening';
    return 'Good night';
  }
}

extension StringX on String {
  String get capitalized =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
