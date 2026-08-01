import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

enum PremiumButtonVariant { primary, secondary, outline, ghost }

/// A single, reusable button component covering every button style used
/// across the app, so we never hand-roll one-off buttons per screen.
class PremiumButton extends StatefulWidget {
  const PremiumButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = PremiumButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final PremiumButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool expand;

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton> {
  double _scale = 1;

  bool get _isDisabled => widget.onPressed == null || widget.isLoading;

  void _setPressed(bool pressed) {
    if (_isDisabled) return;
    setState(() => _scale = pressed ? 0.97 : 1);
  }

  @override
  Widget build(BuildContext context) {
    final Widget content = widget.isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(_foregroundColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: AppDimensions.iconSizeSmall, color: _foregroundColor),
                const SizedBox(width: AppDimensions.space8),
              ],
              Text(
                widget.label,
                style: AppTextStyles.labelLarge.copyWith(color: _foregroundColor),
              ),
            ],
          );

    final Widget button = AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: AppDimensions.durationFast),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: AppDimensions.durationFast),
        height: AppDimensions.buttonHeight,
        width: widget.expand ? double.infinity : null,
        padding: widget.expand
            ? null
            : const EdgeInsets.symmetric(horizontal: AppDimensions.space24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          gradient: _backgroundGradient,
          color: _backgroundGradient == null ? _backgroundColor : null,
          border: _border,
          boxShadow: _isDisabled || _backgroundGradient == null
              ? null
              : [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.28),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Opacity(opacity: _isDisabled && !widget.isLoading ? 0.5 : 1, child: content),
      ),
    );

    return Semantics(
      button: true,
      enabled: !_isDisabled,
      label: widget.label,
      excludeSemantics: true,
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: _isDisabled ? null : widget.onPressed,
        child: MouseRegion(
          cursor: _isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
          child: button,
        ),
      ),
    );
  }

  Color get _foregroundColor {
    switch (widget.variant) {
      case PremiumButtonVariant.primary:
      case PremiumButtonVariant.secondary:
        return Colors.white;
      case PremiumButtonVariant.outline:
      case PremiumButtonVariant.ghost:
        return AppColors.textPrimary;
    }
  }

  Color? get _backgroundColor {
    switch (widget.variant) {
      case PremiumButtonVariant.outline:
        return Colors.transparent;
      case PremiumButtonVariant.ghost:
        return AppColors.card;
      case PremiumButtonVariant.primary:
      case PremiumButtonVariant.secondary:
        return null;
    }
  }

  Gradient? get _backgroundGradient {
    switch (widget.variant) {
      case PremiumButtonVariant.primary:
        return AppColors.primaryGradient;
      case PremiumButtonVariant.secondary:
        return AppColors.accentGradient;
      case PremiumButtonVariant.outline:
      case PremiumButtonVariant.ghost:
        return null;
    }
  }

  BoxBorder? get _border {
    if (widget.variant == PremiumButtonVariant.outline) {
      return Border.all(color: AppColors.cardBorder, width: 1.2);
    }
    return null;
  }
}
