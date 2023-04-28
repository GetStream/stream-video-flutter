package io.getstream.video.flutter.background.stream_video_flutter_background

import android.content.Intent
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.getstream.log.StreamLog
import io.getstream.log.taggedLogger
import io.getstream.video.flutter.background.stream_video_flutter_background.service.StreamCallService
import io.getstream.video.flutter.background.stream_video_flutter_background.service.notification.IdentifiedNotification
import io.getstream.video.flutter.background.stream_video_flutter_background.service.notification.registerNotificationActionReceiverAsFlow
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancelChildren
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch

private const val TAG = "StreamVideoPlugin"

/** StreamVideoFlutterBackgroundPlugin */
class StreamVideoFlutterBackgroundPlugin : FlutterPlugin, ActivityAware, PluginRegistry.NewIntentListener,
    PluginRegistry.RequestPermissionsResultListener {

    init {
        StreamLog.i(TAG) { "<init> no args" }
    }

    private val logger by taggedLogger(tag = TAG)

    private val scope = CoroutineScope(context = SupervisorJob() + Dispatchers.Main)

    private val getActivity = { activityBinding?.activity }

    private var channel: MethodChannel? = null
    private var handler: MethodCallHandlerImpl? = null

    private var activityBinding: ActivityPluginBinding? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        logger.i { "[onAttachedToEngine] no args" }
        channel = MethodChannel(binding.binaryMessenger, CHANNEL_NAME).apply {
            setMethodCallHandler(MethodCallHandlerImpl(binding.applicationContext, getActivity).also {
                handler = it
            })
        }
        scope.launch {
            binding.applicationContext.registerNotificationActionReceiverAsFlow().collect {
                logger.i { "[onNotificationAction] action: $it" }
                channel?.invokeMethod("onNotificationButtonClick", arrayListOf(it.type, it.callCid))
            }
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        logger.i { "[onAttachedToActivity] activity: ${binding.activity}" }
        binding.addOnNewIntentListener(this)
        binding.addRequestPermissionsResultListener(this);
        activityBinding = binding
        handleIntent(binding.activity.intent)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        logger.i { "[onDetachedFromActivityForConfigChanges] no args" }
        activityBinding?.removeOnNewIntentListener(this)
        activityBinding?.removeRequestPermissionsResultListener(this);
        activityBinding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        logger.i { "[onReattachedToActivityForConfigChanges] activity: ${binding.activity}" }
        binding.addOnNewIntentListener(this)
        binding.addRequestPermissionsResultListener(this);
        activityBinding = binding
    }

    override fun onDetachedFromActivity() {
        logger.i { "[onDetachedFromActivity] no args" }
        activityBinding?.removeOnNewIntentListener(this)
        activityBinding?.removeRequestPermissionsResultListener(this);
        activityBinding = null

        onPlatformUiLayerDestroyed()
    }

    override fun onNewIntent(intent: Intent): Boolean {
        logger.i { "[onNewIntent] intent: $intent" }
        return handleIntent(intent)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        logger.i { "[onRequestPermissionsResult] rc: $requestCode, permissions: $permissions, results: $grantResults" }
        return handler?.onRequestPermissionsResult(requestCode, permissions, grantResults) ?: false
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.i(TAG, "[onDetachedFromEngine] no args")
        channel?.setMethodCallHandler(null)
        scope.coroutineContext.cancelChildren()
    }

    private fun onPlatformUiLayerDestroyed() {
        val callCid = StreamCallService.notificationPayload.callCid
        if (callCid.isBlank()) {
            logger.w { "[onPlatformUiLayerDestroyed] rejected (callCid is blank)" }
            return
        }
        logger.d { "[onPlatformUiLayerDestroyed] no args" }
        channel?.invokeMethod("onPlatformUiLayerDestroyed", callCid)
    }

    private fun handleIntent(intent: Intent?): Boolean {
        if (intent?.action?.endsWith(IdentifiedNotification.ACTION_CALL_SUFFIX) != true) {
            logger.w { "[handleIntent] rejected (invalid action): $intent" }
            return false
        }
        val callCid = StreamCallService.notificationPayload.callCid
        if (callCid.isBlank()) {
            logger.w { "[handleIntent] rejected (callCid is blank)" }
            return false
        }
        logger.d { "[handleIntent] intent: $intent" }
        channel?.invokeMethod("onNotificationContentClick", callCid)
        return true
    }

    companion object {
        const val CHANNEL_NAME = "stream_video_flutter_background"
    }
}
