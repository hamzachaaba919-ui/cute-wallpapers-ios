import 'package:flutter/foundation.dart';

/// Pure domain representation of a wallpaper.
///
/// Everything about a wallpaper — including the image itself — lives on
/// device as a bundled Flutter asset. There is no server-assigned id,
/// download count, or remote URL: [id] is a stable local slug and
/// [assetPath] points straight at `assets/images/wallpapers/…`.
@immutable
class WallpaperEntity {
  final String id;
  final String title;
  final String assetPath;
  final String collection;
  final List<String> tags;
  final int width;
  final int height;
  final bool isFeatured;

  const WallpaperEntity({
    required this.id,
    required this.title,
    required this.assetPath,
    required this.collection,
    required this.width,
    required this.height,
    this.tags = const [],
    this.isFeatured = false,
  });

  double get aspectRatio => height == 0 ? 1 : width / height;

  /// Case-insensitive match used by local search: title, collection, tags.
  bool matches(String query) {
    final String q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return title.toLowerCase().contains(q) ||
        collection.toLowerCase().contains(q) ||
        tags.any((tag) => tag.toLowerCase().contains(q));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is WallpaperEntity && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
