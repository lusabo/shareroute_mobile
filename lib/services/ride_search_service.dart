import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/driver_match.dart';
import '../models/ride_direction.dart';

class RideSearchService {
  RideSearchService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Uri _buildUri(String path) {
    const defaultPort = 3000;
    final host = kIsWeb
        ? 'localhost'
        : (defaultTargetPlatform == TargetPlatform.android ? '10.0.2.2' : 'localhost');
    return Uri.parse('http://$host:$defaultPort$path');
  }

  Future<List<DriverMatch>> searchDrivers({
    required RideDirection direction,
    required DateTime date,
    required TimeOfDay time,
  }) async {
    final scheduledAt = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    final response = await _client.post(
      _buildUri('/passageiro/buscar-caronas'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'direction': direction.apiValue,
        'scheduledAt': scheduledAt.toIso8601String(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Não foi possível consultar caronas. Código ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final matchesJson = decoded['matches'] as List<dynamic>?;
    if (matchesJson == null) {
      return const [];
    }
    return matchesJson
        .map((match) => DriverMatch.fromJson(match as Map<String, dynamic>))
        .toList();
  }
}
