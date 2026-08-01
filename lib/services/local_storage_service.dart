import 'package:shared_preferences/shared_preferences.dart';

/// Thin, testable wrapper around [SharedPreferences].
///
/// Every other layer (providers, repositories) talks to storage through
/// this service instead of touching `SharedPreferences` directly, so the
/// underlying persistence mechanism can be swapped later without ripple
/// effects.
class LocalStorageService {
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();

  Future<String?> getString(String key) async {
    final SharedPreferences prefs = await _instance;
    return prefs.getString(key);
  }

  Future<bool> setString(String key, String value) async {
    final SharedPreferences prefs = await _instance;
    return prefs.setString(key, value);
  }

  Future<bool?> getBool(String key) async {
    final SharedPreferences prefs = await _instance;
    return prefs.getBool(key);
  }

  Future<bool> setBool(String key, {required bool value}) async {
    final SharedPreferences prefs = await _instance;
    return prefs.setBool(key, value);
  }

  Future<List<String>> getStringList(String key) async {
    final SharedPreferences prefs = await _instance;
    return prefs.getStringList(key) ?? const [];
  }

  Future<bool> setStringList(String key, List<String> value) async {
    final SharedPreferences prefs = await _instance;
    return prefs.setStringList(key, value);
  }

  Future<bool> remove(String key) async {
    final SharedPreferences prefs = await _instance;
    return prefs.remove(key);
  }
}
