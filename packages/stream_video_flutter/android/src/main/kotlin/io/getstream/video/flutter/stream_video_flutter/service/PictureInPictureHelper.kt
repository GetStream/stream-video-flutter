package io.getstream.video.flutter.stream_video_flutter.service

import android.app.Activity
import android.app.PictureInPictureParams
import android.content.pm.PackageManager
import android.content.res.Configuration
import android.graphics.Rect
import android.os.Build
import android.util.Log
import android.util.Rational
import android.app.PictureInPictureUiState
import androidx.annotation.RequiresApi
import java.lang.ref.WeakReference
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class PictureInPictureHelper {
    companion object {
        private const val TAG = "PictureInPictureHelper"
        private const val PIP_CHANNEL = "stream_video_flutter_android_pip"
        
        private var methodChannel: MethodChannel? = null
        private var getActivity: (() -> Activity?)? = null
        private var isPictureInPictureAllowed: Boolean = false

        // The aspect ratio of the video shown in picture-in-picture, or null
        // when it is unknown and the device's orientation is used instead.
        private var videoAspectRatio: Rational? = null

        // The activity the system enters picture-in-picture for by itself, on
        // Android 12 and above, when the user leaves it. Params belong to an
        // activity instance, so a recreated one has to be armed again.
        private var autoEnterArmedActivity: WeakReference<Activity>? = null

        // Android's default limits, outside of which it rejects an aspect
        // ratio. Some devices are configured with tighter ones.
        private val MIN_ASPECT_RATIO = Rational(100, 239)
        private val MAX_ASPECT_RATIO = Rational(239, 100)

        fun initializeWithFlutterEngine(engine: FlutterEngine, activityGetter: () -> Activity?) {
            methodChannel = MethodChannel(engine.dartExecutor.binaryMessenger, PIP_CHANNEL)
            getActivity = activityGetter
            methodChannel?.setMethodCallHandler { call, result ->
                handleMethodCall(call, result)
            }
            // A recreated activity starts without the params, so arm it again
            // if picture-in-picture was allowed for the one it replaces.
            activityGetter()?.let { updatePictureInPictureParams(it) }
        }

        private fun handleMethodCall(call: MethodCall, result: MethodChannel.Result) {
            when (call.method) {
                "setPictureInPictureAllowed" -> {
                    val isAllowed = call.arguments as Boolean
                    setPictureInPictureAllowed(isAllowed)
                    result.success(null)
                }
                "setPictureInPictureAspectRatio" -> {
                    val size = call.arguments as? Map<*, *>
                    val width = (size?.get("width") as? Number)?.toInt()
                    val height = (size?.get("height") as? Number)?.toInt()
                    setVideoAspectRatio(width, height)
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        private fun setPictureInPictureAllowed(isAllowed: Boolean) {
            isPictureInPictureAllowed = isAllowed
            val activity = getActivity?.invoke() ?: return

            if (isAllowed) {
                // Arms auto-enter.
                updatePictureInPictureParams(activity)
            } else {
                // If we're currently in PiP mode, exit it, and disarm.
                disablePictureInPicture(activity)
            }
        }

        private fun setVideoAspectRatio(width: Int?, height: Int?) {
            videoAspectRatio =
                if (width != null && height != null && width > 0 && height > 0) {
                    clampAspectRatio(Rational(width, height))
                } else {
                    null
                }

            // Reshape the window if it is already showing, and the one the
            // system will auto-enter with.
            getActivity?.invoke()?.let { updatePictureInPictureParams(it) }
        }

        /**
         * Hands the activity the current params, when they matter before it
         * enters picture-in-picture by itself, on Android 12 and above, or to
         * reshape the window while it is showing.
         */
        private fun updatePictureInPictureParams(
            activity: Activity,
            allowAutoEnter: Boolean = isPictureInPictureAllowed,
        ) {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
            val usesAutoEnter = Build.VERSION.SDK_INT >= Build.VERSION_CODES.S
            if (!usesAutoEnter && !activity.isInPictureInPictureMode) return

            val autoEnter = usesAutoEnter && allowAutoEnter &&
                canEnterPictureInPicture(activity)
            try {
                activity.setPictureInPictureParams(
                    buildPictureInPictureParams(activity, autoEnter = autoEnter)
                )
            } catch (e: IllegalArgumentException) {
                // The video's ratio is outside the device's limits, so use a
                // shape every device accepts instead.
                Log.w(TAG, "Video aspect ratio rejected, using the orientation's", e)
                if (!trySetPictureInPictureParams(
                        activity,
                        buildPictureInPictureParams(
                            activity,
                            autoEnter = autoEnter,
                            useVideoAspectRatio = false,
                        ),
                    )
                ) {
                    autoEnterArmedActivity = null
                    return
                }
            } catch (e: IllegalStateException) {
                // The activity doesn't support picture-in-picture, as its
                // manifest doesn't declare it.
                Log.w(TAG, "Failed to update picture-in-picture params", e)
                autoEnterArmedActivity = null
                return
            }
            autoEnterArmedActivity = if (autoEnter) WeakReference(activity) else null
        }

        @RequiresApi(Build.VERSION_CODES.O)
        private fun trySetPictureInPictureParams(
            activity: Activity,
            params: PictureInPictureParams,
        ): Boolean {
            return try {
                activity.setPictureInPictureParams(params)
                true
            } catch (e: RuntimeException) {
                Log.w(TAG, "Failed to update picture-in-picture params", e)
                false
            }
        }

        private fun clampAspectRatio(aspectRatio: Rational): Rational {
            return when {
                aspectRatio < MIN_ASPECT_RATIO -> MIN_ASPECT_RATIO
                aspectRatio > MAX_ASPECT_RATIO -> MAX_ASPECT_RATIO
                else -> aspectRatio
            }
        }

        fun disablePictureInPicture(activity: Activity) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                if (activity.isInPictureInPictureMode) {
                    activity.moveTaskToBack(true)
                }
            }
            // So the system doesn't enter it again by itself.
            updatePictureInPictureParams(activity, allowAutoEnter = false)
        }

        fun handlePipTrigger(activity: Activity) {
            // Check if already in PiP mode to avoid redundant calls
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N && activity.isInPictureInPictureMode) {
                return
            }

            // On Android 12 and above the system enters by itself, with a
            // smoother animation, when the user leaves the activity. Entering
            // here too would race it, and onPause also comes for dialogs and
            // permission prompts, which shouldn't enter at all.
            if (autoEnterArmedActivity?.get() === activity) return

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
                try {
                    activity.enterPictureInPictureMode(
                        buildPictureInPictureParams(activity, autoEnter = isPictureInPictureAllowed)
                    )
                } catch (e: IllegalArgumentException) {
                    // The video's ratio is outside the device's limits, so use
                    // a shape every device accepts instead.
                    Log.w(TAG, "Video aspect ratio rejected, using the orientation's", e)
                    activity.enterPictureInPictureMode(
                        buildPictureInPictureParams(
                            activity,
                            autoEnter = isPictureInPictureAllowed,
                            useVideoAspectRatio = false,
                        )
                    )
                }
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                activity.enterPictureInPictureMode()
            }
        }

        @RequiresApi(Build.VERSION_CODES.O)
        private fun buildPictureInPictureParams(
            activity: Activity,
            autoEnter: Boolean,
            useVideoAspectRatio: Boolean = true,
        ): PictureInPictureParams {
            val videoAspect = if (useVideoAspectRatio) videoAspectRatio else null
            val aspect = videoAspect ?: run {
                val currentOrientation = activity.resources.configuration.orientation
                if (currentOrientation == Configuration.ORIENTATION_PORTRAIT) {
                    Rational(9, 16)
                } else {
                    Rational(16, 9)
                }
            }

            val params = PictureInPictureParams.Builder()
            params.setAspectRatio(aspect).apply {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    setAutoEnterEnabled(autoEnter)
                }
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    setSeamlessResizeEnabled(true)
                }
            }
            return params.build()
        }

        private fun canEnterPictureInPicture(activity: Activity): Boolean {
            return activity.packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)
        }

        fun cleanup() {
            // The activity must not go on entering picture-in-picture for a
            // Flutter side that's gone. The allowed state is kept, so an engine
            // attached to a new activity arms it again.
            getActivity?.invoke()?.let {
                updatePictureInPictureParams(it, allowAutoEnter = false)
            }
            autoEnterArmedActivity = null
            methodChannel?.setMethodCallHandler(null)
            methodChannel = null
            getActivity = null
            videoAspectRatio = null
        }
    }
}