import 'package:flutter/material.dart';

import '../../data/models/user.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository;
  final StorageService _storageService;

  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._authRepository, this._storageService);

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  Future<bool> register({
    required String nickname,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authRepository.register(
        nickname: nickname,
        phone: phone,
        password: password,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({required String phone, required String password}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final authResponse = await _authRepository.login(
        phone: phone,
        password: password,
      );

      await _storageService.saveToken(authResponse.accessToken);
      await _storageService.saveUserId(authResponse.userId);
      await _storageService.saveUserType(authResponse.userType);

      _currentUser = await _authRepository.getCurrentUser();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadCurrentUser() async {
    try {
      final isLoggedIn = await _storageService.isLoggedIn();
      if (isLoggedIn) {
        _currentUser = await _authRepository.getCurrentUser();
        notifyListeners();
      }
    } catch (e) {
      await logout();
    }
  }

  Future<void> logout() async {
    await _storageService.clearAll();
    _currentUser = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  String _parseError(dynamic error) {
    final errorStr = error.toString();

    if (errorStr.contains('DioException')) {
      if (errorStr.contains('409') || errorStr.contains('CONFLICT')) {
        return '该手机号已被注册，请直接登录';
      } else if (errorStr.contains('401') ||
          errorStr.contains('UNAUTHORIZED')) {
        return '手机号或密码错误';
      } else if (errorStr.contains('404')) {
        return '服务器接口不存在，请检查后端服务';
      } else if (errorStr.contains('500')) {
        return '服务器内部错误，请稍后重试';
      } else if (errorStr.contains('CONNECTION')) {
        return '无法连接到服务器，请检查网络';
      } else if (errorStr.contains('TIMEOUT')) {
        return '请求超时，请检查网络连接';
      }
    }

    return '操作失败，请稍后重试';
  }
}
