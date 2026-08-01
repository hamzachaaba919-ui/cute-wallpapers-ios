import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// A single shimmering rounded box — the atomic building block for every
/// skeleton-loading layout in the app.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = AppDimensions.radiusSmall,
  });

  final double? width;
  final double? height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Wraps any skeleton layout in the shimmer sweep animation. Use this once
/// per screen section rather than per individual [ShimmerBox] so the sweep
/// stays synchronized.
class ShimmerWrap extends StatelessWidget {
  const ShimmerWrap({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      period: const Duration(milliseconds: 1400),
      child: child,
    );
  }
}

/// Skeleton placeholder matching the shape of a wallpaper grid card.
class WallpaperCardSkeleton extends StatelessWidget {
  const WallpaperCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: AppDimensions.wallpaperCardAspectRatio,
      child: ShimmerBox(borderRadius: AppDimensions.radiusCard),
    );
  }
}

/// A full skeleton grid, shown while the wallpaper feed is loading.
class WallpaperGridSkeleton extends StatelessWidget {
  const WallpaperGridSkeleton({super.key, this.itemCount = 6, this.crossAxisCount = 2});

  final int itemCount;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerWrap(
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageHorizontalPadding),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: AppDimensions.gridSpacing,
          crossAxisSpacing: AppDimensions.gridSpacing,
          childAspectRatio: AppDimensions.wallpaperCardAspectRatio,
        ),
        itemBuilder: (context, index) => const WallpaperCardSkeleton(),
      ),
    );
  }
}

/// Skeleton placeholder for the horizontal category chip row.
class CategoryChipRowSkeleton extends StatelessWidget {
  const CategoryChipRowSkeleton({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerWrap(
      child: SizedBox(
        height: AppDimensions.categoryChipHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageHorizontalPadding),
          itemCount: itemCount,
          separatorBuilder: (context, index) => const SizedBox(width: AppDimensions.space8),
          itemBuilder: (context, index) => const ShimmerBox(
            width: 96,
            height: AppDimensions.categoryChipHeight,
            borderRadius: AppDimensions.radiusPill,
          ),
        ),
      ),
    );
  }
}
