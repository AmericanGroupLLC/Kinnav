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

  /// Reads a JSON object, treating unreadable data as absent.
  ///
  /// `AppState._load()` runs in the constructor, before `runApp`. An
  /// interrupted write or an older on-disk shape would throw there and the app
  /// would fail to launch — every launch, with no way for the user to recover
  /// short of reinstalling. Dropping the bad key degrades to a default instead.
  Map<String, dynamic>? getJson(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> setJson(String key, Map<String, dynamic> value) =>
      _prefs.setString(key, jsonEncode(value));

  /// Reads a JSON list, treating unreadable data as absent. See [getJson].
  List<dynamic>? getJsonList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is List<dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
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
