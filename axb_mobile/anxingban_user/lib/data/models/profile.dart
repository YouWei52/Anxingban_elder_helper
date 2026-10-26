class Profile {
  final int id;
  final int elderId;
  final int userId;
  final DateTime createdAt;

  Profile({
    required this.id,
    required this.elderId,
    required this.userId,
    required this.createdAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as int,
      elderId: json['elder_id'] as int,
      userId: json['user_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'elder_id': elderId,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
