import '../services/api_client.dart';
import '../models/trip.dart';
import '../../core/constants/api_constants.dart';

class TripRepository {
  final ApiClient _apiClient;

  TripRepository(this._apiClient);

  Future<List<Trip>> getTrips({required int profileId, int limit = 100}) async {
    final response = await _apiClient.get(
      ApiConstants.trips,
      queryParameters: {'profile_id': profileId, 'limit': limit},
    );
    return (response.data as List).map((json) => Trip.fromJson(json)).toList();
  }

  Future<Trip> getTrip(int tripId) async {
    final response = await _apiClient.get('${ApiConstants.trips}/$tripId');
    return Trip.fromJson(response.data);
  }

  Future<Trip> createTrip({
    required int profileId,
    required String destination,
    required DateTime travelDate,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.trips,
      data: {
        'profile_id': profileId,
        'destination': destination,
        'travel_date': travelDate.toIso8601String().split('T')[0],
      },
    );
    return Trip.fromJson(response.data);
  }

  Future<Map<String, dynamic>> getTripPass(int tripId) async {
    final response = await _apiClient.get('${ApiConstants.trips}/$tripId/pass');
    return response.data;
  }

  Future<void> deleteTrip(int tripId) async {
    await _apiClient.delete('${ApiConstants.trips}/$tripId');
  }
}
