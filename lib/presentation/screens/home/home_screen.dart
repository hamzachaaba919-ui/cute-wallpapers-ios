import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/collections.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/utils/extensions.dart';
import '../../../providers/wallpaper_provider.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/shimmer_loading.dart';
import '../../widgets/wallpaper/collection_chip_row.dart';
import '../../widgets/wallpaper/wallpaper_grid.dart';

/// The Home tab: the app's core browsing surface — a soft, decorative
/// greeting header, a search entry point, the small fixed collection
/// filter row, and a masonry grid of every bundled wallpaper (optionally
/// filtered by collection).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _onRefresh(BuildContext context) => context.read<WallpaperProvider>().reload();

  @override
  Widget build(BuildContext context) {
    final double topPadding = context.viewPadding.top;
    final WallpaperProvider wallpaperProvider = context.watch<WallpaperProvider>();

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.homeBackgroundGradient),
      child: RefreshIndicator(
        onRefresh: () => _onRefresh(context),
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(
              child: _DecorativeHeader(topPadding: topPadding),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.pageHorizontalPadding,
                  vertical: AppDimensions.space20,
                ),
                child: _SearchEntryField(
                  onTap: () => context.go(RouteNames.search),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.space8)),
            SliverToBoxAdapter(
              child: CollectionChipRow(
                selected: wallpaperProvider.selectedCollection,
                onSelected: wallpaperProvider.selectCollection,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.space28)),
            SliverToBoxAdapter(
              child: SectionHeader(
                title: wallpaperProvider.selectedCollection == Collections.all
                    ? 'All wallpapers'
                    : wallpaperProvider.selectedCollection,
                subtitle: wallpaperProvider.isLoading
                    ? null
                    : '${wallpaperProvider.visible.length} wallpapers',
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.space20)),
            if (wallpaperProvider.isLoading)
            const SliverToBoxAdapter(child: WallpaperGridSkeleton(itemCount: 6))
          else if (wallpaperProvider.loadError != null)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 320,
                child: EmptyState(
                  icon: Icons.error_outline_rounded,
                  title: "Couldn't load wallpapers",
                  message: 'Something went wrong reading the bundled wallpaper catalog.',
                  actionLabel: 'Try again',
                  onActionTap: () => context.read<WallpaperProvider>().reload(),
                ),
              ),
            )
          else if (wallpaperProvider.visible.isEmpty)
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 280,
                child: EmptyState(
                  icon: Icons.image_search_rounded,
                  title: 'No wallpapers here yet',
                  message: 'Try a different collection.',
                ),
              ),
            )
          else
            SliverToBoxAdapter(
              child: WallpaperGrid(wallpapers: wallpaperProvider.visible, shrinkWrap: true),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: AppDimensions.space40 + context.bottomSafeArea),
            ),
          ],
        ),
      ),
    );
  }
}

/// The greeting section, painted over a soft, blurred cluster of pastel
/// blobs — a subtle, cute decorative background rather than a flat title
/// bar.
class _DecorativeHeader extends StatelessWidget {
  const _DecorativeHeader({required this.topPadding});

  final double topPadding;

  @override
  Widget build(BuildContext context) {
    final String greeting = DateTime.now().greeting;

    return ClipRect(
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -50,
            child: _blob(140, AppColors.secondary.withValues(alpha: 0.28)),
          ),
          Positioned(
            top: 10,
            left: -60,
            child: _blob(120, AppColors.accent.withValues(alpha: 0.28)),
          ),
          Positioned(
            top: 40,
            right: 60,
            child: _blob(70, AppColors.primary.withValues(alpha: 0.22)),
          ),
          Positioned(
            top: 28,
            right: 96,
            child: _sparkle(Icons.auto_awesome_rounded, 14, AppColors.primary.withValues(alpha: 0.4)),
          ),
          Positioned(
            top: 84,
            left: 28,
            child: _sparkle(Icons.auto_awesome_rounded, 10, AppColors.secondary.withValues(alpha: 0.4)),
          ),
          Positioned(
            top: 4,
            left: 120,
            child: _sparkle(Icons.star_rounded, 9, AppColors.accent.withValues(alpha: 0.5)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppDimensions.pageHorizontalPadding,
              topPadding + AppDimensions.space12,
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
                      Text(
                        greeting,
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: AppDimensions.space4),
                      Text(AppConstants.appName, style: AppTextStyles.displayLarge),
                      const SizedBox(height: AppDimensions.space4),
                      Text(
                        AppConstants.appTagline,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimensions.space12),
                Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 24),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// A soft, glowing blob — a radial gradient fading to transparent reads
  /// as "blurred" without the cost of an actual [BackdropFilter] per blob.
  Widget _blob(double size, Color color) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
        ),
      ),
    );
  }

  /// A tiny decorative sparkle scattered behind the title — very subtle,
  /// purely cosmetic.
  Widget _sparkle(IconData icon, double size, Color color) {
    return IgnorePointer(child: Icon(icon, size: size, color: color));
  }
}

class _SearchEntryField extends StatelessWidget {
  const _SearchEntryField({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Search wallpapers and collections',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space20),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
            boxShadow: const [
              BoxShadow(color: AppColors.shadow, blurRadius: 18, offset: Offset(0, 8)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.search_rounded, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: AppDimensions.space12),
              Text(
                'Search wallpapers, collections…',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.6)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
