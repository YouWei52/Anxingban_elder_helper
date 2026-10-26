import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userTypeKey = 'user_type';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Token管理
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  // 用户信息
  Future<void> saveUserId(int userId) async {
    await _prefs?.setInt(_userIdKey, userId);
  }

  int? getUserId() {
    return _prefs?.getInt(_userIdKey);
  }

  Future<void> saveUserType(String userType) async {
    await _prefs?.setString(_userTypeKey, userType);
  }

  String? getUserType() {
    return _prefs?.getString(_userTypeKey);
  }

  // 清除所有数据
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    await _prefs?.clear();
  }

  // 检查是否已登录
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
