package com.shareroute.shareroute_mobile

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "com.shareroute/maps"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "buildRouteUrl" -> handleBuildRouteUrl(call.arguments, result)
                    "openRoute" -> handleOpenRoute(call.arguments, result)
                    else -> result.notImplemented()
                }
            }
    }

    private fun handleBuildRouteUrl(arguments: Any?, result: MethodChannel.Result) {
        val params = arguments as? Map<*, *>
        val origin = params?.get("origin") as? String
        val destination = params?.get("destination") as? String
        val waypoints = params?.get("waypoints") as? List<*> ?: emptyList<Any>()

        if (origin.isNullOrBlank() || destination.isNullOrBlank()) {
            result.error("invalid_arguments", "Origin and destination are required.", null)
            return
        }

        val sanitizedWaypoints = waypoints.mapNotNull { it as? String }
        val url = GoogleMapsRouteHelper.buildRouteUrl(origin, sanitizedWaypoints, destination)
        result.success(url)
    }

    private fun handleOpenRoute(arguments: Any?, result: MethodChannel.Result) {
        val params = arguments as? Map<*, *>
        val origin = params?.get("origin") as? String
        val destination = params?.get("destination") as? String
        val waypoints = params?.get("waypoints") as? List<*> ?: emptyList<Any>()

        if (origin.isNullOrBlank() || destination.isNullOrBlank()) {
            result.error("invalid_arguments", "Origin and destination are required.", null)
            return
        }

        val sanitizedWaypoints = waypoints.mapNotNull { it as? String }
        val url = GoogleMapsRouteHelper.buildRouteUrl(origin, sanitizedWaypoints, destination)
        try {
            GoogleMapsRouteHelper.openGoogleMaps(this, url)
            result.success(url)
        } catch (error: Exception) {
            result.error("launch_error", error.message, null)
        }
    }
}
