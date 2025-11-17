package com.shareroute.shareroute_mobile

import android.content.Context
import android.content.Intent
import android.net.Uri
import java.text.Normalizer

object GoogleMapsRouteHelper {
    private const val BASE_URL = "https://www.google.com/maps/dir/?api=1"

    fun buildRouteUrl(origin: String, waypoints: List<String>, destination: String): String {
        val sanitizedOrigin = sanitizeAddress(origin)
        val sanitizedDestination = sanitizeAddress(destination)
        if (sanitizedOrigin.isEmpty() || sanitizedDestination.isEmpty()) {
            throw IllegalArgumentException("Origin and destination must not be empty")
        }

        val sanitizedWaypoints = waypoints
            .map { sanitizeAddress(it) }
            .filter { it.isNotEmpty() }

        val builder = StringBuilder(BASE_URL)
            .append("&origin=").append(sanitizedOrigin)
            .append("&destination=").append(sanitizedDestination)

        if (sanitizedWaypoints.isNotEmpty()) {
            builder.append("&waypoints=optimize:true|")
                .append(sanitizedWaypoints.joinToString("|"))
        }

        builder.append("&travelmode=driving")
        return builder.toString()
    }

    fun openGoogleMaps(context: Context, url: String) {
        val uri = Uri.parse(url)
        val mapsIntent = Intent(Intent.ACTION_VIEW, uri).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            setPackage("com.google.android.apps.maps")
        }

        val packageManager = context.packageManager
        if (mapsIntent.resolveActivity(packageManager) == null) {
            mapsIntent.setPackage(null)
        }

        try {
            context.startActivity(mapsIntent)
        } catch (error: Exception) {
            val fallbackIntent = Intent(Intent.ACTION_VIEW, uri).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            context.startActivity(fallbackIntent)
        }
    }

    private fun sanitizeAddress(raw: String): String {
        val normalized = Normalizer.normalize(raw.trim(), Normalizer.Form.NFD)
            .replace("\\p{InCombiningDiacriticalMarks}+".toRegex(), "")
        val cleaned = normalized.replace("[^a-zA-Z0-9.,\\- ]+".toRegex(), " ")
        return cleaned.trim().replace("\\s+".toRegex(), "+")
    }
}
