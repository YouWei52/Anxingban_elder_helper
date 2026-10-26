import 'dart:convert';

import 'package:http/http.dart' as http;

import '../auth/elder_session.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class ApiClient {
  static const String baseUrl = 'http://127.0.0.1:8000';

  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<dynamic> _request(
    String endpoint, {
    String method = 'GET',
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final token = await ElderSession.token();
    final defaultHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    late http.Response response;

    try {
      switch (method) {
        case 'GET':
          response = await _client.get(uri, headers: defaultHeaders);
          break;
        case 'POST':
          response = await _client.post(
            uri,
            headers: defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'PATCH':
          response = await _client.patch(
            uri,
            headers: defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'PUT':
          response = await _client.put(
            uri,
            headers: defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'DELETE':
          response = await _client.delete(uri, headers: defaultHeaders);
          break;
        default:
          throw ApiException('Unsupported HTTP method: $method');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) return {};
        return jsonDecode(response.body);
      } else {
        if (response.statusCode == 401 || response.statusCode == 403) {
          await ElderSession.clear();
        }
        String message = '请求失败';
        try {
          final error = jsonDecode(response.body);
          message = error['detail'] ?? message;
        } catch (_) {
          message = response.body.isNotEmpty ? response.body : message;
        }
        throw ApiException(message, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // Elder authentication
  Future<Map<String, dynamic>> elderLogin({
    required String phone,
    required String password,
  }) async {
    final result = await _request(
      '/api/auth/elder/login',
      method: 'POST',
      body: {'phone': phone, 'password': password},
    );
    await ElderSession.save(
      token: result['access_token'] as String,
      elderId: result['user_id'] as int,
    );
    return result;
  }

  Future<Map<String, dynamic>> elderRegister({
    required String name,
    required String phone,
    required String password,
    String? interests,
  }) async {
    final result = await _request(
      '/api/auth/elder/register',
      method: 'POST',
      body: {
        'name': name,
        'phone': phone,
        'password': password,
        'interests': interests ?? '',
        'health_info': '{}',
      },
    );
    await ElderSession.save(
      token: result['access_token'] as String,
      elderId: result['user_id'] as int,
    );
    return result;
  }

  Future<Map<String, dynamic>> getElderInfo() async {
    return await _request('/api/auth/elder/me');
  }

  // Elder profile API
  Future<List<dynamic>> getProfiles() async {
    final result = await _request('/api/elder/profiles');
    return result is List ? result : [];
  }

  Future<Map<String, dynamic>> getProfile(int id) async {
    return await _request('/api/elder/profiles/$id');
  }

  // Elder trip API
  Future<Map<String, dynamic>> getTrip(int id) async {
    return await _request('/api/elder/trips/$id');
  }

  Future<List<dynamic>> getTrips({int? profileId}) async {
    final query = profileId == null ? '' : '?profile_id=$profileId';
    final result = await _request('/api/elder/trips$query');
    return result is List ? result : [];
  }

  Future<Map<String, dynamic>> getTripPass(int id) async {
    return await _request('/api/elder/trips/$id/pass');
  }

  // Elder task API
  Future<Map<String, dynamic>> getTask(int id) async {
    return await _request('/api/elder/tasks/$id');
  }

  Future<List<dynamic>> getTasks({int? profileId}) async {
    final query = profileId == null ? '' : '?profile_id=$profileId';
    final result = await _request('/api/elder/tasks$query');
    return result is List ? result : [];
  }

  // Elder SOS API
  Future<Map<String, dynamic>> triggerSOS(Map<String, dynamic> data) async {
    return await _request('/api/elder/sos/trigger', method: 'POST', body: data);
  }

  Future<List<dynamic>> getSOSRecords({int? profileId}) async {
    final query = profileId == null ? '' : '?profile_id=$profileId';
    final result = await _request('/api/elder/sos$query');
    return result is List ? result : [];
  }

  // Elder guide API
  Future<Map<String, dynamic>> askGuide(String question) async {
    return await _request(
      '/api/elder/guide/ask',
      method: 'POST',
      body: {'question': question},
    );
  }

  // Elder card API
  Future<Map<String, dynamic>> generateCard(Map<String, dynamic> data) async {
    return await _request(
      '/api/elder/cards/generate',
      method: 'POST',
      body: data,
    );
  }

  Future<Map<String, dynamic>> getCard(int id) async {
    return await _request('/api/elder/cards/$id');
  }

  Future<List<dynamic>> getCards({int? profileId, int? tripId}) async {
    final params = <String>[];
    if (profileId != null) params.add('profile_id=$profileId');
    if (tripId != null) params.add('trip_id=$tripId');
    final query = params.isEmpty ? '' : '?${params.join('&')}';
    final result = await _request('/api/elder/cards$query');
    return result is List ? result : [];
  }

  Future<void> deleteCard(int id) async {
    await _request('/api/elder/cards/$id', method: 'DELETE');
  }

  // Trip management
  Future<Map<String, dynamic>> createTrip(Map<String, dynamic> data) async {
    return await _request('/api/trips', method: 'POST', body: data);
  }

  Future<void> deleteTrip(int tripId) async {
    await _request('/api/trips/$tripId', method: 'DELETE');
  }

  // Task management
  Future<Map<String, dynamic>> createTask(Map<String, dynamic> data) async {
    return await _request('/api/tasks', method: 'POST', body: data);
  }

  // Profile management
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    return await _request(
      '/api/profiles/${data['id']}',
      method: 'PUT',
      body: data,
    );
  }

  void dispose() {
    _client.close();
  }
}
