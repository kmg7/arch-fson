import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static CacheManager? _instance;
  static CacheManager get instance {
    _instance ??= CacheManager._init();
    return _instance!;
  }

  CacheManager._init();

  Future<String?> readString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> writeString(String key, String val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, val);
  }

  Future<void> removeString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
