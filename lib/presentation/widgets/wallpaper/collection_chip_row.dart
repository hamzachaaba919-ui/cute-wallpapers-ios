import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/collections.dart';

/// The horizontal filter row for the small, fixed set of collections
/// (`All`, `Cute`, `Kawaii`, `Animals`, `Aesthetic`, `Pink`). Deliberately a
/// single row of chips rather than a category browsing screen.
class CollectionChipRow extends StatelessWidget {
  const CollectionChipRow({required this.selected, required this.onSelected, super.key});

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    // A touch taller than the chip itself purely to give the shadow room to
    // breathe — every chip, selected or not, renders at the exact same
    // height.
    return SizedBox(
      height: AppDimensions.categoryChipHeight + 6,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageHorizontalPadding),
        itemCount: Collections.chipOrder.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppDimensions.space8),
        itemBuilder: (context, index) {
          final String collection = Collections.chipOrder[index];
          final bool isSelected = collection == selected;
          return Center(
            child: _CollectionChip(
              label: collection,
              icon: Collections.iconFor(collection),
              isSelected: isSelected,
              onTap: () => onSelected(collection),
            ),
          );
        },
      ),
    );
  }
}

class _CollectionChip extends StatelessWidget {
  const _CollectionChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: AppDimensions.durationMedium),
          curve: Curves.easeOutCubic,
          // Height is fixed for every chip, selected or not — only color,
          // shadow, and width (via padding) animate.
          height: AppDimensions.categoryChipHeight,
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? AppDimensions.space20 : AppDimensions.space16,
          ),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.primaryGradient : null,
            color: isSelected ? null : AppColors.card,
            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
            border: Border.all(
              color: isSelected ? Colors.transparent : AppColors.cardBorder,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected ? AppColors.primary.withValues(alpha: 0.32) : AppColors.shadow,
                blurRadius: isSelected ? 18 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // A fixed-size box keeps the icon perfectly centered on its
              // own baseline regardless of selection state — only its color
              // and weight (via the icon glyph) change, never its size or
              // position.
              SizedBox(
                width: AppDimensions.iconSizeSmall,
                height: AppDimensions.iconSizeSmall,
                child: Center(
                  child: TweenAnimationBuilder<Color?>(
                    tween: ColorTween(end: isSelected ? Colors.white : AppColors.textSecondary),
                    duration: const Duration(milliseconds: AppDimensions.durationMedium),
                    curve: Curves.easeOutCubic,
                    builder: (context, color, child) =>
                        Icon(icon, size: AppDimensions.iconSizeSmall, color: color),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.space8),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: AppDimensions.durationMedium),
                curve: Curves.easeOutCubic,
                style: AppTextStyles.labelMedium.copyWith(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
