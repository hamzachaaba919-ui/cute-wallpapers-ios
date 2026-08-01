import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

class NavItem {
  const NavItem({required this.icon, required this.activeIcon, required this.label});

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

/// A floating, frosted-glass pill navigation bar — soft white frost over
/// the cream background, with the active tab picked out by a pink/lavender
/// gradient pill that glides between items.
class PremiumBottomNavBar extends StatelessWidget {
  const PremiumBottomNavBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final List<NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimensions.space16,
        right: AppDimensions.space16,
        bottom: MediaQuery.viewPaddingOf(context).bottom + AppDimensions.space12,
      ),
      child: RepaintBoundary(
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(color: AppColors.shadowStrong, blurRadius: 30, offset: Offset(0, 12)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
              child: Container(
                height: AppDimensions.navBarHeight,
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 0; i < items.length; i++)
                      _NavBarItem(
                        item: items[i],
                        isActive: i == currentIndex,
                        onTap: () => onTap(i),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A single tab: icon above label, both perfectly centered within an equal
/// share of the bar's width. The active state is a small, fixed-size pill
/// tucked behind the icon only — never a stretched capsule — so every tab
/// keeps identical width and alignment whether selected or not.
class _NavBarItem extends StatelessWidget {
  const _NavBarItem({required this.item, required this.isActive, required this.onTap});

  final NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        button: true,
        selected: isActive,
        label: item.label,
        excludeSemantics: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: AppDimensions.durationMedium),
                  curve: Curves.easeOutCubic,
                  width: 44,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary.withValues(alpha: 0.14)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: AppDimensions.durationFast),
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                    child: Icon(
                      isActive ? item.activeIcon : item.icon,
                      key: ValueKey<bool>(isActive),
                      size: AppDimensions.iconSizeMedium,
                      color: isActive ? AppColors.primaryDark : AppColors.textTertiary,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.space4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: AppDimensions.durationMedium),
                  curve: Curves.easeOutCubic,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isActive ? AppColors.primaryDark : AppColors.textTertiary,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
                  child: Text(item.label),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
