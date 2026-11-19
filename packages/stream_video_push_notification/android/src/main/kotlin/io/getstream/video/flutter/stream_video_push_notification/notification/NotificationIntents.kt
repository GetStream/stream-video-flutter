package io.getstream.video.flutter.stream_video_push_notification.notification

import android.app.PendingIntent
import android.content.Context
import android.os.Build
import android.os.Bundle
import io.getstream.video.flutter.stream_video_push_notification.AppUtils
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallActivity
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallBroadcastReceiver
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallConstants
import io.getstream.video.flutter.stream_video_push_notification.TransparentActivity

/**
 * The PendingIntents the call notifications carry, each with the call [Bundle] and the
 * notification id as its request code.
 */
internal object NotificationIntents {

    /** Accept: the trampoline activity with the accept action. */
    fun accept(context: Context, id: Int, data: Bundle): PendingIntent = PendingIntent.getActivity(
        context,
        id,
        TransparentActivity.getIntent(context, IncomingCallConstants.ACTION_CALL_ACCEPT, data),
        flags(),
    )

    /** Decline: a broadcast to the receiver. */
    fun decline(context: Context, id: Int, data: Bundle): PendingIntent =
        PendingIntent.getBroadcast(
            context,
            id,
            IncomingCallBroadcastReceiver.getIntentDecline(context, data),
            flags(),
        )

    /** Call back from the missed-call notification: the trampoline with the callback action. */
    fun callback(context: Context, id: Int, data: Bundle): PendingIntent =
        PendingIntent.getActivity(
            context,
            id,
            TransparentActivity.getIntent(context, IncomingCallConstants.ACTION_CALL_CALLBACK, data),
            flags(),
        )

    /** The full-screen incoming call activity. */
    fun fullScreen(context: Context, id: Int, data: Bundle): PendingIntent =
        PendingIntent.getActivity(context, id, IncomingCallActivity.getIntent(context, data), flags())

    /** The app's launch activity, with the call attached. */
    fun app(context: Context, id: Int, data: Bundle): PendingIntent =
        PendingIntent.getActivity(context, id, AppUtils.getAppIntent(context, data = data), flags())

    private fun flags(): Int = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
    } else {
        PendingIntent.FLAG_UPDATE_CURRENT
    }
}
