import 'package:flutter/services.dart';

class GoogleMapsRouteLauncher {
  const GoogleMapsRouteLauncher();

  static const _baseUrl = 'https://www.google.com/maps/dir/?api=1';

  Future<String> openRoute({
    required String origin,
    required String destination,
    List<String> waypoints = const [],
  }) async {
    final sanitizedOrigin = _sanitizeAddress(origin);
    final sanitizedDestination = _sanitizeAddress(destination);

    if (sanitizedOrigin.isEmpty || sanitizedDestination.isEmpty) {
      throw PlatformException(
        code: 'invalid_route_arguments',
        message: 'Origem e destino são obrigatórios para abrir a rota.',
      );
    }

    final sanitizedWaypoints = waypoints
        .map(_sanitizeAddress)
        .where((address) => address.isNotEmpty)
        .toList();

    final buffer = StringBuffer(_baseUrl)
      ..write('&origin=$sanitizedOrigin')
      ..write('&destination=$sanitizedDestination');

    if (sanitizedWaypoints.isNotEmpty) {
      buffer
        ..write('&waypoints=optimize:true|')
        ..write(sanitizedWaypoints.join('|'));
    }

    buffer.write('&travelmode=driving');

    return buffer.toString();
  }

  String _sanitizeAddress(String value) {
    if (value.trim().isEmpty) {
      return '';
    }

    final normalized = _removeDiacritics(value.trim());
    final cleaned =
        normalized.replaceAll(RegExp(r'[^a-zA-Z0-9.,\- ]+'), ' ');

    return cleaned.trim().replaceAll(RegExp(r'\s+'), '+');
  }
}

String _removeDiacritics(String value) {
  final buffer = StringBuffer();
  for (final rune in value.runes) {
    final character = String.fromCharCode(rune);
    buffer.write(_diacriticMapping[character] ?? character);
  }
  return buffer.toString();
}

const Map<String, String> _diacriticMapping = {
  'á': 'a',
  'à': 'a',
  'â': 'a',
  'ã': 'a',
  'ä': 'a',
  'Á': 'A',
  'À': 'A',
  'Â': 'A',
  'Ã': 'A',
  'Ä': 'A',
  'é': 'e',
  'è': 'e',
  'ê': 'e',
  'ë': 'e',
  'É': 'E',
  'È': 'E',
  'Ê': 'E',
  'Ë': 'E',
  'í': 'i',
  'ì': 'i',
  'î': 'i',
  'ï': 'i',
  'Í': 'I',
  'Ì': 'I',
  'Î': 'I',
  'Ï': 'I',
  'ó': 'o',
  'ò': 'o',
  'ô': 'o',
  'õ': 'o',
  'ö': 'o',
  'Ó': 'O',
  'Ò': 'O',
  'Ô': 'O',
  'Õ': 'O',
  'Ö': 'O',
  'ú': 'u',
  'ù': 'u',
  'û': 'u',
  'ü': 'u',
  'Ú': 'U',
  'Ù': 'U',
  'Û': 'U',
  'Ü': 'U',
  'ñ': 'n',
  'Ñ': 'N',
  'ç': 'c',
  'Ç': 'C',
};
