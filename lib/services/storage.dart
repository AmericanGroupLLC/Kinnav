import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper over shared_preferences for typed, namespaced persistence.
/// Isolating this makes it easy to swap for a backend-backed store later.
class Storage {
  Storage._(this._prefs);
  final SharedPreferences _prefs;

  static Storage? _instance;
  static Storage get instance => _instance!;

  static Future<Storage> init() async {
    _instance ??= Storage._(await SharedPreferences.getInstance());
    return _instance!;
  }

  String? getString(String key) => _prefs.getString(key);
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  bool getBool(String key, {bool fallback = false}) =>
      _prefs.getBool(key) ?? fallback;
  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);

  Map<String, dynamic>? getJson(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> setJson(String key, Map<String, dynamic> value) =>
      _prefs.setString(key, jsonEncode(value));

  List<dynamic>? getJsonList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    return jsonDecode(raw) as List<dynamic>;
  }

  Future<void> setJsonList(String key, List<dynamic> value) =>
      _prefs.setString(key, jsonEncode(value));

  Set<String> getStringSet(String key) =>
      _prefs.getStringList(key)?.toSet() ?? <String>{};
  Future<void> setStringSet(String key, Set<String> value) =>
      _prefs.setStringList(key, value.toList());

  Future<void> remove(String key) => _prefs.remove(key);
  Future<void> clear() => _prefs.clear();
}
