import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/collections.dart';
import '../../../core/utils/extensions.dart';
import '../../../domain/entities/wallpaper_entity.dart';
import '../../../providers/favorites_provider.dart';
import '../../../services/wallpaper_actions_service.dart';
import '../../widgets/common/glass_card.dart';

/// Full-screen, swipeable wallpaper viewer.
///
/// [wallpapers] is the exact list the user was already browsing — the full
/// catalog, a filtered collection, favorites, or search results — and
/// [initialIndex] is where inside it they tapped in from. Swiping left/right
/// moves through that same list; it never jumps out to the full catalog.
/// Pinch-to-zoom, save to Photos, and share all operate on the bundled
/// asset for whichever wallpaper is currently on screen — no network call
/// is ever made.
///
/// iOS apps cannot set the home/lock screen wallpaper directly, so instead
/// of Android's "Set wallpaper" this screen offers "Save Wallpaper", which
/// writes the image into the Photos library and then shows a native-feeling
/// Cupertino dialog telling the person to finish up in the Photos app.
class WallpaperDetailScreen extends StatefulWidget {
  const WallpaperDetailScreen({
    required this.wallpapers,
    required this.initialIndex,
    super.key,
  });

  final List<WallpaperEntity> wallpapers;
  final int initialIndex;

  @override
  State<WallpaperDetailScreen> createState() => _WallpaperDetailScreenState();
}

class _WallpaperDetailScreenState extends State<WallpaperDetailScreen> {
  final WallpaperActionsService _actions = WallpaperActionsService();
  late final PageController _pageController = PageController(initialPage: widget.initialIndex);
  late int _currentIndex = widget.initialIndex;

  bool _isSaving = false;
  bool _isSharing = false;

  WallpaperEntity get _current => widget.wallpapers[_currentIndex];

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      // Any action in flight belonged to the wallpaper being swiped away
      // from — drop its loading state rather than showing a stale spinner.
      _isSaving = false;
      _isSharing = false;
    });
  }

  Future<void> _saveWallpaper() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
      final SaveWallpaperResult result = await _actions.saveToGallery(_current);
      if (!mounted) return;
      if (result == SaveWallpaperResult.success) {
        await _showSavedDialog();
      } else {
        await _showPermissionDeniedDialog();
      }
    } catch (_) {
      if (mounted) context.showSnack('Something went wrong. Please try again.');
    }
    if (mounted) setState(() => _isSaving = false);
  }

  /// A native-feeling Cupertino confirmation — iOS has no API for an app to
  /// set the wallpaper itself, so this tells the person exactly how to
  /// finish the job in the Photos app.
  Future<void> _showSavedDialog() {
    return showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Wallpaper saved successfully'),
        content: const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text('Open Photos → Share → Use as Wallpaper.'),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Shown when the person has declined (or previously declined) the
  /// add-photos permission prompt, explaining why the app needs it and
  /// offering a direct route to the Settings toggle rather than leaving
  /// them stuck.
  Future<void> _showPermissionDeniedDialog() {
    return showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Photos Access Needed'),
        content: const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            'Cute Wallpapers needs permission to add photos to your library '
            "so it can save this wallpaper. You can allow this in Settings → "
            'Cute Wallpapers → Photos.',
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Not Now'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop();
              unawaited(launchUrl(Uri.parse('app-settings:')));
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _share() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    try {
      await _actions.share(_current);
    } catch (_) {
      if (mounted) context.showSnack('Something went wrong. Please try again.');
    }
    if (mounted) setState(() => _isSharing = false);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isFavorite = context.select<FavoritesProvider, bool>(
      (provider) => provider.isFavorite(_current.id),
    );
    final bool canSwipe = widget.wallpapers.length > 1;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PhotoViewGallery.builder(
            itemCount: widget.wallpapers.length,
            pageController: _pageController,
            onPageChanged: canSwipe ? _onPageChanged : null,
            scrollPhysics: canSwipe
                ? const BouncingScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            builder: (context, index) {
              final WallpaperEntity wallpaper = widget.wallpapers[index];
              return PhotoViewGalleryPageOptions(
                imageProvider: AssetImage(wallpaper.assetPath),
                heroAttributes: PhotoViewHeroAttributes(tag: 'wallpaper_${wallpaper.id}'),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2.5,
              );
            },
          ),
          // A soft, wide dark gradient the bottom info panel can rest on,
          // independent of the panel's own frosted-glass fill — keeps the
          // panel grounded against any photo, bright or dark.
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 360,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0x66000000)],
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: context.viewPadding.top + AppDimensions.space12,
            left: AppDimensions.space16,
            right: AppDimensions.space16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _GlassIconButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => Navigator.of(context).maybePop(),
                ),
                _GlassIconButton(
                  icon: isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  iconColor: isFavorite ? AppColors.primary : AppColors.textPrimary,
                  onTap: () => context.read<FavoritesProvider>().toggle(_current.id),
                  pop: isFavorite,
                ),
              ],
            ),
          ).animate().fadeIn(duration: const Duration(milliseconds: 360)),
          Positioned(
            left: AppDimensions.space16,
            right: AppDimensions.space16,
            bottom: AppDimensions.space16 + context.bottomSafeArea,
            child: _ActionBar(
              key: ValueKey<String>(_current.id),
              collection: _current.collection,
              isSaving: _isSaving,
              isSharing: _isSharing,
              onSave: _saveWallpaper,
              onShare: _share,
            ),
          )
              .animate()
              .fadeIn(duration: const Duration(milliseconds: 420), delay: const Duration(milliseconds: 60))
              .slideY(begin: 0.12, end: 0, curve: Curves.easeOutCubic),
        ],
      ),
    );
  }
}

