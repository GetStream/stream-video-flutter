package io.getstream.video.flutter.background.stream_video_flutter_background

import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

private const val TAG = "StreamVideoPlugin"

/** StreamVideoFlutterBackgroundPlugin */
class StreamVideoFlutterBackgroundPlugin: FlutterPlugin {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private var channel : MethodChannel? = null
  private var handler : MethodCallHandlerImpl? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    Log.i(TAG, "[onAttachedToEngine] no args")
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME).apply {
      setMethodCallHandler(MethodCallHandlerImpl(flutterPluginBinding.applicationContext).also {
        handler = it
      })
    }

    MainScope().launch {
      repeat(20) {
        delay(2000L)
        channel?.invokeMethod("onButtonClick", "cancel_$it")
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    Log.i(TAG, "[onAttachedToEngine] no args")
    channel?.setMethodCallHandler(null)
  }

  companion object {
    const val CHANNEL_NAME = "stream_video_flutter_background"
  }
}
