class TripModel {
  final int id;
  final int profileId;
  final String destination;
  final DateTime travelDate;
  final String passToken;
  final String passQrSvg;
  final String status;
  final DateTime createdAt;

  TripModel({
    required this.id,
    required this.profileId,
    required this.destination,
    required this.travelDate,
    required this.passToken,
    required this.passQrSvg,
    required this.status,
    required this.createdAt,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'],
      profileId: json['profile_id'],
      destination: json['destination'],
      travelDate: DateTime.parse(json['travel_date']),
      passToken: json['pass_token'],
      passQrSvg: json['pass_qr_svg'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
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
}
