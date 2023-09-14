package io.getstream.video.flutter.stream_video_push_notification

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** StreamVideoPushNotificationPlugin */
class StreamVideoPushNotificationPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  // Stub to avoid MissingPluginException being thrown on Android
  private lateinit var events : EventChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "stream_video_push_notification")
    channel.setMethodCallHandler(this)
    events = EventChannel(flutterPluginBinding.binaryMessenger, "stream_video_push_notification_events").apply {
      setStreamHandler(object : EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) { /* no-op */ }
        override fun onCancel(arguments: Any?) { /* no-op */ }
      })
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getDevicePushTokenVoIP" -> result.notImplemented()
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    events?.setStreamHandler(null)
  }
}
