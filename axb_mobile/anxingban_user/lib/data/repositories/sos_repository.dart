import '../services/api_client.dart';
import '../models/sos_record.dart';
import '../../core/constants/api_constants.dart';

class SosRepository {
  final ApiClient _apiClient;

  SosRepository(this._apiClient);

  Future<List<SosRecord>> getSosRecords({
    required int profileId,
    int limit = 100,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.sos,
      queryParameters: {'profile_id': profileId, 'limit': limit},
    );
    return (response.data as List)
        .map((json) => SosRecord.fromJson(json))
        .toList();
  }

  Future<List<SosRecord>> getSosRecordsByProfile(int profileId) async {
    final response = await _apiClient.get(
      '${ApiConstants.sos}/profile/$profileId',
    );
    return (response.data as List)
        .map((json) => SosRecord.fromJson(json))
        .toList();
  }
}
