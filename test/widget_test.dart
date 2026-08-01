// Smoke tests for Cute Wallpapers.
//
// The template-generated counter-app test (which referenced a nonexistent
// `MyApp`) has been replaced with tests against the real entry point,
// `CuteWallpapersApp`. `SharedPreferences.setMockInitialValues` stands in for
// the platform channel `LocalStorageService`/`ThemeProvider` read from on a
// real device, since plugin channels aren't available in a widget test.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cute_wallpapers/app.dart';
import 'package:cute_wallpapers/core/constants/app_constants.dart';
import 'package:cute_wallpapers/services/local_storage_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('App boots and shows the branded splash screen', (tester) async {
    await tester.pumpWidget(
      CuteWallpapersApp(localStorageService: LocalStorageService()),
    );

    expect(find.text(AppConstants.appName), findsOneWidget);
  });

  testWidgets('App lands on the Home tab after the splash delay', (tester) async {
    await tester.pumpWidget(
      CuteWallpapersApp(localStorageService: LocalStorageService()),
    );

    // The splash screen navigates away after a fixed delay. Advance the
    // clock past it with bounded `pump`s rather than `pumpAndSettle` —
    // the Home tab's shimmer skeletons animate on an infinite loop, so
    // `pumpAndSettle` would never consider the tree "settled".
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
