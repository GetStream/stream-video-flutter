package io.getstream.video.flutter.stream_video_flutter.service

import android.app.Activity
import android.app.PictureInPictureParams
import android.content.pm.ActivityInfo
import android.content.pm.PackageManager
import android.graphics.Rect
import android.os.Build
import android.util.Log
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
        private var isPictureInPictureAllowed: Boolean = false

        fun initializeWithFlutterEngine(engine: FlutterEngine, activityGetter: () -> Activity?) {
            methodChannel = MethodChannel(engine.dartExecutor.binaryMessenger, PIP_CHANNEL)
            getActivity = activityGetter
            methodChannel?.setMethodCallHandler { call, result ->
                handleMethodCall(call, result)
            }
        }

        private fun handleMethodCall(call: MethodCall, result: MethodChannel.Result) {
            when (call.method) {
                "setPictureInPictureAllowed" -> {
                    val isAllowed = call.arguments as Boolean
                    setPictureInPictureAllowed(isAllowed)
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        private fun setPictureInPictureAllowed(isAllowed: Boolean) {
            isPictureInPictureAllowed = isAllowed
            
            // If PiP is being disabled and we're currently in PiP mode, exit it
            if (!isAllowed) {
                val activity = getActivity?.invoke()
                if (activity != null) {
                    disablePictureInPicture(activity)
                }
            }
        }

        fun disablePictureInPicture(activity: Activity) {
             if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                if (activity.isInPictureInPictureMode) {
                    activity.moveTaskToBack(true) 

                    // setAutoEnterEnabled is only available on Android 12 (API 31) and above
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        val params = PictureInPictureParams.Builder()
                        params.setAutoEnterEnabled(false)
                        activity.setPictureInPictureParams(params.build())
                    }
                }
            }
        }

        fun handlePipTrigger(activity: Activity) {
            // Check if already in PiP mode to avoid redundant calls
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N && activity.isInPictureInPictureMode) {
                return
            }

            if (isPictureInPictureAllowed && canEnterPictureInPicture(activity)) {
                enterPictureInPictureMode(activity)
            }
        }

        fun notifyPictureInPictureModeChanged(activity: Activity, isInPictureInPictureMode: Boolean) {
            activity.runOnUiThread {
                methodChannel?.invokeMethod("onPictureInPictureModeChanged", isInPictureInPictureMode)
            }
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

        fun cleanup() {
            methodChannel?.setMethodCallHandler(null)
            methodChannel = null
            getActivity = null
        }
    }
}