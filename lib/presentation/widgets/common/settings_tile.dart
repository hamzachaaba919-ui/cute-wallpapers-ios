import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

/// A single tappable row inside a settings section (icon, label, optional
/// subtitle, and a trailing widget or chevron).
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.icon,
    required this.label,
    super.key,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.showChevron = true,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space12,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: Icon(icon, size: AppDimensions.iconSizeSmall, color: iconColor ?? AppColors.primaryLight),
            ),
            const SizedBox(width: AppDimensions.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.bodyLarge),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppDimensions.space4),
                    Text(subtitle!, style: AppTextStyles.bodySmall),
                  ],
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else if (showChevron && onTap != null)
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textTertiary,
              ),
          ],
        ),
      ),
    );
  }
}

/// Groups related [SettingsTile]s in a rounded card with section spacing,
/// matching the "large cards, rounded corners" premium visual language.
class SettingsSection extends StatelessWidget {
  const SettingsSection({required this.children, super.key, this.title});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.only(
                left: AppDimensions.space4,
                bottom: AppDimensions.space8,
              ),
              child: Text(title!, style: AppTextStyles.overline),
            ),
          ],
          Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              boxShadow: const [
                BoxShadow(color: AppColors.shadow, blurRadius: 22, offset: Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i != children.length - 1)
                    const Divider(height: 1, indent: 72, color: AppColors.cardBorder),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
