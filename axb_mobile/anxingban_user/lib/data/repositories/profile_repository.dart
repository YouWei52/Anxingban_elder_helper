import '../services/api_client.dart';
import '../models/profile.dart';
import '../../core/constants/api_constants.dart';

class ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepository(this._apiClient);

  Future<List<Profile>> getProfiles({int limit = 20}) async {
    final response = await _apiClient.get(
      ApiConstants.profiles,
      queryParameters: {'limit': limit},
    );
    return (response.data as List)
        .map((json) => Profile.fromJson(json))
        .toList();
  }

  Future<Profile> getProfile(int profileId) async {
    final response = await _apiClient.get(
      '${ApiConstants.profiles}/$profileId',
    );
    return Profile.fromJson(response.data);
  }

  Future<Profile> createProfile({
    required int elderId,
    required int userId,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.profiles,
      data: {'elder_id': elderId, 'user_id': userId},
    );
    return Profile.fromJson(response.data);
  }

  Future<void> deleteProfile(int profileId) async {
    await _apiClient.delete('${ApiConstants.profiles}/$profileId');
  }
}
