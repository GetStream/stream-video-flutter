package io.getstream.video.flutter.stream_video_push_notification.telecom

import android.net.Uri

/** The calls this app has registered with the Android Telecom stack. */
internal interface TelecomCallRepository {

    /** Registers the app with Telecom now rather than on the first call. */
    fun warmUp()

    /** Sets who hears about the calls' Telecom transitions. */
    fun setListener(listener: TelecomCallListener?)

    fun getCall(callId: String): TelecomCall.Registered?

    /** The ids of the calls registered now, pending ones included. */
    fun callIds(): Set<String>

    fun hasAnyCalls(): Boolean

    /** Disconnects every call and stops reporting. The repository is not used afterwards. */
    fun release()

    /**
     * Registers a call with Telecom and keeps the call scope alive until the call is disconnected.
     *
     * Suspends for the whole lifetime of the call, so callers must launch it on their own scope.
     */
    suspend fun registerCall(
        callId: String,
        displayName: String,
        address: Uri,
        isIncoming: Boolean,
        isVideo: Boolean,
    )
}
