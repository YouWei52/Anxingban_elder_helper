class Trip {
  final int id;
  final int profileId;
  final String destination;
  final DateTime travelDate;
  final String passToken;
  final String passQrSvg;
  final String status;
  final DateTime createdAt;

  Trip({
    required this.id,
    required this.profileId,
    required this.destination,
    required this.travelDate,
    required this.passToken,
    required this.passQrSvg,
    required this.status,
    required this.createdAt,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as int,
      profileId: json['profile_id'] as int,
      destination: json['destination'] as String,
      travelDate: DateTime.parse(json['travel_date'] as String),
      passToken: json['pass_token'] as String,
      passQrSvg: json['pass_qr_svg'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'destination': destination,
      'travel_date': travelDate.toIso8601String().split('T')[0],
      'pass_token': passToken,
      'pass_qr_svg': passQrSvg,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool get isCompleted => status == 'completed';
  bool get isCreated => status == 'created';
}
