import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/entities/wallpaper_entity.dart';
import 'wallpaper_card.dart';

/// A masonry grid of [WallpaperCard]s — the core "beautiful grid of
/// wallpapers" browsing surface reused across Home, Search, and Favorites.
class WallpaperGrid extends StatelessWidget {
  const WallpaperGrid({
    required this.wallpapers,
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: AppDimensions.pageHorizontalPadding),
    this.shrinkWrap = false,
    this.physics,
  });

  final List<WallpaperEntity> wallpapers;
  final EdgeInsetsGeometry padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    final int crossAxisCount = Responsive.gridColumns(context);

    return MasonryGridView.count(
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics ?? (shrinkWrap ? const NeverScrollableScrollPhysics() : null),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: AppDimensions.gridSpacing,
      crossAxisSpacing: AppDimensions.gridSpacing,
      itemCount: wallpapers.length,
      itemBuilder: (context, index) => WallpaperCard(
        wallpaper: wallpapers[index],
        animationIndex: index,
        // Carries this exact (possibly filtered/searched) list into the
        // detail viewer so swiping there never jumps back to the full
        // catalog.
        contextList: wallpapers,
      ),
    );
  }
}
