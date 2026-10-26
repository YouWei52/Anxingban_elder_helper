class User {
  final int id;
  final String nickname;
  final String phone;
  final DateTime? lastLoginAt;
  final DateTime createdAt;

  User({
    required this.id,
    required this.nickname,
    required this.phone,
    this.lastLoginAt,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      nickname: json['nickname'] as String,
      phone: json['phone'] as String,
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'phone': phone,
      'last_login_at': lastLoginAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class AuthResponse {
  final String accessToken;
  final String tokenType;
  final String userType;
  final int userId;

  AuthResponse({
    required this.accessToken,
    required this.tokenType,
    required this.userType,
    required this.userId,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      userType: json['user_type'] as String,
      userId: json['user_id'] as int,
    );
  }
}
