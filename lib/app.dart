import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/wallpaper_local_data_source.dart';
import 'data/repositories/wallpaper_repository_impl.dart';
import 'domain/repositories/wallpaper_repository.dart';
import 'providers/favorites_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/wallpaper_provider.dart';
import 'services/local_storage_service.dart';

/// Root widget: wires up dependency providers and the Material app shell.
///
/// Every dependency here is local: [WallpaperRepository] reads from a
/// bundled JSON asset and [LocalStorageService] wraps SharedPreferences.
/// The app never constructs an HTTP client or reaches for the network.
class CuteWallpapersApp extends StatelessWidget {
  const CuteWallpapersApp({required this.localStorageService, super.key});

  final LocalStorageService localStorageService;

  @override
  Widget build(BuildContext context) {
    final WallpaperRepository wallpaperRepository = WallpaperRepositoryImpl(
      dataSource: WallpaperLocalDataSource(),
      storage: localStorageService,
    );

    return MultiProvider(
      providers: [
        Provider<LocalStorageService>.value(value: localStorageService),
        Provider<WallpaperRepository>.value(value: wallpaperRepository),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(localStorageService),
        ),
        ChangeNotifierProvider<WallpaperProvider>(
          create: (_) => WallpaperProvider(wallpaperRepository),
        ),
        ChangeNotifierProvider<FavoritesProvider>(
          create: (_) => FavoritesProvider(wallpaperRepository),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
