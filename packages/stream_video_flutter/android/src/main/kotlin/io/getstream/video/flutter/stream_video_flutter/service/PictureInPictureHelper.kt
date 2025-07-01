package io.getstream.video.flutter.stream_video_flutter.service

import android.app.Activity
import android.app.PictureInPictureParams
import android.content.pm.ActivityInfo
import android.content.pm.PackageManager
import android.graphics.Rect
import android.os.Build
import android.util.Rational
import android.app.PictureInPictureUiState
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class PictureInPictureHelper {
    companion object {
        private const val PIP_CHANNEL = "stream_video_flutter_android_pip"
        
        private var methodChannel: MethodChannel? = null
        private var getActivity: (() -> Activity?)? = null

        fun initializeWithFlutterEngine(engine: FlutterEngine, activityGetter: () -> Activity?) {
            methodChannel = MethodChannel(engine.dartExecutor.binaryMessenger, PIP_CHANNEL)
            getActivity = activityGetter
            methodChannel?.setMethodCallHandler { call, result ->
                handleMethodCall(call, result)
            }
        }

        private fun handleMethodCall(call: MethodCall, result: MethodChannel.Result) {
            when (call.method) {
                "disablePictureInPictureMode" -> {
                    val activity = getActivity?.invoke()
                    if (activity != null) {
                        disablePictureInPicture(activity)
                        result.success(null)
                    } else {
                        result.error("NO_ACTIVITY", "No activity available", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        fun disablePictureInPicture(activity: Activity) {
             if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                if (activity.isInPictureInPictureMode) {
                    activity.moveTaskToBack(true) 

                    val params = PictureInPictureParams.Builder()
                    params.setAutoEnterEnabled(false)
                    activity.setPictureInPictureParams(params.build())
                }
            }
        }

        fun handlePipTrigger(activity: Activity) {
            // Check if already in PiP mode to avoid redundant calls
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N && activity.isInPictureInPictureMode) {
                return
            }

            // Directly enter PiP mode - Flutter will handle overlay via onPictureInPictureModeChanged
            if (canEnterPictureInPicture(activity)) {
                enterPictureInPictureMode(activity)
            }
        }

        fun notifyPictureInPictureModeChanged(activity: Activity, isInPictureInPictureMode: Boolean) {
            // Notify Android PiP specific channel
            methodChannel?.invokeMethod("onPictureInPictureModeChanged", isInPictureInPictureMode)
        }

        fun enterPictureInPictureMode(activity: Activity) {
            if (!canEnterPictureInPicture(activity)) return

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val currentOrientation = activity.resources.configuration.orientation

                val aspect = if (currentOrientation == ActivityInfo.SCREEN_ORIENTATION_PORTRAIT) {
                    Rational(9, 16)
                } else {
                    Rational(16, 9)
                }

                val params = PictureInPictureParams.Builder()
                params.setAspectRatio(aspect).apply {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                        setSeamlessResizeEnabled(true)
                    }
                }

                activity.enterPictureInPictureMode(params.build())
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                activity.enterPictureInPictureMode()
            }
        }

        private fun canEnterPictureInPicture(activity: Activity): Boolean {
            return activity.packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)
        }

        /**
         * @deprecated This method is deprecated. PiP is now handled automatically by 
         * StreamPictureInPictureAndroidView when using PictureInPictureConfiguration.
         */
        @Deprecated("Use PictureInPictureConfiguration in StreamCallContent instead")
        fun enterPictureInPictureIfInCall(activity: Activity) {
            // For backwards compatibility, delegate to the new handlePipTrigger method
            // This maintains the same behavior but uses the new automatic PiP system
            handlePipTrigger(activity)
        }
    }
}