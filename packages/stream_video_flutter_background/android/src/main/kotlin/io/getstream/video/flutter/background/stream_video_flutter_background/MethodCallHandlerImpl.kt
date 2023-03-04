package io.getstream.video.flutter.background.stream_video_flutter_background

import android.app.Activity
import android.content.Context
import android.util.Log
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

class MethodCallHandlerImpl(
    appContext: Context,
    private val getActivity: () -> Activity?
) : MethodChannel.MethodCallHandler {

    private val logger by taggedLogger(tag = "StreamMethodHandler")

    private val serviceManager: ServiceManager = ServiceManagerImpl(appContext.applicationContext)

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        logger.d { "[onMethodCall] method: ${call.method}" }
        when (call.method) {
            "isServiceRunning" -> {
                result.success(StreamCallService.isRunning)
            }
            "startService" -> {
                val activity = getActivity()
                if (activity == null) {
                    logger.e { "[onMethodCall] #startService; failed (No activity found)" }
                    result.error("startService", "No activity found", null)
                    return
                }
                val engine = activity.engine
                if (engine == null) {
                    logger.e { "[onMethodCall] #startService; failed (No engine found)" }
                    result.error("startService", "Host activity has no FlutterEngine", activity::class.qualifiedName)
                    return
                }
                try {
                    val notificationOptions = call.extractNotificationOptions()
                    FlutterEngineCache.getInstance().put(STREAM_FLUTTER_BACKGROUND_ENGINE_ID, engine)
                    activity.intent?.putExtra(FlutterFlags.EXTRA_DESTROY_ENGINE_WITH_ACTIVITY, false)
                    result.success(serviceManager.start(notificationOptions))
                } catch (e: Throwable) {
                    logger.e { "[onMethodCall] #startService; failed: $e" }
                    result.error("startService", e.toString(), null)
                }
            }
            "updateService" -> {
                try {
                    val notificationOptions = call.extractNotificationOptions()
                    result.success(serviceManager.update(notificationOptions))
                } catch (e: Throwable) {
                    logger.e { "[onMethodCall] #updateService; failed: $e" }
                    result.error("updateService", e.toString(), null)
                }
            }
            "stopService" -> {
                val activity = getActivity()
                try {
                    FlutterEngineCache.getInstance().remove(STREAM_FLUTTER_BACKGROUND_ENGINE_ID)
                    activity?.intent?.removeExtra(FlutterFlags.EXTRA_DESTROY_ENGINE_WITH_ACTIVITY)
                    result.success(serviceManager.stop())
                } catch (e: Throwable) {
                    logger.e { "[onMethodCall] #stopService; failed: $e" }
                    result.error("stopService", e.toString(), null)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun MethodCall.extractNotificationOptions() = NotificationOptions(
        callCid = argument<String>(NotificationOptions.CALL_CID) ?: error("no call_cid found"),
        contentTitle = argument<String>(NotificationOptions.CONTENT_TITLE),
        contentText = argument<String>(NotificationOptions.CONTENT_TEXT),
    )

}