import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../presentation/screens/favorites/favorites_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/search/search_screen.dart';
import '../../presentation/screens/settings/about_screen.dart';
import '../../presentation/screens/settings/legal_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/shell/main_navigation_shell.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../domain/entities/wallpaper_entity.dart';
import '../../presentation/screens/wallpaper_detail/wallpaper_detail_screen.dart';
import '../../presentation/widgets/common/empty_state.dart';
import '../../providers/wallpaper_provider.dart';
import '../constants/legal_content.dart';
import 'route_names.dart';
import 'wallpaper_detail_args.dart';

/// Centralized navigation graph.
///
/// The four primary tabs live behind a [StatefulShellRoute.indexedStack] so
/// each keeps an independent navigation stack and scroll position. The
/// wallpaper detail viewer and the legal/about pages are pushed full-screen
/// on top of the shell via the root navigator key.
abstract final class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: false,
    errorBuilder: (context, state) => const Scaffold(
      body: SafeArea(
        child: EmptyState(
          icon: Icons.error_outline_rounded,
          title: 'Page not found',
          message: "The screen you're looking for doesn't exist.",
        ),
      ),
    ),
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainNavigationShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.search,
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.favorites,
                builder: (context, state) => const FavoritesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      // Pushed full-screen on top of the shell, hence the root navigator key.
      // Uses a custom fade + gentle scale transition (rather than the
      // default platform push) so the swipeable viewer feels more
      // immersive; the Hero flight for the tapped card runs independently
      // of this page transition.
      GoRoute(
        path: '/wallpaper/:id',
        name: RouteNames.wallpaperDetail,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final String id = state.pathParameters['id']!;
          final WallpaperDetailArgs? args = state.extra as WallpaperDetailArgs?;

          List<WallpaperEntity> wallpapers = args?.wallpapers ?? const [];
          int initialIndex = args?.initialIndex ?? 0;

          // No `extra` (e.g. a cold deep link) — fall back to a single-item
          // "gallery" of just the requested wallpaper, looked up from the
          // in-memory catalog.
          if (wallpapers.isEmpty) {
            final WallpaperEntity? wallpaper = context.read<WallpaperProvider>().byId(id);
            wallpapers = wallpaper == null ? const [] : [wallpaper];
            initialIndex = 0;
          }

          final Widget child = wallpapers.isEmpty
              ? const Scaffold(
                  body: SafeArea(
                    child: EmptyState(
                      icon: Icons.image_not_supported_rounded,
                      title: 'Wallpaper not found',
                      message: "This wallpaper isn't in the catalog anymore.",
                    ),
                  ),
                )
              : WallpaperDetailScreen(wallpapers: wallpapers, initialIndex: initialIndex);

          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: child,
            transitionDuration: const Duration(milliseconds: 320),
            reverseTransitionDuration: const Duration(milliseconds: 260),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final CurvedAnimation curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
              return FadeTransition(
                opacity: curved,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
                  child: child,
                ),
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/legal/privacy',
        name: RouteNames.privacyPolicy,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const LegalScreen(
          title: 'Privacy Policy',
          document: LegalContent.privacyPolicy,
        ),
      ),
      GoRoute(
        path: '/legal/terms',
        name: RouteNames.termsOfService,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const LegalScreen(
          title: 'Terms of Service',
          document: LegalContent.termsOfService,
        ),
      ),
      GoRoute(
        path: '/about',
        name: RouteNames.about,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AboutScreen(),
      ),
    ],
  );

  const AppRouter._();
}
