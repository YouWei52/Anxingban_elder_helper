class ProfileModel {
  final int id;
  final String parentName;
  final String parentPhone;
  final String childName;
  final String childPhone;
  final String? healthInfo;
  final String? interests;
  final String? wechatWebhookUrl;
  final DateTime createdAt;

  ProfileModel({
    required this.id,
    required this.parentName,
    required this.parentPhone,
    required this.childName,
    required this.childPhone,
    this.healthInfo,
    this.interests,
    this.wechatWebhookUrl,
    required this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      parentName: json['parent_name'],
      parentPhone: json['parent_phone'],
      childName: json['child_name'],
      childPhone: json['child_phone'],
      healthInfo: json['health_info'],
      interests: json['interests'],
      wechatWebhookUrl: json['wechat_webhook_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_name': parentName,
      'parent_phone': parentPhone,
      'child_name': childName,
      'child_phone': childPhone,
      'health_info': healthInfo,
      'interests': interests,
      'wechat_webhook_url': wechatWebhookUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
