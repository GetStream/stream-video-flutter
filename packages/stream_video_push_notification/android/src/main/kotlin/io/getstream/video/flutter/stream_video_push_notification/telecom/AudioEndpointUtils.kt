package io.getstream.video.flutter.stream_video_push_notification.telecom

import androidx.core.telecom.CallEndpointCompat

/**
 * Serialization helpers for Telecom [CallEndpointCompat] values crossing the platform channel.
 */
internal object AudioEndpointUtils {

    const val TYPE_EARPIECE = "earpiece"
    const val TYPE_SPEAKER = "speaker"
    const val TYPE_WIRED_HEADSET = "wired_headset"
    const val TYPE_BLUETOOTH = "bluetooth"
    const val TYPE_UNKNOWN = "unknown"

    fun endpointTypeToString(type: Int): String = when (type) {
        CallEndpointCompat.TYPE_EARPIECE -> TYPE_EARPIECE
        CallEndpointCompat.TYPE_SPEAKER -> TYPE_SPEAKER
        CallEndpointCompat.TYPE_WIRED_HEADSET -> TYPE_WIRED_HEADSET
        CallEndpointCompat.TYPE_BLUETOOTH -> TYPE_BLUETOOTH
        else -> TYPE_UNKNOWN
    }

    fun toMap(endpoint: CallEndpointCompat): Map<String, Any?> = mapOf(
        "id" to endpoint.identifier.toString(),
        "name" to endpoint.name.toString(),
        "type" to endpointTypeToString(endpoint.type),
    )

    fun snapshot(
        current: CallEndpointCompat?,
        available: List<CallEndpointCompat>,
    ): Map<String, Any?> = mapOf(
        "currentEndpoint" to current?.let { toMap(it) },
        "endpoints" to available.map { toMap(it) },
    )
}
