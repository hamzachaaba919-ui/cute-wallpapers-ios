import '../../domain/entities/wallpaper_entity.dart';

/// Data-layer representation of [WallpaperEntity], responsible for
/// (de)serializing the bundled `assets/data/wallpapers.json` catalog.
class WallpaperModel extends WallpaperEntity {
  const WallpaperModel({
    required super.id,
    required super.title,
    required super.assetPath,
    required super.collection,
    required super.width,
    required super.height,
    super.tags,
    super.isFeatured,
  });

  factory WallpaperModel.fromJson(Map<String, dynamic> json) {
    return WallpaperModel(
      id: json['id'] as String,
      title: json['title'] as String,
      assetPath: json['assetPath'] as String,
      collection: json['collection'] as String? ?? 'Cute',
      width: json['width'] as int? ?? 1080,
      height: json['height'] as int? ?? 1920,
      tags: (json['tags'] as List<dynamic>? ?? const [])
          .map((dynamic tag) => tag.toString())
          .toList(),
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'assetPath': assetPath,
      'collection': collection,
      'width': width,
      'height': height,
      'tags': tags,
      'isFeatured': isFeatured,
    };
  }
}
