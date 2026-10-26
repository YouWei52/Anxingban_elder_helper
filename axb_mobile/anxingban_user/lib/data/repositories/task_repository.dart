import '../services/api_client.dart';
import '../models/task.dart';
import '../../core/constants/api_constants.dart';

class TaskRepository {
  final ApiClient _apiClient;

  TaskRepository(this._apiClient);

  Future<List<Task>> getTasks({required int profileId, int limit = 20}) async {
    final response = await _apiClient.get(
      ApiConstants.tasks,
      queryParameters: {'profile_id': profileId, 'limit': limit},
    );
    return (response.data as List).map((json) => Task.fromJson(json)).toList();
  }

  Future<Task> createTask({
    required int profileId,
    required int tripId,
    required String title,
    required String description,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.tasks,
      data: {
        'profile_id': profileId,
        'trip_id': tripId,
        'title': title,
        'description': description,
      },
    );
    return Task.fromJson(response.data);
  }

  Future<Task> completeTask({
    required int taskId,
    String? completedNote,
    String? photoUrl,
  }) async {
    final response = await _apiClient.post(
      '${ApiConstants.tasks}/$taskId/complete',
      data: {'completed_note': completedNote, 'photo_url': photoUrl},
    );
    return Task.fromJson(response.data);
  }

  Future<Task> feedbackTask({
    required int taskId,
    required String feedbackText,
    int heartsDelta = 1,
  }) async {
    final response = await _apiClient.post(
      '${ApiConstants.tasks}/$taskId/feedback',
      data: {'feedback_text': feedbackText, 'hearts_delta': heartsDelta},
    );
    return Task.fromJson(response.data);
  }

  Future<void> deleteTask(int taskId) async {
    await _apiClient.delete('${ApiConstants.tasks}/$taskId');
  }
}
