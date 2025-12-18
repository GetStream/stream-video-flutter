package io.getstream.video.flutter.stream_video_flutter

import android.content.Intent
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.getstream.log.StreamLog
import io.getstream.log.taggedLogger
import io.getstream.video.flutter.stream_video_flutter.service.notification.IdentifiedNotification
import io.getstream.video.flutter.stream_video_flutter.service.notification.registerNotificationActionReceiverAsFlow
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancelChildren
import kotlinx.coroutines.launch

private const val TAG = "StreamVideoPlugin"

/** StreamVideoFlutterPlugin */
class StreamVideoFlutterPlugin: FlutterPlugin, ActivityAware, PluginRegistry.NewIntentListener,
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
        channel?.invokeMethod("onBackgroundNotificationButtonClick", arrayListOf(it.type, it.callCid, it.serviceType.toString()))
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
    logger.d { "[onPlatformUiLayerDestroyed] no args" }
    channel?.invokeMethod("onPlatformUiLayerDestroyed", "")
  }

  private fun handleIntent(intent: Intent?): Boolean {
    if (intent?.action?.endsWith(IdentifiedNotification.ACTION_CALL_SUFFIX) != true) {
      logger.w { "[handleIntent] rejected (invalid action): $intent" }
      return false
    }
    
    val callCid = intent.getStringExtra("callCid")
    if (callCid.isNullOrBlank()) {
      logger.w { "[handleIntent] rejected (callCid is blank or missing from intent)" }
      return false
    }
    
    logger.d { "[handleIntent] intent: $intent" }
    channel?.invokeMethod("onBackgroundNotificationContentClick", callCid)
    return true
  }

  companion object {
    const val CHANNEL_NAME = "stream_video_flutter"
  }
}
