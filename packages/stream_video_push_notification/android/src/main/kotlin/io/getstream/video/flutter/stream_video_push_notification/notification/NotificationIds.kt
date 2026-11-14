package io.getstream.video.flutter.stream_video_push_notification.notification

import android.os.Bundle
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallConstants

/** The notification ids of a call, read from its Bundle. */
internal object NotificationIds {

    private const val FALLBACK_CALL_ID = "stream_video_call"

    /** The hash of the call id, or of `stream_video_call` without one. */
    fun incoming(data: Bundle): Int =
        data.getString(IncomingCallConstants.EXTRA_CALL_ID, FALLBACK_CALL_ID).hashCode()

    /**
     * The missed-call notification id the call carries, or the hash of `missing_` and the call
     * id when it carries none.
     */
    fun missed(data: Bundle): Int =
        if (data.containsKey(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_ID)) {
            data.getInt(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_ID)
        } else {
            "missing_${data.getString(IncomingCallConstants.EXTRA_CALL_ID, FALLBACK_CALL_ID)}"
                .hashCode()
        }
}
