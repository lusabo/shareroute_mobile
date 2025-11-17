import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/driver_active_ride.dart';

class DriverActiveRideException implements Exception {
  const DriverActiveRideException(this.message);

  final String message;

  @override
  String toString() => 'DriverActiveRideException: $message';
}

class DriverActiveRideService {
  DriverActiveRideService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ??
            const String.fromEnvironment(
              'API_BASE_URL',
              defaultValue: 'http://localhost:3000',
            );

  final http.Client _client;
  final String _baseUrl;

  Future<DriverActiveRide> fetchActiveRide() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/motorista/caronas/ativa'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final Map<String, dynamic> payload =
            jsonDecode(response.body) as Map<String, dynamic>;
        return DriverActiveRide.fromJson(payload);
      } on FormatException {
        throw const DriverActiveRideException(
          'Não foi possível ler os dados da carona ativa.',
        );
      } on TypeError {
        throw const DriverActiveRideException(
          'Os dados recebidos estão em um formato inesperado.',
        );
      }
    }

    throw DriverActiveRideException(_resolveErrorMessage(response));
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
      // Ignored: not JSON.
    } on TypeError {
      // Ignored: unexpected structure.
    }

    return 'Não foi possível carregar a carona ativa. Tente novamente.';
  }
}
