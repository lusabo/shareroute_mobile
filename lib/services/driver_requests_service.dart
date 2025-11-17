import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/driver_ride_request.dart';

class DriverRequestsException implements Exception {
  const DriverRequestsException(this.message);

  final String message;

  @override
  String toString() => 'DriverRequestsException: $message';
}

class DriverRequestsService {
  DriverRequestsService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ??
            const String.fromEnvironment(
              'API_BASE_URL',
              defaultValue: 'http://localhost:3000',
            );

  final http.Client _client;
  final String _baseUrl;

  Future<List<DriverRideRequest>> fetchRideRequests() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/motorista/solicitacoes'),
      headers: const {'Content-Type': 'application/json'},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> payload =
          jsonDecode(response.body) as Map<String, dynamic>;
      final requestsJson = payload['requests'] as List<dynamic>?;
      if (requestsJson == null) {
        return const [];
      }
      return requestsJson
          .map((request) =>
              DriverRideRequest.fromJson(request as Map<String, dynamic>))
          .toList();
    }

    throw DriverRequestsException(_resolveErrorMessage(response));
  }

  Future<void> respondToRequest({
    required String requestId,
    required bool accept,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/motorista/solicitacoes/responder'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'requestId': requestId,
        'action': accept ? 'accept' : 'reject',
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    throw DriverRequestsException(_resolveErrorMessage(response));
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
      // ignore invalid format
    } on TypeError {
      // ignore unexpected structure
    }

    return 'Não foi possível carregar as solicitações. Tente novamente.';
  }
}
