import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/core/enums/status_register.dart';
import 'package:test/core/service/shared_pref/pref_keys.dart';

class SharedPrefHelper {
  static const String keyUserId = 'id';
  static const String keyUserRole = 'role';

  Future<void> saveUserSession(String uid, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUserId, uid);
    await prefs.setString(keyUserRole, role);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUserId);
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUserRole);
  }

  Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyUserId);
    await prefs.remove(keyUserRole);
  }
}

