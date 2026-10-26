class SosRecord {
  final int id;
  final int profileId;
  final int? tripId;
  final double? latitude;
  final double? longitude;
  final String? networkStatus;
  final DateTime createdAt;

  SosRecord({
    required this.id,
    required this.profileId,
    this.tripId,
    this.latitude,
    this.longitude,
    this.networkStatus,
    required this.createdAt,
  });

  factory SosRecord.fromJson(Map<String, dynamic> json) {
    return SosRecord(
      id: json['id'] as int,
      profileId: json['profile_id'] as int,
      tripId: json['trip_id'] as int?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      networkStatus: json['network_status'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'trip_id': tripId,
      'latitude': latitude,
      'longitude': longitude,
      'network_status': networkStatus,
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool get hasLocation => latitude != null && longitude != null;
}
