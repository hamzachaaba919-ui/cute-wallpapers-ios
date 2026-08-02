import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
// TEMPORARY DIAGNOSTIC BUILD: gal import removed to binary-isolate the
// TestFlight launch crash — see the matching pubspec.yaml comment and the
// stub in saveToGallery() below. Restore once the crash cause is confirmed.
// import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';

import '../domain/entities/wallpaper_entity.dart';

/// The on-device actions available from the wallpaper detail screen: save
/// to the Photos library and share. Every image involved is a bundled
/// asset — nothing is ever downloaded.
///
/// iOS has no public API for an app to set the home/lock screen wallpaper
/// directly (unlike Android), so this app never attempts it. Instead,
/// [saveToGallery] writes the image into Photos and the UI then tells the
/// person to finish the job themselves via Photos' own "Use as Wallpaper"
/// action — see the success dialog in `wallpaper_detail_screen.dart`.
class WallpaperActionsService {
  Future<Uint8List> _loadBytes(WallpaperEntity wallpaper) async {
    final ByteData data = await rootBundle.load(wallpaper.assetPath);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  String _extensionOf(WallpaperEntity wallpaper) {
    final int dot = wallpaper.assetPath.lastIndexOf('.');
    return dot == -1 ? 'jpg' : wallpaper.assetPath.substring(dot + 1);
  }

  // TEMPORARY DIAGNOSTIC BUILD: body replaced to remove all calls into gal
  // while binary-isolating the TestFlight launch crash. Restore the real
  // implementation (below, commented out) once the crash cause is
  // confirmed.
  Future<void> saveToGallery(WallpaperEntity wallpaper) async {
    throw UnimplementedError('saveToGallery is temporarily disabled for crash isolation testing.');
  }

  // Future<void> saveToGallery(WallpaperEntity wallpaper) async {
  //   final bool hasAccess = await Gal.hasAccess() || await Gal.requestAccess();
  //   if (!hasAccess) {
  //     throw StateError('Photo library access was denied.');
  //   }
  //   final Uint8List bytes = await _loadBytes(wallpaper);
  //   await Gal.putImageBytes(bytes, name: 'cute_wallpapers_${wallpaper.id}', album: 'Cute Wallpapers');
  // }

  Future<void> share(WallpaperEntity wallpaper) async {
    final Uint8List bytes = await _loadBytes(wallpaper);
    final String extension = _extensionOf(wallpaper);
    final XFile file = XFile.fromData(
      bytes,
      name: '${wallpaper.id}.$extension',
      mimeType: extension == 'png' ? 'image/png' : 'image/jpeg',
    );
    // No per-wallpaper title in the share text — only the image and the
    // app name, matching the rest of the UI never surfacing titles.
    await SharePlus.instance.share(
      ShareParams(files: [file], text: 'Cute Wallpapers'),
    );
  }
}
