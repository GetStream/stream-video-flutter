package io.getstream.video.flutter.stream_video_push_notification.core

/**
 * One call the plugin rings, shows or tracks.
 *
 * The defaults are the values a call gets for anything the Dart side, a Bundle or the stored
 * active-calls list leaves out. [CallPayloadMapper] is the only place that converts it to and
 * from those formats.
 */
internal data class RingingCall(
    val id: String = "",
    val callerName: String = "",
    val handle: String = "",
    /** 0 for an audio call, 1 for a video call. */
    val type: Int = 0,
    /** How long the call rings, in milliseconds. */
    val duration: Long = 30_000L,
    val extra: Map<String, Any?> = emptyMap(),
    /** HTTP headers sent with the avatar requests. */
    val headers: Map<String, Any?> = emptyMap(),
    val avatar: String = "",
    val defaultAvatar: String = "",
    val ringtonePath: String = "",
    /** Where the call came from; `notification` for a call Dart asked the plugin to show. */
    val from: String = "",
    val textAccept: String = "",
    val textDecline: String = "",
    val showCallHandle: Boolean = false,
    val fullScreenShowLogo: Boolean = false,
    val fullScreenLogoUrl: String = "",
    /** Empty for the plugin's own colour resource, which an app can override. */
    val fullScreenBackgroundColor: String = "",
    val fullScreenBackgroundUrl: String = "",
    val fullScreenTextColor: String = "",
    val showFullScreenOnLockScreen: Boolean = true,
    val incomingCallNotificationChannelName: String? = null,
    val missedCallNotificationChannelName: String? = null,
    /** Null to derive the missed-call notification id from [id]. */
    val missedNotificationId: Int? = null,
    val showMissedCallNotification: Boolean = true,
    val missedNotificationCount: Int = 1,
    val missedNotificationSubtitle: String? = null,
    val missedNotificationCallbackText: String? = null,
    val showCallbackButton: Boolean = true,
    val isImportant: Boolean = false,
    val isBot: Boolean = false,
    val isAccepted: Boolean = false,
) {
    /** The Stream call cid carried in [extra], if any. */
    val callCid: String? get() = extra["callCid"] as? String
}
