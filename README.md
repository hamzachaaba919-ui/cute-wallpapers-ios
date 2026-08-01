# Cute Wallpapers

A premium, **fully offline** Flutter wallpaper app. There is no backend, no
API, no database, no admin panel, and no ads — every wallpaper ships inside
the app as a bundled asset, described by `assets/data/wallpapers.json`.
Favorites and theme preference are stored on-device with
`shared_preferences`. Nothing the app does ever requires an internet
connection.

## One-time setup

```bash
cd cute_wallpapers
flutter pub get
```

The `android/` folder is already generated and configured (application id,
manifest permissions for setting the wallpaper and saving to the gallery).
If you ever need to regenerate it, run
`flutter create --platforms=android --org com.cutewallpapers -a kotlin .`
and choose **N** if prompted to overwrite anything under `lib/`.

## Verifying

```bash
flutter pub get
flutter analyze
flutter run
```

You should see a branded splash screen, then a Home tab with a masonry grid
of wallpapers, a collection filter row (Cute / Kawaii / Animals / Aesthetic
/ Pink), working Search and Favorites tabs, a full-screen pinch-to-zoom
wallpaper viewer with Set Wallpaper / Save / Share, and a Settings tab with
a dark/light toggle that persists across restarts.

## Architecture

- `lib/core/` — colors, typography, spacing scale, the dark (default) +
  light `ThemeData`, `go_router` navigation, responsive breakpoints, and the
  small `Collections` constant (the five fixed collections — deliberately
  not a full category system).
- `lib/domain/` + `lib/data/` — `WallpaperEntity`/`WallpaperModel` and a
  single `WallpaperRepository` implementation that reads
  `assets/data/wallpapers.json` via `rootBundle` and persists favorites via
  `SharedPreferences`. No network layer exists anywhere in this app.
- `lib/providers/` — `ThemeProvider`, `WallpaperProvider` (in-memory
  catalog + collection filter + local search), `FavoritesProvider`.
- `lib/services/` — `LocalStorageService` (SharedPreferences wrapper) and
  `WallpaperActionsService` (set wallpaper via `wallpaper_manager_plus`,
  save to gallery via `gal`, share via `share_plus` — all operating on the
  bundled asset bytes).
- `lib/presentation/` — Splash, the 4-tab shell (Home / Search / Favorites
  / Settings), the wallpaper detail viewer, and Settings/About/Legal.

## Replacing the placeholder wallpapers

The 30 images under `assets/images/wallpapers/` (6 per collection) were
**procedurally generated** as a working demonstration of the asset
pipeline — soft gradients with simple cute motifs. They are safe to ship
in the sense that no third party owns them, but they are not meant to be
your final content. Before publishing:

1. Replace the files in `assets/images/wallpapers/` with your own
   real, licensed wallpaper art (recommended: portrait, ~1080×1920 or
   larger, JPEG for photos / PNG if you need transparency).
2. Update `assets/data/wallpapers.json` to match — each entry needs `id`,
   `title`, `assetPath`, `collection` (one of `Cute`, `Kawaii`, `Animals`,
   `Aesthetic`, `Pink`), `width`, `height`, `tags`, and `isFeatured`.
3. Re-run `flutter pub get` if you add/remove files so the asset bundle
   picks up the changes (folder-level asset declarations pick up new files
   automatically on a fresh build, but a clean `pub get`/rebuild is the
   safest way to confirm).

## Before publishing to Google Play

- Replace the `[DATE]` / `[SUPPORT EMAIL]` placeholders in
  `lib/core/constants/legal_content.dart`.
- Update `supportEmail` / `playStoreUrl` in
  `lib/core/constants/app_constants.dart`.
- Swap in your real app icon and run `flutter_launcher_icons` (or add the
  package back) if you want a custom launcher icon — none is configured
  yet.
- Confirm `compileSdk`/`targetSdk` in `android/app/build.gradle.kts` meet
  the current Play Store requirement (inherited from your installed
  Flutter SDK by default).
- Keep `key.properties` / `*.jks` out of version control (already covered
  by `.gitignore`) and configure a real release signing config before
  building the app bundle.
