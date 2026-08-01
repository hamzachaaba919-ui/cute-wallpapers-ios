import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/routes/wallpaper_detail_args.dart';
import '../../../domain/entities/wallpaper_entity.dart';
import '../../../providers/favorites_provider.dart';

/// A single grid tile: just the wallpaper thumbnail on a softly floating,
/// rounded card and a small, elegant favorite heart — no title text is
/// ever shown, only the image itself — the atomic building block of the
/// Home, Search, and Favorites grids.
class WallpaperCard extends StatefulWidget {
  const WallpaperCard({
    required this.wallpaper,
    super.key,
    this.animationIndex = 0,
    this.contextList,
  });

  final WallpaperEntity wallpaper;

  /// Used to stagger the entrance animation across a grid.
  final int animationIndex;

  /// The full list this card is displayed within (Home's filtered grid,
  /// Search's results, or Favorites) — carried into the detail viewer so
  /// swiping there stays within the same list rather than the whole
  /// catalog. Falls back to a single-item list of just this wallpaper.
  final List<WallpaperEntity>? contextList;

  @override
  State<WallpaperCard> createState() => _WallpaperCardState();
}

class _WallpaperCardState extends State<WallpaperCard> {
  double _scale = 1;

  void _setPressed(bool pressed) => setState(() => _scale = pressed ? 0.96 : 1);

  void _openDetail(BuildContext context) {
    final List<WallpaperEntity> list = widget.contextList ?? [widget.wallpaper];
    final int index = list.indexWhere((item) => item.id == widget.wallpaper.id);
    context.push(
      RouteNames.wallpaperDetailPath(widget.wallpaper.id),
      extra: WallpaperDetailArgs(wallpapers: list, initialIndex: index < 0 ? 0 : index),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isFavorite = context.select<FavoritesProvider, bool>(
      (provider) => provider.isFavorite(widget.wallpaper.id),
    );

    // The whole-card gesture area sits beneath the favorite button in the
    // Stack, so a tap on the button is claimed by its own (inner) tap
    // recognizer and never triggers this card's press-scale or navigation.
    final Widget card = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: () => _openDetail(context),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: AppDimensions.durationFast),
        curve: Curves.easeOut,
        child: AspectRatio(
          aspectRatio: widget.wallpaper.aspectRatio,
          // The shadow lives on this outer container so it isn't clipped
          // away by the ClipRRect that rounds the image beneath it.
          child: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(color: AppColors.shadow, blurRadius: 24, offset: Offset(0, 10)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'wallpaper_${widget.wallpaper.id}',
                    child: Image.asset(
                      widget.wallpaper.assetPath,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: AppDimensions.space8,
                    right: AppDimensions.space8,
                    child: _FavoriteButton(id: widget.wallpaper.id, isFavorite: isFavorite),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return card
        .animate(delay: Duration(milliseconds: 30 * (widget.animationIndex % 12)))
        .fadeIn(duration: const Duration(milliseconds: 260))
        .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.id, required this.isFavorite});

  final String id;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: isFavorite ? 'Remove from favorites' : 'Add to favorites',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: () => context.read<FavoritesProvider>().toggle(id),
        child: Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 3)),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: AppDimensions.durationFast),
            transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
            child: Icon(
              isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              key: ValueKey<bool>(isFavorite),
              color: isFavorite ? AppColors.primary : AppColors.textTertiary,
              size: 14,
            ),
          ),
        ),
      ),
    );
  }
}
