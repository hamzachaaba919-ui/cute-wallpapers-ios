import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import 'premium_button.dart';

/// A polished empty/error state used whenever a screen has nothing to show
/// yet — no favorites, no search results, no connection, etc. Consistent
/// iconography and copy tone keep these moments feeling intentional rather
/// than like an unfinished screen.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
    this.actionLabel,
    this.onActionTap,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 104,
              height: 104,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.18),
                    AppColors.secondary.withValues(alpha: 0.14),
                  ],
                ),
                boxShadow: const [
                  BoxShadow(color: AppColors.shadow, blurRadius: 28, offset: Offset(0, 10)),
                ],
              ),
              child: Icon(icon, size: 40, color: AppColors.primaryDark),
            ),
            const SizedBox(height: AppDimensions.space24),
            Text(title, style: AppTextStyles.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: AppDimensions.space8),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: AppDimensions.space24),
              PremiumButton(
                label: actionLabel!,
                onPressed: onActionTap,
                expand: false,
                variant: PremiumButtonVariant.ghost,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
