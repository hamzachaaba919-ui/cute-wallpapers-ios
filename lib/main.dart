import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'services/local_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Edge-to-edge, immersive layout — the status/navigation bars are drawn
  // transparent over app content rather than reserving opaque bars.
  //
  // SystemUiMode.edgeToEdge is an Android concept; the iOS engine's
  // handling of it is best-effort only (it's not guaranteed to be a no-op
  // for every SystemUiMode value on every engine version). Both calls are
  // wrapped so that any platform-channel hiccup during startup can never
  // block runApp() from executing — without this, an unhandled exception
  // here would stop main() before the Flutter UI is ever built, which
  // looks identical to a crash on device.
  try {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } catch (_) {
    // Non-fatal: worst case the status bar isn't edge-to-edge or the
    // orientation lock doesn't apply. Never let this block first render.
  }

  final LocalStorageService localStorageService = LocalStorageService();

  runApp(CuteWallpapersApp(localStorageService: localStorageService));
}
