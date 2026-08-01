import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../domain/entities/wallpaper_entity.dart';
import '../../../providers/favorites_provider.dart';
import '../../../providers/wallpaper_provider.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/wallpaper/wallpaper_grid.dart';

/// The Favorites tab: wallpapers the user has hearted, persisted locally
/// and available with no connection whatsoever.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WallpaperProvider wallpaperProvider = context.watch<WallpaperProvider>();
    final FavoritesProvider favoritesProvider = context.watch<FavoritesProvider>();
    final List<WallpaperEntity> favorites = favoritesProvider.filter(wallpaperProvider.all);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.pageHorizontalPadding,
              AppDimensions.space20,
              AppDimensions.pageHorizontalPadding,
              AppDimensions.space8,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Favorites', style: AppTextStyles.displayMedium),
                      if (favorites.isNotEmpty) ...[
                        const SizedBox(height: AppDimensions.space4),
                        Text(
                          '${favorites.length} saved wallpaper${favorites.length == 1 ? '' : 's'}',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: AppColors.accentGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
          Expanded(
            child: !favoritesProvider.isRestored || wallpaperProvider.isLoading
                ? const SizedBox.shrink()
                : favorites.isEmpty
                    ? const EmptyState(
                        icon: Icons.favorite_rounded,
                        title: 'No favorites yet',
                        message: 'Wallpapers you save will be kept here, available offline anytime.',
                      )
                    : SingleChildScrollView(
                        padding: EdgeInsets.only(
                          top: AppDimensions.space8,
                          bottom: AppDimensions.space24 + context.bottomSafeArea,
                        ),
                        child: WallpaperGrid(wallpapers: favorites, shrinkWrap: true),
                      ),
          ),
        ],
      ),
    );
  }
}
