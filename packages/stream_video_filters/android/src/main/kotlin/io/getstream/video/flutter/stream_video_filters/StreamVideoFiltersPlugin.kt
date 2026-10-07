package io.getstream.video.flutter.stream_video_filters

import android.content.Context
import android.content.pm.PackageManager
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.getstream.webrtc.flutter.videoEffects.ProcessorProvider
import io.getstream.video.flutter.stream_video_filters.factories.BackgroundBlurFactory
import io.getstream.video.flutter.stream_video_filters.factories.BlurIntensity
import io.getstream.video.flutter.stream_video_filters.factories.FullFrameBlurFactory
import io.getstream.video.flutter.stream_video_filters.factories.VirtualBackgroundFactory

/** 
 * StreamVideoFiltersPlugin
 * 
 * A Flutter plugin that provides video filters functionality for Stream Video.
 */
class StreamVideoFiltersPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel
  private lateinit var applicationContext: Context
  private val TAG = "StreamVideoFiltersPlugin"

  companion object {
    // Names we add to the global ProcessorProvider, so unregisterAllFilters can
    // release them. Otherwise the factories live for the app's lifetime. Kept
    // static because ProcessorProvider is a process-wide map that outlives any
    // single plugin instance (engine detach/re-attach).
    private val registeredNames = mutableSetOf<String>()
  }
  
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    Log.d(TAG, "Plugin attached to engine")
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "stream_video_filters")
    applicationContext = flutterPluginBinding.applicationContext
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    Log.d(TAG, "Method call: ${call.method}")
    when (call.method) {
        "isBackgroundEffectSupported" -> {
                result.success(true)
            }
            "registerBlurEffectProcessors" -> {
                ProcessorProvider.addProcessor(
                    "BackgroundBlurLight",
                    BackgroundBlurFactory(BlurIntensity.LIGHT)
                )

                ProcessorProvider.addProcessor(
                    "BackgroundBlurMedium",
                    BackgroundBlurFactory(BlurIntensity.MEDIUM)
                )

                ProcessorProvider.addProcessor(
                    "BackgroundBlurHeavy",
                    BackgroundBlurFactory(BlurIntensity.HEAVY)
                )
                registeredNames.addAll(
                    listOf("BackgroundBlurLight", "BackgroundBlurMedium", "BackgroundBlurHeavy")
                )

                result.success(null)
            }
            "registerImageEffectProcessors" -> {
                val backgroundImageUrl = call.argument<String>("backgroundImageUrl")
                backgroundImageUrl?.let {
                    val name = "VirtualBackground-$backgroundImageUrl"
                    ProcessorProvider.addProcessor(
                        name,
                        VirtualBackgroundFactory(applicationContext, backgroundImageUrl)
                    )
                    registeredNames.add(name)
                }

                result.success(null)
            }
      "registerFullFrameBlurEffectProcessor" -> {
                ProcessorProvider.addProcessor(
                    "FullFrameBlur",
                    FullFrameBlurFactory()
                )
                registeredNames.add("FullFrameBlur")

                result.success(null)
            }
      "unregisterAllFilters" -> {
                for (name in registeredNames) {
                    try {
                        ProcessorProvider.removeProcessor(name)
                    } catch (e: RuntimeException) {
                        // Already removed; nothing to release.
                    }
                }
                registeredNames.clear()

                result.success(null)
            }
      else -> {
        Log.w(TAG, "Method not implemented: ${call.method}")
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}