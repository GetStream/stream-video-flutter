package io.getstream.video.flutter.background.stream_video_flutter_background

import android.app.Activity
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.service.ServiceAware
import io.flutter.embedding.engine.plugins.service.ServicePluginBinding
import io.flutter.plugin.common.MethodChannel
import io.getstream.log.StreamLog
import io.getstream.log.taggedLogger
import io.getstream.video.flutter.background.stream_video_flutter_background.service.notification.registerNotificationActionReceiverAsFlow
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancelChildren
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch

private const val TAG = "StreamVideoPlugin"

/** StreamVideoFlutterBackgroundPlugin */
class StreamVideoFlutterBackgroundPlugin : FlutterPlugin, ActivityAware, ServiceAware {

    init {
        StreamLog.i(TAG) { "<init> no args" }
    }

    private val logger by taggedLogger(tag = TAG)

    private val scope = CoroutineScope(context = SupervisorJob() + Dispatchers.Main)

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private var channel: MethodChannel? = null
    private var handler: MethodCallHandlerImpl? = null

    private var activity: Activity? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        logger.i { "[onAttachedToEngine] no args" }
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME).apply {
            setMethodCallHandler(MethodCallHandlerImpl(flutterPluginBinding.applicationContext) { activity }.also {
                handler = it
            })
        }
        scope.launch {
            flutterPluginBinding.applicationContext.registerNotificationActionReceiverAsFlow().collect {
                logger.i { "[onNotificationAction] action: $it" }
                channel?.invokeMethod("onButtonClick", arrayListOf(it.type, it.callCid))
            }
        }
    }



    override fun onAttachedToService(binding: ServicePluginBinding) {
        logger.i { "[onAttachedToService] service: ${binding.service}" }
    }

    override fun onDetachedFromService() {
        logger.i { "[onDetachedFromService] no args" }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        logger.i { "[onAttachedToActivity] activity: ${binding.activity}" }
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        logger.i { "[onDetachedFromActivityForConfigChanges] no args" }
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        logger.i { "[onReattachedToActivityForConfigChanges] activity: ${binding.activity}" }
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        logger.i { "[onDetachedFromActivity] no args" }
        activity = null
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.i(TAG, "[onDetachedFromEngine] no args")
        channel?.setMethodCallHandler(null)
        scope.coroutineContext.cancelChildren()
    }

    companion object {
        const val CHANNEL_NAME = "stream_video_flutter_background"
    }
}
