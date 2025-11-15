import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user_profile.dart';

class ProfileException implements Exception {
  const ProfileException(this.message);

  final String message;

  @override
  String toString() => 'ProfileException: $message';
}

class ProfileService {
  ProfileService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ??
            const String.fromEnvironment(
              'API_BASE_URL',
              defaultValue: 'http://localhost:3000',
            );

  final http.Client _client;
  final String _baseUrl;

  Future<UserProfile> fetchUserProfile() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/usuario/perfil'),
      headers: const {'Content-Type': 'application/json'},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> payload =
          jsonDecode(response.body) as Map<String, dynamic>;
      return UserProfile.fromJson(payload);
    }

    throw ProfileException(_resolveErrorMessage(response));
  }

  Future<void> updateRidePreferences(RidePreferences preferences) async {
    final response = await _client.put(
      Uri.parse('$_baseUrl/usuario/perfil/atualizar'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(preferences.toJson()),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    throw ProfileException(_resolveErrorMessage(response));
  }

  String _resolveErrorMessage(http.Response response) {
    try {
      final Map<String, dynamic> payload =
          jsonDecode(response.body) as Map<String, dynamic>;
      final message = payload['message'] ?? payload['error'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    } on FormatException {
      // Response body was not a valid JSON, ignore and return generic message
    } on TypeError {
      // Response body had an unexpected shape, ignore and return generic message
    }
    return 'Não foi possível carregar os dados. Tente novamente.';
  }
}
