package io.getstream.video.flutter.stream_video_flutter.service

import android.app.Activity
import android.app.PictureInPictureParams
import android.content.pm.PackageManager
import android.content.res.Configuration
import android.graphics.Rect
import android.os.Build
import android.util.Log
import android.util.Rational
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.lang.ref.WeakReference
import kotlin.math.roundToInt

class PictureInPictureHelper {
    companion object {
        private const val TAG = "PictureInPictureHelper"
        private const val PIP_CHANNEL = "stream_video_flutter_android_pip"

        private var methodChannel: MethodChannel? = null
        private var getActivity: (() -> Activity?)? = null
        private var isPictureInPictureAllowed: Boolean = false

        // The engine whose Flutter side allowed picture-in-picture. A cached
        // engine attached to a new activity keeps it; a new engine, whose
        // Flutter side has said nothing yet, starts without it.
        private var allowingEngine: WeakReference<FlutterEngine>? = null
        private var currentEngine: WeakReference<FlutterEngine>? = null

        // Set once the activity has refused the params, as one whose manifest
        // doesn't declare picture-in-picture does, so it isn't asked again.
        private var isPictureInPictureUnsupported: Boolean = false

        // Whether the activity last accepted params with auto-enter on. Only
        // then does the system enter picture-in-picture by itself, so only
        // then is entering it here left out.
        private var isAutoEnterArmed: Boolean = false

        // The system's message when the activity's manifest doesn't declare
        // picture-in-picture. Android throws IllegalStateException for passing
        // reasons too, such as an activity that isn't resumed yet.
        private const val UNSUPPORTED_MESSAGE = "does not support picture-in-picture"

        // The aspect ratio of the video shown in picture-in-picture, or null
        // when it is unknown and the device's orientation is used instead.
        private var videoAspectRatio: Rational? = null

        // Where the video picture-in-picture will show is drawn, in the
        // window's pixels, or null when it isn't on screen. The window
        // animates in from it; without it Android covers the window with the
        // app's icon until the app draws again.
        private var sourceContentRect: Rect? = null

        // Android's default limits, outside of which it rejects an aspect
        // ratio. Some devices are configured with tighter ones.
        private val MIN_ASPECT_RATIO = Rational(100, 239)
        private val MAX_ASPECT_RATIO = Rational(239, 100)

        // On Android 12 and above the system enters picture-in-picture by
        // itself, with a smoother animation, while it is allowed.
        private val usesAutoEnter = Build.VERSION.SDK_INT >= Build.VERSION_CODES.S

        fun initializeWithFlutterEngine(engine: FlutterEngine, activityGetter: () -> Activity?) {
            methodChannel = MethodChannel(engine.dartExecutor.binaryMessenger, PIP_CHANNEL)
            getActivity = activityGetter
            currentEngine = WeakReference(engine)
            isPictureInPictureUnsupported = false
            // A new activity starts without the params of the one before.
            isAutoEnterArmed = false
            methodChannel?.setMethodCallHandler { call, result ->
                handleMethodCall(call, result)
            }
            // Allowed by the Flutter side of another engine, which is gone.
            if (allowingEngine?.get() !== engine) {
                isPictureInPictureAllowed = false
                allowingEngine = null
            }
            // A recreated activity starts without the params, so arm it again
            // if picture-in-picture was allowed for the one it replaces.
            if (isPictureInPictureAllowed) activityGetter()?.let { applyParams(it) }
            // The params went with the activity this engine was attached to
            // before, if any, so the Flutter side is asked to send them again.
            methodChannel?.invokeMethod("onPictureInPictureHandlerAttached", null)
        }

        private fun handleMethodCall(call: MethodCall, result: MethodChannel.Result) {
            when (call.method) {
                "setPictureInPictureAllowed" -> {
                    setPictureInPictureAllowed(call.arguments as Boolean)
                    result.success(null)
                }
                "setPictureInPictureParams" -> {
                    val params = call.arguments as? Map<*, *>
                    fun int(key: String) = (params?.get(key) as? Number)?.toInt()
                    setParams(
                        aspect = aspectRatioOf(int("width"), int("height")),
                        content = rectOf(int("left"), int("top"), int("right"), int("bottom")),
                    )
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        private fun aspectRatioOf(width: Int?, height: Int?): Rational? {
            if (width == null || height == null || width <= 0 || height <= 0) return null
            val aspect = Rational(width, height)
            return when {
                aspect < MIN_ASPECT_RATIO -> MIN_ASPECT_RATIO
                aspect > MAX_ASPECT_RATIO -> MAX_ASPECT_RATIO
                else -> aspect
            }
        }

        private fun rectOf(left: Int?, top: Int?, right: Int?, bottom: Int?): Rect? {
            if (left == null || top == null || right == null || bottom == null) return null
            return Rect(left, top, right, bottom).takeUnless { it.isEmpty }
        }

        private fun setPictureInPictureAllowed(isAllowed: Boolean) {
            isPictureInPictureAllowed = isAllowed
            allowingEngine = if (isAllowed) currentEngine else null
            val activity = getActivity?.invoke() ?: return

            if (isAllowed) {
                // Arms auto-enter.
                applyParams(activity)
            } else {
                // If we're currently in PiP mode, exit it, and disarm.
                disablePictureInPicture(activity)
            }
        }

        private fun setParams(aspect: Rational?, content: Rect?) {
            val activity = getActivity?.invoke()
            val isInPictureInPicture = activity != null && isInPictureInPicture(activity)

            videoAspectRatio = aspect
            // Measured inside the small window; the area from before matches
            // the full-size layout the window returns to.
            if (!isInPictureInPicture) sourceContentRect = content

            // The window takes them while it is showing, and the system the
            // ones it auto-enters with while that is allowed. Otherwise they
            // are kept for when it is.
            if (activity != null &&
                (isInPictureInPicture || (usesAutoEnter && isPictureInPictureAllowed))
            ) {
                applyParams(activity)
            }
        }

        private fun isInPictureInPicture(activity: Activity): Boolean {
            return Build.VERSION.SDK_INT >= Build.VERSION_CODES.N &&
                activity.isInPictureInPictureMode
        }

        /**
         * Hands the activity the current params, arming auto-enter if
         * picture-in-picture is allowed and [allowAutoEnter], disarming it
         * otherwise.
         */
        private fun applyParams(
            activity: Activity,
            allowAutoEnter: Boolean = isPictureInPictureAllowed,
        ) {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
            if (isPictureInPictureUnsupported || !canEnterPictureInPicture(activity)) return

            val autoEnter = usesAutoEnter && allowAutoEnter
            val applied = withUnsupportedHandled {
                withAspectRatioFallback(activity, autoEnter) {
                    activity.setPictureInPictureParams(it)
                }
            }
            // Rejected params leave the activity with whatever it had, so it
            // is taken as unarmed, and entering is left to handlePipTrigger.
            isAutoEnterArmed = applied && autoEnter
        }

        /**
         * Runs [block], which is called from lifecycle callbacks as well as
         * from Flutter, so nothing it throws may reach the activity. Returns
         * whether it ran to the end.
         */
        private fun withUnsupportedHandled(block: () -> Unit): Boolean {
            return try {
                block()
                true
            } catch (e: IllegalStateException) {
                if (e.message?.contains(UNSUPPORTED_MESSAGE) == true) {
                    // The activity's manifest doesn't declare
                    // picture-in-picture, so it isn't asked again.
                    Log.w(TAG, "Picture-in-picture is not supported by the activity", e)
                    isPictureInPictureUnsupported = true
                } else {
                    // Passing, such as an activity that isn't resumed, so the
                    // next attempt may well work.
                    Log.w(TAG, "Picture-in-picture refused for now", e)
                }
                false
            } catch (e: IllegalArgumentException) {
                // Even the orientation's aspect ratio was rejected.
                Log.w(TAG, "Picture-in-picture params rejected", e)
                false
            }
        }

        /**
         * Calls [apply] with the params built from the video's aspect ratio,
         * and, if the device rejects that ratio, again with the device's
         * orientation's, which every device accepts.
         */
        @RequiresApi(Build.VERSION_CODES.O)
        private fun withAspectRatioFallback(
            activity: Activity,
            autoEnter: Boolean,
            apply: (PictureInPictureParams) -> Unit,
        ) {
            try {
                apply(buildPictureInPictureParams(activity, autoEnter))
            } catch (e: IllegalArgumentException) {
                Log.w(TAG, "Video aspect ratio rejected, using the orientation's", e)
                apply(buildPictureInPictureParams(activity, autoEnter, useVideoAspectRatio = false))
            }
        }

        fun disablePictureInPicture(activity: Activity) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                if (activity.isInPictureInPictureMode) {
                    activity.moveTaskToBack(true)
                }
            }
            // So the system doesn't enter it again by itself.
            if (usesAutoEnter) applyParams(activity, allowAutoEnter = false)
        }

        fun handlePipTrigger(activity: Activity) {
            // Check if already in PiP mode to avoid redundant calls
            if (isInPictureInPicture(activity)) return
            if (!isPictureInPictureAllowed || !canEnterPictureInPicture(activity)) return
            // Entering would throw as the params did.
            if (isPictureInPictureUnsupported) return

            // The system enters by itself there, when the user leaves the
            // activity. Entering here too would race it, and onPause also comes
            // for dialogs and permission prompts, which shouldn't enter at all.
            // Only while the activity took the params that arm it, though:
            // otherwise nothing would enter at all.
            if (isAutoEnterArmed) return

            enterPictureInPictureMode(activity)
        }

        fun notifyPictureInPictureModeChanged(activity: Activity, isInPictureInPictureMode: Boolean) {
            activity.runOnUiThread {
                methodChannel?.invokeMethod("onPictureInPictureModeChanged", isInPictureInPictureMode)
            }
        }

        fun enterPictureInPictureMode(activity: Activity) {
            if (!canEnterPictureInPicture(activity)) return

            if (isPictureInPictureUnsupported) return

            withUnsupportedHandled {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    val autoEnter = usesAutoEnter && isPictureInPictureAllowed
                    withAspectRatioFallback(activity, autoEnter) {
                        activity.enterPictureInPictureMode(it)
                    }
                    // Entering hands the activity these params too.
                    isAutoEnterArmed = autoEnter
                } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    activity.enterPictureInPictureMode()
                }
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
            sourceContentRect?.let { sourceRectHint(it, aspect) }?.let {
                params.setSourceRectHint(it)
            }
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

        /**
         * The largest area of [aspect] centred in [content], which is what the
         * window animates in from. Android only takes a hint of the window's
         * aspect ratio, while the video is drawn cropped to fill its tile.
         */
        private fun sourceRectHint(content: Rect, aspect: Rational): Rect? {
            val ratio = aspect.toFloat()
            if (content.isEmpty || ratio <= 0f) return null

            var width = content.width()
            var height = (width / ratio).roundToInt()
            if (height > content.height()) {
                height = content.height()
                width = (height * ratio).roundToInt()
            }
            if (width <= 0 || height <= 0) return null

            val left = content.centerX() - width / 2
            val top = content.centerY() - height / 2
            return Rect(left, top, left + width, top + height)
        }

        private fun canEnterPictureInPicture(activity: Activity): Boolean {
            return activity.packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)
        }

        fun cleanup() {
            // The activity must not go on entering picture-in-picture for a
            // Flutter side that's gone. The allowed state is kept for this
            // engine, so attached to a new activity it arms that one again; a
            // new engine starts without it.
            if (usesAutoEnter) {
                getActivity?.invoke()?.let { applyParams(it, allowAutoEnter = false) }
            }
            isAutoEnterArmed = false
            methodChannel?.setMethodCallHandler(null)
            methodChannel = null
            getActivity = null
            videoAspectRatio = null
            sourceContentRect = null
        }
    }
}
