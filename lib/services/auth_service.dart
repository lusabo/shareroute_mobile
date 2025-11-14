import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => 'AuthException: $message';
}

class AuthService {
  AuthService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ??
            const String.fromEnvironment(
              'API_BASE_URL',
              defaultValue: 'http://localhost:3000',
            );

  final http.Client _client;
  final String _baseUrl;

  Future<void> requestCode(String registration) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/auth/request-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'registration': registration}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    throw AuthException(_resolveErrorMessage(response));
  }

  Future<String> verifyCode({
    required String registration,
    required String code,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/auth/verify-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'registration': registration, 'code': code}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> payload = jsonDecode(response.body);
      final token = payload['token'];
      if (token is String && token.isNotEmpty) {
        return token;
      }
      throw const AuthException('Token de autenticação inválido.');
    }

    throw AuthException(_resolveErrorMessage(response));
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
      // Ignored: body is not a valid JSON
    } on TypeError {
      // Ignored: JSON structure is different than expected
    }
    return 'Não foi possível concluir a autenticação. Tente novamente.';
  }
}
