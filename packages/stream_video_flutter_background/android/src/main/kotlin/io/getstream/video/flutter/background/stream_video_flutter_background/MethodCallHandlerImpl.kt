package io.getstream.video.flutter.background.stream_video_flutter_background

import android.app.Activity
import android.content.Context
import io.flutter.embedding.android.FlutterFlags
import io.flutter.embedding.android.engine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.getstream.log.taggedLogger
import io.getstream.video.flutter.background.stream_video_flutter_background.service.ServiceManager
import io.getstream.video.flutter.background.stream_video_flutter_background.service.ServiceManagerImpl
import io.getstream.video.flutter.background.stream_video_flutter_background.service.StreamCallService
import io.getstream.video.flutter.background.stream_video_flutter_background.service.notification.NotificationOptions
import io.getstream.video.flutter.background.stream_video_flutter_background.service.notification.NotificationOptions.Companion.APP_ID
import io.getstream.video.flutter.background.stream_video_flutter_background.service.notification.NotificationOptions.Companion.CALL_CID
import io.getstream.video.flutter.background.stream_video_flutter_background.service.notification.NotificationOptions.Companion.CONTENT_TEXT
import io.getstream.video.flutter.background.stream_video_flutter_background.service.notification.NotificationOptions.Companion.CONTENT_TITLE

class MethodCallHandlerImpl(
    appContext: Context,
    private val getActivity: () -> Activity?
) : MethodChannel.MethodCallHandler {

    private val logger by taggedLogger(tag = "StreamMethodHandler")

    private val serviceManager: ServiceManager = ServiceManagerImpl(appContext.applicationContext)

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        logger.d { "[onMethodCall] method: ${call.method}" }
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "isServiceRunning" -> {
                result.success(StreamCallService.isRunning)
            }
            "startService" -> {
                val activity = getActivity()
                if (activity == null) {
                    result.error("startService", "No activity found", null)
                    return
                }
                val engine = activity.engine
                if (engine == null) {
                    result.error("startService", "Host activity has no FlutterEngine", activity::class.qualifiedName)
                    return
                }
                try {
                    StreamCallService.notificationOptions = call.extractNotificationOptions()
                    FlutterEngineCache.getInstance().put(STREAM_FLUTTER_BACKGROUND_ENGINE_ID, engine)
                    activity.intent?.putExtra(FlutterFlags.EXTRA_DESTROY_ENGINE_WITH_ACTIVITY, false)
                    result.success(serviceManager.start())
                } catch (e: Throwable) {
                    result.error("startService", e.toString(), null)
                }
            }
            "stopService" -> {
                val activity = getActivity()
                if (activity == null) {
                    result.error("stopService", "No activity found", null)
                    return
                }
                val engine = activity.engine
                if (engine == null) {
                    result.error("stopService", "Host activity has no FlutterEngine", activity::class.qualifiedName)
                    return
                }
                try {
                    FlutterEngineCache.getInstance().remove(STREAM_FLUTTER_BACKGROUND_ENGINE_ID)
                    activity.intent?.removeExtra(FlutterFlags.EXTRA_DESTROY_ENGINE_WITH_ACTIVITY)
                    result.success(serviceManager.stop())
                } catch (e: Throwable) {
                    result.error("stopService", e.toString(), null)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun MethodCall.extractNotificationOptions() = NotificationOptions(
        appId = argument<String>(APP_ID) ?: error("no app_id found"),
        callCid = argument<String>(CALL_CID) ?: error("no call_cid found"),
        contentTitle = argument<String>(CONTENT_TITLE) ?: error("no content_title found"),
        contentText = argument<String>(CONTENT_TEXT) ?: error("no content_text found"),
    )

}