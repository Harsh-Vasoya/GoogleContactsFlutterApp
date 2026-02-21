import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  StorageHelper._();
  static final StorageHelper instance = StorageHelper._();

  SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<bool> setString(String key, String value) async {
    return (await prefs).setString(key, value);
  }

  Future<String?> getString(String key) async {
    return (await prefs).getString(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return (await prefs).setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    return (await prefs).getBool(key);
  }

  Future<bool> remove(String key) async {
    return (await prefs).remove(key);
  }

  Future<bool> clear() async {
    return (await prefs).clear();
  }
}
