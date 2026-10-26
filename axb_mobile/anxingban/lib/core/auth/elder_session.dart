import 'package:shared_preferences/shared_preferences.dart';

class ElderSession {
  static const _tokenKey = 'elder_access_token';
  static const _elderIdKey = 'elder_id';
  static const _profileIdKey = 'elder_profile_id';

  static Future<void> save({
    required String token,
    required int elderId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setInt(_elderIdKey, elderId);
  }

  static Future<String?> token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<int?> elderId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_elderIdKey);
  }

  static Future<int?> profileId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_profileIdKey);
  }

  static Future<void> setProfileId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_profileIdKey, id);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_elderIdKey);
    await prefs.remove(_profileIdKey);
  }
}
