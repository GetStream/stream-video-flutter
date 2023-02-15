package io.getstream.video.flutter.background.stream_video_flutter_background_example

import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity

private const val TAG = "StreamTestView"

class StreamTestActivity: FlutterActivity() {


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.i(TAG, "[onCreate] no args")
    }


    override fun onDestroy() {
        super.onDestroy()
        Log.i(TAG, "[onDestroy] no args")
    }

}
