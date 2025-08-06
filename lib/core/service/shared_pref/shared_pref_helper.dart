import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static const String keyUserId = 'id';
  static const String keyUserRole = 'role';
  static const String keyIsBlocked = 'blocked';
  static const String keyStatus = 'status';

  Future<void> saveUserSession(String uid, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUserId, uid);
    await prefs.setString(keyUserRole, role);
  }

  Future<void> saveUserStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyStatus, status);
  }

  Future<void> saveUserBlocked(bool isBlocked) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsBlocked, isBlocked);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUserId);
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUserRole);
  }

  Future<String?> getUserStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyStatus);
  }

  Future<bool> isUserBlocked() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsBlocked) ?? false;
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
    await prefs.remove(keyIsBlocked);
    await prefs.remove(keyStatus);
  }
}

