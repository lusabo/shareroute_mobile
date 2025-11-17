import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/passenger_review_submission.dart';

class PassengerReviewException implements Exception {
  const PassengerReviewException(this.message);

  final String message;

  @override
  String toString() => 'PassengerReviewException: $message';
}

class PassengerReviewService {
  PassengerReviewService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ??
            const String.fromEnvironment(
              'API_BASE_URL',
              defaultValue: 'http://localhost:3000',
            );

  final http.Client _client;
  final String _baseUrl;

  Future<void> submitReview(PassengerReviewSubmission submission) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/passageiro/avaliacoes'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(submission.toJson()),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    throw PassengerReviewException(_resolveErrorMessage(response));
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
      // ignore invalid response format
    } on TypeError {
      // ignore invalid response shape
    }
    return 'Não foi possível enviar a avaliação. Tente novamente.';
  }
}
