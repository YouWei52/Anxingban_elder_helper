class ApiConstants {
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String apiPrefix = '/api';

  // Auth endpoints
  static const String userRegister = '$apiPrefix/auth/user/register';
  static const String userLogin = '$apiPrefix/auth/user/login';
  static const String userMe = '$apiPrefix/auth/user/me';

  // Profile endpoints
  static const String profiles = '$apiPrefix/user/profiles';

  // Trip endpoints
  static const String trips = '$apiPrefix/user/trips';

  // Task endpoints
  static const String tasks = '$apiPrefix/user/tasks';

  // SOS endpoints
  static const String sos = '$apiPrefix/user/sos';

  // Card endpoints
  static const String cards = '$apiPrefix/user/cards';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
