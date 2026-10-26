class ProfileModel {
  final int id;
  final int elderId;
  final int userId;
  final String elderNickname;
  final String? elderPhone;
  final DateTime createdAt;

  ProfileModel({
    required this.id,
    required this.elderId,
    required this.userId,
    required this.elderNickname,
    this.elderPhone,
    required this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as int,
      elderId: json['elder_id'] as int,
      userId: json['user_id'] as int,
      elderNickname: json['elder_nickname'] as String? ?? '未知',
      elderPhone: json['elder_phone'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'elder_id': elderId,
      'user_id': userId,
      'elder_nickname': elderNickname,
      'elder_phone': elderPhone,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
