package io.getstream.video.flutter.stream_video_flutter.service

import android.app.Activity
import android.app.PictureInPictureParams
import android.content.pm.ActivityInfo
import android.content.pm.PackageManager
import android.os.Build
import android.util.Rational
import io.getstream.video.flutter.stream_video_flutter.service.utils.getBoolean

class PictureInPictureHelper {
    companion object {
        const val PIP_ENABLED_PREF_KEY = "pip_enabled"

        fun disablePictureInPicture(activity: Activity) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val params = PictureInPictureParams.Builder()
                params.setAutoEnterEnabled(false)
                activity.setPictureInPictureParams(params.build())
            }
        }

        fun enterPictureInPictureIfInCall(activity: Activity) {
            val pipEnabled = getBoolean(activity, PIP_ENABLED_PREF_KEY)
            if (!pipEnabled) return

            if (activity.packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    val currentOrientation = activity.resources.configuration.orientation

                    val aspect =
                            if (currentOrientation == ActivityInfo.SCREEN_ORIENTATION_PORTRAIT) {
                                Rational(9, 16)
                            } else {
                                Rational(16, 9)
                            }

                    val params = PictureInPictureParams.Builder()
                    params.setAspectRatio(aspect).apply {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                            setAutoEnterEnabled(true)
                        }
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                            setTitle("Video Player")
                            setSeamlessResizeEnabled(true)
                        }
                    }

                    activity.enterPictureInPictureMode(params.build())
                } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    activity.enterPictureInPictureMode()
                }
            }
        }
    }
}