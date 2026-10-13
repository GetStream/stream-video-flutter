package io.getstream.video.flutter.stream_video_flutter.service

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.content.pm.ServiceInfo
import android.os.Build
import androidx.core.content.ContextCompat

/**
 * What the app holds that bears on the foreground service types it may request.
 *
 * The `granted` flags are runtime permissions the user has to allow. The `declared` flags are
 * normal permissions, which are held exactly when the merged manifest declares them, so they
 * say whether the app kept or stripped the plugin's declaration.
 */
internal data class CallPermissions(
    val cameraGranted: Boolean,
    val microphoneGranted: Boolean,
    val manageOwnCallsDeclared: Boolean,
    val foregroundCameraDeclared: Boolean,
    val foregroundMicrophoneDeclared: Boolean,
    val foregroundPhoneCallDeclared: Boolean,
    val foregroundMediaPlaybackDeclared: Boolean,
) {
    companion object {
        fun of(context: Context): CallPermissions = CallPermissions(
            cameraGranted = context.holds(Manifest.permission.CAMERA),
            microphoneGranted = context.holds(Manifest.permission.RECORD_AUDIO),
            manageOwnCallsDeclared = context.holds(Manifest.permission.MANAGE_OWN_CALLS),
            foregroundCameraDeclared = context.holds(Manifest.permission.FOREGROUND_SERVICE_CAMERA),
            foregroundMicrophoneDeclared =
                context.holds(Manifest.permission.FOREGROUND_SERVICE_MICROPHONE),
            foregroundPhoneCallDeclared =
                context.holds(Manifest.permission.FOREGROUND_SERVICE_PHONE_CALL),
            foregroundMediaPlaybackDeclared =
                context.holds(Manifest.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK),
        )

        private fun Context.holds(permission: String): Boolean =
            ContextCompat.checkSelfPermission(this, permission) == PackageManager.PERMISSION_GRANTED
    }
}

/**
 * Resolves the foreground service types a call service requests from the OS.
 *
 * Every type is backed by a `FOREGROUND_SERVICE_*` permission in the plugin manifest, and
 * Google Play asks the app to justify each of those permissions with what it visibly does. A
 * service therefore requests only the types that match the call it hosts: [forOngoingCall] for
 * a voice or video call, [forLivestreamViewer] for a viewer, whose call is media playback
 * rather than a phone call.
 *
 * On Android 14 and newer a type is only requested when its permission is still declared, so
 * an app strips a type it has no use for by removing that one permission from its merged
 * manifest with `tools:node="remove"`. The manifest entry of the service may keep listing the
 * type: the OS only requires what is requested to be a subset of what is declared. Below
 * Android 14 those permissions do not exist and no type needs one.
 *
 * The SDK level and the permission state are parameters so the decision is testable without
 * a device.
 */
internal object ForegroundServiceTypes {

    /** The types for a voice or video call. */
    fun forOngoingCall(sdkInt: Int, permissions: CallPermissions): Int {
        // Before Android Q a foreground service carries no type.
        if (sdkInt < Build.VERSION_CODES.Q) return 0

        // From Android U each type needs its FOREGROUND_SERVICE_* permission declared.
        val gated = sdkInt >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE
        var types = 0

        // Since Android R the camera and microphone types are what allow those devices to be
        // used from the background, and each needs its runtime permission.
        if (sdkInt >= Build.VERSION_CODES.R) {
            if (permissions.cameraGranted && (!gated || permissions.foregroundCameraDeclared)) {
                types = types or ServiceInfo.FOREGROUND_SERVICE_TYPE_CAMERA
            }
            if (permissions.microphoneGranted &&
                (!gated || permissions.foregroundMicrophoneDeclared)
            ) {
                types = types or ServiceInfo.FOREGROUND_SERVICE_TYPE_MICROPHONE
            }
        }

        // Since Android U the phone call type requires MANAGE_OWN_CALLS as well.
        if (!gated ||
            (permissions.manageOwnCallsDeclared && permissions.foregroundPhoneCallDeclared)
        ) {
            types = types or ServiceInfo.FOREGROUND_SERVICE_TYPE_PHONE_CALL
        }

        // Below Android U the phone call type is always there. From Android U a foreground
        // service needs a type, so an app holding none of the permissions above gets the
        // permission-free short service.
        return if (types == 0) ServiceInfo.FOREGROUND_SERVICE_TYPE_SHORT_SERVICE else types
    }

    /**
     * The types for a livestream viewer.
     *
     * Media playback is what marks the call as a viewer's rather than a phone call. Microphone
     * and camera come along under the same rules as [forOngoingCall], so a viewer brought on
     * stage keeps publishing in the background once the app holds those permissions, and a
     * viewer-only app that stripped them is not asked to justify them.
     */
    fun forLivestreamViewer(sdkInt: Int, permissions: CallPermissions): Int {
        if (sdkInt < Build.VERSION_CODES.Q) return 0

        val gated = sdkInt >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE
        var types = 0

        if (!gated || permissions.foregroundMediaPlaybackDeclared) {
            types = types or ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK
        }

        if (sdkInt >= Build.VERSION_CODES.R) {
            if (permissions.cameraGranted && (!gated || permissions.foregroundCameraDeclared)) {
                types = types or ServiceInfo.FOREGROUND_SERVICE_TYPE_CAMERA
            }
            if (permissions.microphoneGranted &&
                (!gated || permissions.foregroundMicrophoneDeclared)
            ) {
                types = types or ServiceInfo.FOREGROUND_SERVICE_TYPE_MICROPHONE
            }
        }

        return if (types == 0) ServiceInfo.FOREGROUND_SERVICE_TYPE_SHORT_SERVICE else types
    }
}
