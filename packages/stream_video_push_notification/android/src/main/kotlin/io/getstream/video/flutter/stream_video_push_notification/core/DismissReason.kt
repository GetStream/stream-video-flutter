package io.getstream.video.flutter.stream_video_push_notification.core

/**
 * Why the SDK dismissed the ring of a call: accepted in the app, or ended elsewhere than on this
 * device's ringing UI.
 */
internal enum class DismissReason(val wireName: String) {
    /** The user accepted the call in the app, outside the ringing UI. */
    ACCEPTED("accepted"),

    /** The caller cancelled the call. */
    REMOTE_CANCELLED("remoteCancelled"),

    /** The user answered the call on another device. */
    ANSWERED_ELSEWHERE("answeredElsewhere"),

    /** The call rang out unanswered. */
    MISSED("missed"),
    ;

    companion object {
        /** The reason with [wireName], or [ACCEPTED] for a missing or unknown one. */
        fun fromWireName(wireName: String?): DismissReason =
            entries.firstOrNull { it.wireName == wireName } ?: ACCEPTED
    }
}
