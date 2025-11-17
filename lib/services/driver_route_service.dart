import 'dart:convert';

import 'package:http/http.dart' as http;

class DriverRouteException implements Exception {
  const DriverRouteException(this.message);

  final String message;

  @override
  String toString() => 'DriverRouteException: $message';
}

class DriverRouteService {
  DriverRouteService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ??
            const String.fromEnvironment(
              'API_BASE_URL',
              defaultValue: 'http://localhost:3000',
            );

  final http.Client _client;
  final String _baseUrl;

  Future<void> saveRoutePreferences({
    required List<Map<String, dynamic>> routes,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/motorista/rotas'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'routes': routes}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    throw DriverRouteException(_resolveErrorMessage(response));
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
      // Response was not a JSON, ignore.
    } on TypeError {
      // JSON structure different than expected, ignore.
    }
    return 'Não foi possível salvar suas preferências de rota. Tente novamente.';
  }
}
