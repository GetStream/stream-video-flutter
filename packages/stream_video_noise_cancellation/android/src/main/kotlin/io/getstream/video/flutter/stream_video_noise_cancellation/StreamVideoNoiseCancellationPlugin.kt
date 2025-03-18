package io.getstream.video.flutter.stream_video_noise_cancellation

import android.content.Context
import android.content.pm.PackageManager
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.getstream.webrtc.flutter.FlutterWebRTCPlugin
import io.getstream.video.flutter.stream_video_noise_cancellation.NoiseCancellationAudioProcessingController

/** 
 * StreamVideoNoiseCancellationPlugin
 * 
 * A Flutter plugin that provides noise cancellation functionality for Stream Video.
 */
class StreamVideoNoiseCancellationPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel
  private lateinit var applicationContext: Context
  private var controller: NoiseCancellationAudioProcessingController? = null
  private val TAG = "NoiseCancellationPlugin"
  
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    Log.d(TAG, "Plugin attached to engine")
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "stream_video_noise_cancellation")
    applicationContext = flutterPluginBinding.applicationContext
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    Log.d(TAG, "Method call: ${call.method}")
    when (call.method) {
      "registerProcessor" -> {
        try {
          if (controller != null) {
            Log.w(TAG, "Noise cancellation processor is already registered")
            result.success(null)
            return
          }

          controller = NoiseCancellationAudioProcessingController(applicationContext)
          FlutterWebRTCPlugin.sharedSingleton.setAudioProcessingFactoryProvider(controller)
          Log.d(TAG, "Noise cancellation processor registered successfully")
          result.success(null)
        } catch (e: Exception) {
          Log.e(TAG, "Failed to initialize noise cancellation", e)
          result.error(
            "INITIALIZATION_ERROR",
            "Failed to initialize noise cancellation: ${e.message}",
            e.stackTraceToString()
          )
        }
      }
      "isEnabled" -> {
        try {
          val controller = this.controller
          if (controller == null) {
            Log.e(TAG, "Noise cancellation is not initialized")
            result.error(
              "NOT_INITIALIZED",
              "Noise cancellation is not initialized. Call registerProcessor first.",
              null
            )
            return
          }

          val enabled = controller.noiseCancellation.isEnabled()
          result.success(enabled)
        } catch (e: Exception) {
          Log.e(TAG, "Failed to get noise cancellation state", e)
          result.error(
            "OPERATION_ERROR",
            "Failed to get noise cancellation state: ${e.message}",
            e.stackTraceToString()
          )
        }
      }
      "setEnabled" -> {
        try {
          val enabled = call.argument<Boolean>("enabled")
            ?: throw IllegalArgumentException("Missing required parameter 'enabled'")

          val controller = this.controller
          if (controller == null) {
            result.error(
              "NOT_INITIALIZED",
              "Noise cancellation is not initialized. Call registerProcessor first.",
              null
            )
            return
          }
          
          controller.noiseCancellation.setEnabled(enabled)
          result.success(null)
        } catch (e: IllegalArgumentException) {
          Log.e(TAG, "Missing required parameter", e)
          result.error(
            "INVALID_ARGUMENT",
            e.message,
            e.stackTraceToString()
          )
        } catch (e: Exception) {
          Log.e(TAG, "Failed to set noise cancellation state", e)
          result.error(
            "OPERATION_ERROR",
            "Failed to set noise cancellation state: ${e.message}",
            e.stackTraceToString()
          )
        }
      }
      "deviceSupportsAdvancedAudioProcessing" -> {
        val hasSupport = applicationContext.packageManager.hasSystemFeature(PackageManager.FEATURE_AUDIO_PRO)
        result.success(hasSupport)
      }
      else -> {
        Log.w(TAG, "Method not implemented: ${call.method}")
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    controller?.let {
      try {
        it.noiseCancellation.setEnabled(false)
      } catch (e: Exception) {
        Log.e(TAG, "Error during cleanup", e)
      }
      controller = null
    }
    channel.setMethodCallHandler(null)
  }
}