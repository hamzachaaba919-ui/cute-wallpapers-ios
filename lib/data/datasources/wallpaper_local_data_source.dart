import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../core/constants/asset_paths.dart';
import '../models/wallpaper_model.dart';

/// Reads the bundled wallpaper catalog out of
/// `assets/data/wallpapers.json`. This is the only data source the app has
/// — there is no remote counterpart.
class WallpaperLocalDataSource {
  List<WallpaperModel>? _cache;

  Future<List<WallpaperModel>> loadCatalog() async {
    final List<WallpaperModel>? cached = _cache;
    if (cached != null) return cached;

    final String raw = await rootBundle.loadString(AssetPaths.wallpapersData);
    final dynamic decoded = jsonDecode(raw);
    final List<dynamic> items = decoded is List
        ? decoded
        : (decoded as Map<String, dynamic>)['wallpapers'] as List<dynamic>;

    final List<WallpaperModel> models = items
        .map((dynamic item) => WallpaperModel.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);

    _cache = models;
    return models;
  }
}
