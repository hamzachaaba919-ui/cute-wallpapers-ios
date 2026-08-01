import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/navigation/premium_bottom_nav_bar.dart';

/// Hosts the four primary tabs (Home, Search, Favorites, Settings) behind a
/// single floating bottom navigation bar, driven by go_router's
/// [StatefulShellRoute.indexedStack] so each tab keeps its own navigation
/// stack and scroll position when switching back and forth.
class MainNavigationShell extends StatelessWidget {
  const MainNavigationShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const List<NavItem> _items = [
    NavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
    NavItem(icon: Icons.search_rounded, activeIcon: Icons.search_rounded, label: 'Search'),
    NavItem(
      icon: Icons.favorite_border_rounded,
      activeIcon: Icons.favorite_rounded,
      label: 'Favorites',
    ),
    NavItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings_rounded,
      label: 'Settings',
    ),
  ];

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: PremiumBottomNavBar(
        items: _items,
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
