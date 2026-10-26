class MemoryCard {
  final int id;
  final int profileId;
  final int tripId;
  final String title;
  final String content;
  final List<String> imageUrls;
  final DateTime createdAt;

  MemoryCard({
    required this.id,
    required this.profileId,
    required this.tripId,
    required this.title,
    required this.content,
    required this.imageUrls,
    required this.createdAt,
  });

  factory MemoryCard.fromJson(Map<String, dynamic> json) {
    return MemoryCard(
      id: json['id'] as int,
      profileId: json['profile_id'] as int,
      tripId: json['trip_id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrls: json['image_urls'] != null
          ? List<String>.from(json['image_urls'] as List)
          : [],
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'trip_id': tripId,
      'title': title,
      'content': content,
      'image_urls': imageUrls,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
