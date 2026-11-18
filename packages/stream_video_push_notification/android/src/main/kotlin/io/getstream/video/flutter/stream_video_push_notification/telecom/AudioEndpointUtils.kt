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

    /** The `CallEndpointCompat.TYPE_*` of a wire name, or null for one that names no type. */
    fun endpointTypeFromString(name: String?): Int? = when (name) {
        TYPE_EARPIECE -> CallEndpointCompat.TYPE_EARPIECE
        TYPE_SPEAKER -> CallEndpointCompat.TYPE_SPEAKER
        TYPE_WIRED_HEADSET -> CallEndpointCompat.TYPE_WIRED_HEADSET
        TYPE_BLUETOOTH -> CallEndpointCompat.TYPE_BLUETOOTH
        else -> null
    }

    /** What to do to route a call to an endpoint of a type; see [chooseEndpoint]. */
    sealed interface EndpointChoice {
        /** The call already uses an endpoint of the type. */
        object AlreadyCurrent : EndpointChoice

        /** Ask Telecom for [endpoint]. */
        data class Request(val endpoint: CallEndpointCompat) : EndpointChoice

        /** Telecom offers no endpoint of the type. */
        object Unavailable : EndpointChoice
    }

    /**
     * Which of [available] to ask Telecom for to route a call to [type], given its [current]
     * endpoint. Telecom lists one Bluetooth endpoint per connected headset, so the one named
     * [name] wins; without one, the first of the type. [current] is kept when it is of the type
     * and is the named endpoint, or none is named.
     */
    fun chooseEndpoint(
        type: Int,
        current: CallEndpointCompat?,
        available: List<CallEndpointCompat>,
        name: String? = null,
    ): EndpointChoice {
        val ofType = available.filter { it.type == type }
        val named = name?.let { wanted -> ofType.firstOrNull { it.name.toString() == wanted } }
        if (current?.type == type && (named == null || current.identifier == named.identifier)) {
            return EndpointChoice.AlreadyCurrent
        }
        val endpoint = named ?: ofType.firstOrNull() ?: return EndpointChoice.Unavailable
        return EndpointChoice.Request(endpoint)
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
