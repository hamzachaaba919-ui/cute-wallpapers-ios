import 'package:flutter/foundation.dart';

import '../../domain/entities/wallpaper_entity.dart';

/// Payload passed via go_router's `extra` when pushing the wallpaper detail
/// route, so the swipeable viewer stays within the exact list the user was
/// already browsing — the full catalog, a filtered collection, favorites,
/// or search results — instead of jumping back out to everything.
@immutable
class WallpaperDetailArgs {
  const WallpaperDetailArgs({required this.wallpapers, required this.initialIndex});

  final List<WallpaperEntity> wallpapers;
  final int initialIndex;
}
