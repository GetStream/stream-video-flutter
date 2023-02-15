package io.getstream.video.flutter.background.stream_video_flutter_background_example

import android.app.Application
import android.util.Log

private const val TAG = "StreamTestApp"

class StreamTestApp : Application() {

    override fun onCreate() {
        super.onCreate()
        Log.i(TAG, "[onCreate] no args")
    }

}