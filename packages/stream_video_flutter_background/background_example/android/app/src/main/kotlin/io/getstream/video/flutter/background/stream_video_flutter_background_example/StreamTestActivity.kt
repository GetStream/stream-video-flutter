package io.getstream.video.flutter.background.stream_video_flutter_background_example

import android.content.Context
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.getstream.log.taggedLogger
import io.getstream.video.flutter.background.stream_video_flutter_background.STREAM_FLUTTER_BACKGROUND_ENGINE_ID

private const val TAG = "StreamTestView"

class StreamTestActivity: FlutterActivity() {

    private val logger by taggedLogger(tag = TAG)

    override fun onCreate(savedInstanceState: Bundle?) {
        logger.i { "[onCreate] before super" }
        super.onCreate(savedInstanceState)
        logger.i { "[onCreate] after super" }
    }

    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        val engine = FlutterEngineCache.getInstance().get(STREAM_FLUTTER_BACKGROUND_ENGINE_ID)
        logger.i { "[provideFlutterEngine] engine: $engine" }
        return engine
    }

    override fun onDestroy() {
        logger.i { "[onDestroy] before super" }
        super.onDestroy()
        logger.i { "[onDestroy] after super" }
    }

}
