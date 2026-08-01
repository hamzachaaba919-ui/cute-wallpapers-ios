import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'services/local_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Edge-to-edge, immersive layout — the status/navigation bars are drawn
  // transparent over app content rather than reserving opaque bars.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final LocalStorageService localStorageService = LocalStorageService();

  runApp(CuteWallpapersApp(localStorageService: localStorageService));
}
