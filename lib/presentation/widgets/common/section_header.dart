import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

/// Standard "Section title + optional trailing action" header used above
/// every horizontal/vertical content list on the Home screen and beyond.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageHorizontalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.headlineSmall),
                if (subtitle != null) ...[
                  const SizedBox(height: AppDimensions.space4),
                  Text(subtitle!, style: AppTextStyles.bodySmall),
                ],
              ],
            ),
          ),
          if (actionLabel != null)
            Semantics(
              button: true,
              label: actionLabel,
              excludeSemantics: true,
              child: GestureDetector(
                onTap: onActionTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.space8,
                    vertical: AppDimensions.space4,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        actionLabel!,
                        style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryLight),
                      ),
                      const SizedBox(width: AppDimensions.space4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: AppDimensions.iconSizeSmall,
                        color: AppColors.primaryLight,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
