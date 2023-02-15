package io.getstream.video.flutter.background.stream_video_flutter_background

import android.content.Context
import android.content.Intent
import android.os.Build
import io.getstream.video.flutter.background.stream_video_flutter_background.service.StreamCallService

class ServiceManager {

    /**
     * Start the foreground service.
     *
     * @param context context
     * @param arguments arguments
     */
    fun start(context: Context, arguments: Any?): Boolean {
        try {
            val nIntent = Intent(context, StreamCallService::class.java)
            val argsMap = arguments as? Map<*, *>

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(nIntent)
            } else {
                context.startService(nIntent)
            }
        } catch (e: Exception) {
            return false
        }

        return true
    }

}