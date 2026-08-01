import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../services/local_storage_service.dart';

/// Controls the app's [ThemeMode] and persists the user's choice.
///
/// The soft pastel light theme is the default, primary experience; the
/// user may opt into the softer "plum dusk" dark theme from Settings.
class ThemeProvider extends ChangeNotifier {
  ThemeProvider(this._storage) {
    _restore();
  }

  final LocalStorageService _storage;

  ThemeMode _themeMode = ThemeMode.light;
  bool _isRestored = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isRestored => _isRestored;

  Future<void> _restore() async {
    final String? saved = await _storage.getString(AppConstants.prefKeyThemeMode);
    _themeMode = _fromString(saved);
    _isRestored = true;
    notifyListeners();
  }

  Future<void> setDarkMode({required bool enabled}) async {
    _themeMode = enabled ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    await _storage.setString(AppConstants.prefKeyThemeMode, _toString(_themeMode));
  }

  Future<void> toggle() => setDarkMode(enabled: !isDarkMode);

  ThemeMode _fromString(String? value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
      default:
        return ThemeMode.light;
    }
  }

  String _toString(ThemeMode mode) => mode == ThemeMode.light ? 'light' : 'dark';
}
