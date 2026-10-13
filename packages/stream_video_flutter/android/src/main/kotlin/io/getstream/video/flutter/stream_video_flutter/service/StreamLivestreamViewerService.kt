package io.getstream.video.flutter.stream_video_flutter.service

import android.content.Context
import android.content.pm.ServiceInfo
import android.os.Build
import io.getstream.log.taggedLogger

/**
 * The foreground service for a livestream viewer: a participant whose call is media playback
 * rather than a phone call.
 *
 * It requests `mediaPlayback` in place of `phoneCall`, plus `microphone` and `camera` when the
 * app holds them, so a viewer brought on stage keeps publishing in the background. An app
 * without a viewer mode removes the `FOREGROUND_SERVICE_MEDIA_PLAYBACK` permission from its
 * merged manifest with `tools:node="remove"`, and may remove this service entry the same way, in
 * which case a viewer call runs in [StreamCallService] instead.
 *
 * A call lands here when its effective `AudioConfigurationPolicy` resolves to
 * `AndroidCallServiceKind.livestreamViewer`, which the viewer policy does. The kind is fixed
 * when the call becomes active: a policy changed through the call preferences afterwards does
 * not move the call to another service.
 */
class StreamLivestreamViewerService : StreamCallService() {

    private val logger by taggedLogger("StreamLivestreamViewerService")

    override fun getServiceTypeForOngoingCall(context: Context): Int {
        val types = ForegroundServiceTypes.forLivestreamViewer(
            sdkInt = Build.VERSION.SDK_INT,
            permissions = CallPermissions.of(context),
        )
        if (types == ServiceInfo.FOREGROUND_SERVICE_TYPE_SHORT_SERVICE) {
            logger.w {
                "FOREGROUND_SERVICE_MEDIA_PLAYBACK is not declared in the manifest, so the " +
                    "livestream viewer runs as a short service, which the system stops after a " +
                    "few minutes. Keep the permission the plugin declares, or give viewers an " +
                    "AudioConfigurationPolicy whose androidCallServiceKind is `call`."
            }
        }
        return types
    }
}
