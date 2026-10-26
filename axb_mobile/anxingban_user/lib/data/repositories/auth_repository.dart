import '../services/api_client.dart';
import '../models/user.dart';
import '../../core/constants/api_constants.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<AuthResponse> register({
    required String nickname,
    required String phone,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.userRegister,
      data: {'nickname': nickname, 'phone': phone, 'password': password},
    );
    return AuthResponse.fromJson(response.data);
  }

  Future<AuthResponse> login({
    required String phone,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.userLogin,
      data: {'phone': phone, 'password': password},
    );
    return AuthResponse.fromJson(response.data);
  }

  Future<User> getCurrentUser() async {
    final response = await _apiClient.get(ApiConstants.userMe);
    return User.fromJson(response.data);
  }
}
