package io.getstream.video.flutter.stream_video_push_notification.core

/** Why the ring of a call ends without the user answering or declining it on this device. */
internal enum class DismissReason(val wireName: String) {
    /** The user accepted the call, in the app or on another surface of this device. */
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
