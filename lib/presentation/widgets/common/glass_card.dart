import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// A frosted glassmorphism surface — a soft white frost with a warm,
/// low-opacity shadow so it reads consistently whether it floats over a
/// pastel background or a photo (the wallpaper detail viewer).
class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    super.key,
    this.borderRadius = AppDimensions.radiusLarge,
    this.blurSigma = 18,
    this.padding = const EdgeInsets.all(AppDimensions.space16),
    this.border = true,
    this.shadow = true,
  });

  final Widget child;
  final double borderRadius;
  final double blurSigma;
  final EdgeInsetsGeometry padding;
  final bool border;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: shadow
              ? [
                  const BoxShadow(
                    color: AppColors.shadowStrong,
                    blurRadius: 28,
                    offset: Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                gradient: AppColors.glassGradient,
                borderRadius: BorderRadius.circular(borderRadius),
                border: border ? Border.all(color: AppColors.glassBorder) : null,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
