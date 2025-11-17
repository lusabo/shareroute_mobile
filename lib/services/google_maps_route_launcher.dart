import 'package:flutter/services.dart';

class GoogleMapsRouteLauncher {
  const GoogleMapsRouteLauncher();

  static const _channel = MethodChannel('com.shareroute/maps');

  Future<String> openRoute({
    required String origin,
    required String destination,
    List<String> waypoints = const [],
  }) async {
    final filteredWaypoints = waypoints.where((wp) => wp.trim().isNotEmpty).toList();

    final url = await _channel.invokeMethod<String>('openRoute', {
      'origin': origin,
      'destination': destination,
      'waypoints': filteredWaypoints,
    });

    if (url == null || url.isEmpty) {
      throw PlatformException(
        code: 'invalid_route_url',
        message: 'Não foi possível montar o link da rota no Google Maps.',
      );
    }

    return url;
  }
}
