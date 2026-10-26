class TaskModel {
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

  TaskModel({
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

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      profileId: json['profile_id'],
      tripId: json['trip_id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      completedNote: json['completed_note'],
      photoUrl: json['photo_url'],
      feedbackText: json['feedback_text'],
      hearts: json['hearts'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
    );
  }
}
