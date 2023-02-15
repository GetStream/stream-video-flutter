package io.getstream.video.flutter.background.stream_video_flutter_background

import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.getstream.video.flutter.background.stream_video_flutter_background.service.StreamCallService

class MethodCallHandlerImpl(
    private val appContext: Context
) : MethodChannel.MethodCallHandler {

    private lateinit var channel : MethodChannel

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "isServiceRunning" -> {
                result.success(StreamCallService.isRunning)
            }
            "startService" -> {

                result.success(StreamCallService.isRunning)
            }
            "stopService" -> {

                result.success(StreamCallService.isRunning)
            }
            else -> {
                result.notImplemented()
            }
        }
    }



}