package io.getstream.video.flutter.stream_video_push_notification

object IncomingCallConstants {
    const val ACTION_CALL_INCOMING =
        "io.getstream.video.ACTION_CALL_INCOMING"
    const val ACTION_CALL_START = "io.getstream.video.ACTION_CALL_START"
    const val ACTION_CALL_ACCEPT =
        "io.getstream.video.ACTION_CALL_ACCEPT"
    const val ACTION_CALL_DECLINE =
        "io.getstream.video.ACTION_CALL_DECLINE"
    const val ACTION_CALL_ENDED =
        "io.getstream.video.ACTION_CALL_ENDED"
    const val ACTION_CALL_TOGGLE_MUTE =
        "io.getstream.video.ACTION_CALL_TOGGLE_MUTE"
    const val ACTION_CALL_TOGGLE_HOLD =
        "io.getstream.video.ACTION_CALL_TOGGLE_HOLD"
    const val ACTION_CALL_TIMEOUT =
        "io.getstream.video.ACTION_CALL_TIMEOUT"
    const val ACTION_CALL_CALLBACK =
        "io.getstream.video.ACTION_CALL_CALLBACK"
    const val ACTION_CALL_CUSTOM =
        "io.getstream.video.ACTION_CALL_CUSTOM"
    const val ACTION_CALL_CONNECTED = "io.getstream.video.ACTION_CALL_CONNECTED"

    /**
     * The ring of a call ended because the SDK dismissed it, with a reason: accepted in the app,
     * cancelled by the caller, answered on another device, or missed.
     */
    const val ACTION_CALL_DISMISSED = "io.getstream.video.ACTION_CALL_DISMISSED"

    /** Internal action that runs [IncomingCallNotificationService] as a foreground service while ringing. */
    const val ACTION_CALL_RINGING = "io.getstream.video.ACTION_CALL_RINGING"

    // Polyfill for a Build.VERSION_CODES value not yet available at the current compileSdk.
    // TODO: delete once compileSdk covers it, replacing usages with the real constant.
    const val SDK_INT_CINNAMON_BUN = 37 // Build.VERSION_CODES.CINNAMON_BUN - needs compileSdk 37


    const val EXTRA_CALL_INCOMING_DATA = "EXTRA_CALL_INCOMING_DATA"

    const val EXTRA_CALL_ID = "EXTRA_CALL_ID"
    const val EXTRA_CALL_NAME_CALLER = "EXTRA_CALL_NAME_CALLER"
    const val EXTRA_CALL_HANDLE = "EXTRA_CALL_HANDLE"
    const val EXTRA_CALL_TYPE = "EXTRA_CALL_TYPE"
    const val EXTRA_CALL_AVATAR = "EXTRA_CALL_AVATAR"
    const val EXTRA_CALL_DEFAULT_AVATAR = "EXTRA_CALL_DEFAULT_AVATAR"
    const val EXTRA_CALL_DURATION = "EXTRA_CALL_DURATION"
    const val EXTRA_CALL_TEXT_ACCEPT = "EXTRA_CALL_TEXT_ACCEPT"
    const val EXTRA_CALL_TEXT_DECLINE = "EXTRA_CALL_TEXT_DECLINE"

    const val EXTRA_CALL_MISSED_CALL_ID = "EXTRA_CALL_MISSED_CALL_ID"
    const val EXTRA_CALL_MISSED_CALL_SHOW = "EXTRA_CALL_MISSED_CALL_SHOW"
    const val EXTRA_CALL_MISSED_CALL_COUNT = "EXTRA_CALL_MISSED_CALL_COUNT"
    const val EXTRA_CALL_MISSED_CALL_SUBTITLE = "EXTRA_CALL_MISSED_CALL_SUBTITLE"
    const val EXTRA_CALL_MISSED_CALL_CALLBACK_SHOW = "EXTRA_CALL_MISSED_CALL_CALLBACK_SHOW"
    const val EXTRA_CALL_MISSED_CALL_CALLBACK_TEXT =
        "EXTRA_CALL_MISSED_CALL_CALLBACK_TEXT"

    const val EXTRA_CALL_EXTRA = "EXTRA_CALL_EXTRA"
    const val EXTRA_CALL_HEADERS = "EXTRA_CALL_HEADERS"
    const val EXTRA_CALL_SHOW_CALL_HANDLE = "EXTRA_CALL_SHOW_CALL_HANDLE"
    const val EXTRA_CALL_RINGTONE_PATH = "EXTRA_CALL_RINGTONE_PATH"
    
    const val EXTRA_CALL_FULL_SCREEN_SHOW_LOGO = "EXTRA_CALL_FULL_SCREEN_SHOW_LOGO"
    const val EXTRA_CALL_FULL_SCREEN_LOGO_URL = "EXTRA_CALL_FULL_SCREEN_LOGO_URL"
    const val EXTRA_CALL_FULL_SCREEN_BACKGROUND_COLOR = "EXTRA_CALL_FULL_SCREEN_BACKGROUND_COLOR"
    const val EXTRA_CALL_FULL_SCREEN_BACKGROUND_URL = "EXTRA_CALL_FULL_SCREEN_BACKGROUND_URL"
    const val EXTRA_CALL_FULL_SCREEN_TEXT_COLOR = "EXTRA_CALL_FULL_SCREEN_TEXT_COLOR"
    
    const val EXTRA_CALL_INCOMING_CALL_NOTIFICATION_CHANNEL_NAME =
        "EXTRA_CALL_INCOMING_CALL_NOTIFICATION_CHANNEL_NAME"
    const val EXTRA_CALL_MISSED_CALL_NOTIFICATION_CHANNEL_NAME =
        "EXTRA_CALL_MISSED_CALL_NOTIFICATION_CHANNEL_NAME"

    const val EXTRA_CALL_ACTION_FROM = "EXTRA_CALL_ACTION_FROM"

    /**
     * Marks an ended broadcast as reported by the platform call UI rather than by a dismissed
     * notification, e.g. a hang-up from a paired watch, a headset or a car head unit.
     *
     * Forwarded to Dart as `endedBySystem`, which is what tells the ringing flow that the end is
     * authoritative and the call has to be left.
     */
    const val EXTRA_CALL_ENDED_BY_SYSTEM = "EXTRA_CALL_ENDED_BY_SYSTEM"

    const val EXTRA_CALL_IS_SHOW_FULL_LOCKED_SCREEN = "EXTRA_CALL_IS_SHOW_FULL_LOCKED_SCREEN"
    const val EXTRA_CALL_IS_IMPORTANT = "EXTRA_CALL_IS_IMPORTANT"
    const val EXTRA_CALL_IS_BOT = "EXTRA_CALL_IS_BOT"
}
