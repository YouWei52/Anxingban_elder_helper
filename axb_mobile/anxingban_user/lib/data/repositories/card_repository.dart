import '../services/api_client.dart';
import '../models/memory_card.dart';
import '../../core/constants/api_constants.dart';

class CardRepository {
  final ApiClient _apiClient;

  CardRepository(this._apiClient);

  Future<List<MemoryCard>> getCards({
    int? profileId,
    int? tripId,
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.cards,
      queryParameters: {
        'limit': limit,
        if (profileId != null) 'profile_id': profileId,
        if (tripId != null) 'trip_id': tripId,
      },
    );
    return (response.data as List)
        .map((json) => MemoryCard.fromJson(json))
        .toList();
  }

  Future<MemoryCard> getCard(int cardId) async {
    final response = await _apiClient.get('${ApiConstants.cards}/$cardId');
    return MemoryCard.fromJson(response.data);
  }

  Future<MemoryCard> generateCard(int tripId) async {
    final response = await _apiClient.post(
      '${ApiConstants.cards}/generate',
      data: {'trip_id': tripId},
    );
    return MemoryCard.fromJson(response.data);
  }

  Future<void> deleteCard(int cardId) async {
    await _apiClient.delete('${ApiConstants.cards}/$cardId');
  }
}