/// Shared press-scale feedback used by the small floating glass controls —
/// a gentle, Material-3-flavored "give" on tap rather than a flat ripple.
class _PressableScale extends StatefulWidget {
  const _PressableScale({required this.child, required this.onTap, this.pop = false});

  final Widget child;
  final VoidCallback onTap;

  /// Plays a little bounce (e.g. right after a favorite toggle) even
  /// without a fresh tap-down, so the state change itself feels alive.
  final bool pop;

  @override
  State<_PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<_PressableScale> {
  double _scale = 1;

  @override
  void didUpdateWidget(covariant _PressableScale oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pop && !oldWidget.pop) {
      _bounce();
    }
  }

  Future<void> _bounce() async {
    setState(() => _scale = 1.18);
    await Future<void>.delayed(const Duration(milliseconds: 120));
    if (mounted) setState(() => _scale = 1);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.9),
      onTapCancel: () => setState(() => _scale = 1),
      onTapUp: (_) => setState(() => _scale = 1),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutBack,
        child: widget.child,
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor = AppColors.textPrimary,
    this.pop = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;
  final bool pop;

  @override
  Widget build(BuildContext context) {
    return _PressableScale(
      onTap: onTap,
      pop: pop,
      child: GlassCard(
        borderRadius: AppDimensions.radiusPill,
        blurSigma: 16,
        padding: EdgeInsets.zero,
        child: Semantics(
          button: true,
          excludeSemantics: true,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, color: iconColor, size: AppDimensions.iconSizeMedium),
          ),
        ),
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.collection,
    required this.isSaving,
    required this.isSharing,
    required this.onSave,
    required this.onShare,
    super.key,
  });

  final String collection;
  final bool isSaving;
  final bool isSharing;
  final VoidCallback onSave;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.space20,
        AppDimensions.space16,
        AppDimensions.space20,
        AppDimensions.space16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Only the collection is shown here — no wallpaper title is ever
          // displayed anywhere in the UI, only the image itself.
          Row(
            children: [
              Icon(Collections.iconFor(collection), size: 14, color: AppColors.primary),
              const SizedBox(width: AppDimensions.space4),
              Text(collection, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: AppDimensions.space16),
          Row(
            children: [
              // Save Wallpaper is the clear, primary action on iOS — full
              // width gradient button. There's no "set wallpaper" here:
              // iOS gives apps no API to apply a wallpaper directly, so
              // saving to Photos (then finishing up in the Photos app) is
              // the whole flow.
              Expanded(
                child: _ActionButton(
                  icon: Icons.wallpaper_rounded,
                  label: 'Save Wallpaper',
                  isLoading: isSaving,
                  onTap: onSave,
                  isPrimary: true,
                ),
              ),
              const SizedBox(width: AppDimensions.space12),
              _ActionButton(
                icon: Icons.ios_share_rounded,
                label: 'Share',
                isLoading: isSharing,
                onTap: onShare,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.isPrimary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLoading;
  final bool isPrimary;

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  double _scale = 1;

  void _setPressed(bool pressed) {
    if (widget.isLoading) return;
    setState(() => _scale = pressed ? 0.92 : 1);
  }

  @override
  Widget build(BuildContext context) {
    final Color foreground = widget.isPrimary ? Colors.white : AppColors.primary;

    final Widget content = widget.isLoading
        ? SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(foreground)),
          )
        : Icon(widget.icon, color: foreground, size: AppDimensions.iconSizeSmall);

    return Semantics(
      button: true,
      label: widget.label,
      excludeSemantics: true,
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        onTapUp: (_) => _setPressed(false),
        onTap: widget.isLoading ? null : widget.onTap,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: AppDimensions.durationFast),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: AppDimensions.durationFast),
            height: 48,
            padding: EdgeInsets.symmetric(
              horizontal: widget.isPrimary ? AppDimensions.space16 : AppDimensions.space12,
            ),
            decoration: BoxDecoration(
              gradient: widget.isPrimary ? AppColors.primaryGradient : null,
              color: widget.isPrimary ? null : AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              boxShadow: widget.isPrimary
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                content,
                if (widget.isPrimary) ...[
                  const SizedBox(width: AppDimensions.space8),
                  Text(widget.label, style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

