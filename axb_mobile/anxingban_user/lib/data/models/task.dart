class Task {
  final int id;
  final int profileId;
  final int tripId;
  final String title;
  final String description;
  final String status;
  final String? completedNote;
  final String? photoUrl;
  final String? feedbackText;
  final int hearts;
  final DateTime createdAt;
  final DateTime? completedAt;

  Task({
    required this.id,
    required this.profileId,
    required this.tripId,
    required this.title,
    required this.description,
    required this.status,
    this.completedNote,
    this.photoUrl,
    this.feedbackText,
    required this.hearts,
    required this.createdAt,
    this.completedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      profileId: json['profile_id'] as int,
      tripId: json['trip_id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      completedNote: json['completed_note'] as String?,
      photoUrl: json['photo_url'] as String?,
      feedbackText: json['feedback_text'] as String?,
      hearts: json['hearts'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'trip_id': tripId,
      'title': title,
      'description': description,
      'status': status,
      'completed_note': completedNote,
      'photo_url': photoUrl,
      'feedback_text': feedbackText,
      'hearts': hearts,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  bool get isPending => status == 'pending';
  bool get isCompleted => status == 'completed';
}
