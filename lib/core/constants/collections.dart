import 'package:flutter/material.dart';

/// The small, fixed set of wallpaper collections used to lightly group the
/// catalog. Deliberately flat — a handful of filter chips, not a category
/// browsing hierarchy — because the point of the app is browsing wallpapers,
/// not navigating a taxonomy.
abstract final class Collections {
  static const String all = 'All';

  static const List<String> values = [
    'Cute',
    'Kawaii',
    'Animals',
    'Aesthetic',
    'Pink',
  ];

  /// Chip row order, including the synthetic "All" filter.
  static const List<String> chipOrder = [all, ...values];

  static IconData iconFor(String collection) {
    switch (collection) {
      case 'Cute':
        return Icons.favorite_rounded;
      case 'Kawaii':
        return Icons.emoji_emotions_rounded;
      case 'Animals':
        return Icons.pets_rounded;
      case 'Aesthetic':
        return Icons.auto_awesome_rounded;
      case 'Pink':
        return Icons.local_florist_rounded;
      default:
        return Icons.apps_rounded;
    }
  }

  const Collections._();
}
