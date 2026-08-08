import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';

import '../domain/entities/wallpaper_entity.dart';

/// Outcome of [WallpaperActionsService.saveToGallery].
///
/// Kept as an explicit result rather than exceptions for the two *expected*
/// outcomes, so the UI can tell "the person said no to the permission
/// prompt" apart from a genuine unexpected failure without inspecting
/// exception types. On [success] the method never throws.
enum SaveWallpaperResult { success, permissionDenied }

/// The on-device actions available from the wallpaper detail screen: save
/// to the Photos library and share. Every image involved is a bundled
/// asset — nothing is ever downloaded over the network.
///
/// iOS has no public API for an app to set the home/lock screen wallpaper
/// directly (unlike Android's WallpaperManager), so this app never attempts
/// it on iOS — this class only ever writes into Photos. [saveToGallery]
/// uses the `gal` plugin (PHPhotoLibrary under the hood on iOS,
/// MediaStore on Android) for the actual write, and the UI then tells the
/// person to finish up themselves via Photos' own "Use as Wallpaper"
/// action — see the success dialog in `wallpaper_detail_screen.dart`. This
/// is the same call path, and therefore the same save behavior, on both
/// platforms.
class WallpaperActionsService {
  Future<Uint8List> _loadBytes(WallpaperEntity wallpaper) async {
    final ByteData data = await rootBundle.load(wallpaper.assetPath);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  String _extensionOf(WallpaperEntity wallpaper) {
    final int dot = wallpaper.assetPath.lastIndexOf('.');
    return dot == -1 ? 'jpg' : wallpaper.assetPath.substring(dot + 1);
  }

  /// Loads [wallpaper]'s bundled image and writes it into the Photos /
  /// gallery library, requesting the add-photos permission first if it
  /// hasn't been granted yet.
  ///
  /// Returns [SaveWallpaperResult.permissionDenied] — rather than
  /// throwing — if the person declines (or has previously declined) the
  /// permission prompt, so the caller can show an explanation instead of a
  /// generic error. Any other failure (a corrupt asset, a full disk, etc.)
  /// is rethrown; the success path itself never throws.
  Future<SaveWallpaperResult> saveToGallery(WallpaperEntity wallpaper) async {
    bool hasAccess = await Gal.hasAccess();
    if (!hasAccess) {
      hasAccess = await Gal.requestAccess();
    }
    if (!hasAccess) {
      return SaveWallpaperResult.permissionDenied;
    }

    final Uint8List bytes = await _loadBytes(wallpaper);
    await Gal.putImageBytes(
      bytes,
      name: 'cute_wallpapers_${wallpaper.id}',
      album: 'Cute Wallpapers',
    );
    return SaveWallpaperResult.success;
  }

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
