package io.getstream.video.flutter.stream_video_flutter

import android.content.res.Configuration
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.getstream.video.flutter.stream_video_flutter.service.PictureInPictureHelper

/**
 * A base FlutterActivity that automatically handles Picture-in-Picture setup.
 * 
 * Extend this class instead of FlutterActivity to get automatic PiP support:
 * 
 * ```kotlin
 * class MainActivity : StreamFlutterActivity() {
 *     // Your activity code here
 * }
 * ```
 */
abstract class StreamFlutterActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Initialize PictureInPictureHelper with Flutter engine
        PictureInPictureHelper.initializeWithFlutterEngine(flutterEngine) { this }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)
        PictureInPictureHelper.cleanup()
    }

    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        // Trigger PiP when user leaves the app (e.g., presses home button)
        PictureInPictureHelper.handlePipTrigger(this)
    }

    override fun onPause() {
        super.onPause()
        // Trigger PiP when app is backgrounded (but not finishing)
        if (!isFinishing) {
            PictureInPictureHelper.handlePipTrigger(this)
        }
    }

    override fun onPictureInPictureModeChanged(
        isInPictureInPictureMode: Boolean,
        newConfig: Configuration
    ) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
        // Notify Flutter about PiP mode changes
        PictureInPictureHelper.notifyPictureInPictureModeChanged(this, isInPictureInPictureMode)
    }
} 