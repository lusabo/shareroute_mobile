import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/driver_bonus.dart';

class DriverActivationException implements Exception {
  const DriverActivationException(this.message);

  final String message;

  @override
  String toString() => 'DriverActivationException: $message';
}

class DriverActivationService {
  DriverActivationService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ??
            const String.fromEnvironment(
              'API_BASE_URL',
              defaultValue: 'http://localhost:3000',
            );

  final http.Client _client;
  final String _baseUrl;

  Future<List<DriverBonus>> fetchAvailableBonuses() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/motorista/incentivos'),
      headers: const {'Content-Type': 'application/json'},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> payload =
          jsonDecode(response.body) as Map<String, dynamic>;
      final bonusesJson = payload['bonuses'] as List<dynamic>?;
      if (bonusesJson == null) {
        return const [];
      }
      return bonusesJson
          .map((bonus) => DriverBonus.fromJson(bonus as Map<String, dynamic>))
          .toList();
    }

    throw DriverActivationException(_resolveErrorMessage(response));
  }

  Future<void> submitActivation({
    required String vehicleModel,
    required String plate,
    required String color,
    required List<String> preferences,
    required List<String> selectedBonuses,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/motorista/ativacao'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'vehicleModel': vehicleModel,
        'plate': plate,
        'color': color,
        'preferences': preferences,
        'selectedBonuses': selectedBonuses,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    throw DriverActivationException(_resolveErrorMessage(response));
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
      // ignore invalid response
    } on TypeError {
      // ignore unexpected shape
    }
    return 'Não foi possível processar sua solicitação. Tente novamente.';
  }
}
