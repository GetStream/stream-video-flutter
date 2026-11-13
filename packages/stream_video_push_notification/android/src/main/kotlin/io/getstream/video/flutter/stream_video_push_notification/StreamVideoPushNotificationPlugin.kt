package io.getstream.video.flutter.stream_video_push_notification

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.getstream.video.flutter.stream_video_push_notification.channel.PushMethodCallHandler
import io.getstream.video.flutter.stream_video_push_notification.channel.RingingEventDispatcher
import io.getstream.video.flutter.stream_video_push_notification.core.RingingComponents
import io.getstream.video.flutter.stream_video_push_notification.telecom.StreamTelecomManager

/**
 * The plugin instance of one Flutter engine. It gives the engine its own method channel handler
 * and event sink, and connects them to the process-wide [RingingComponents].
 */
class StreamVideoPushNotificationPlugin : FlutterPlugin, ActivityAware {

    companion object {
        const val EXTRA_CALL_CALL_DATA = "EXTRA_CALL_CALL_DATA"

        private const val METHOD_CHANNEL = "stream_video_push_notification"
        private const val EVENT_CHANNEL = "stream_video_push_notification_events"
    }

    private var components: RingingComponents? = null
    private var handler: PushMethodCallHandler? = null
    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    private var eventSink: RingingEventDispatcher.EngineSink? = null
    private var activityBinding: ActivityPluginBinding? = null

    private val permissionsResultListener =
        PluginRegistry.RequestPermissionsResultListener { requestCode, _, grantResults ->
            handler?.onRequestPermissionsResult(requestCode, grantResults) ?: false
        }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val context = binding.applicationContext
        val components = RingingComponents.get(context).also { this.components = it }

        val handler = PushMethodCallHandler.create(context, components).also { this.handler = it }
        methodChannel = MethodChannel(binding.binaryMessenger, METHOD_CHANNEL).apply {
            setMethodCallHandler(handler)
        }

        val sink = components.events.attach().also { eventSink = it }
        eventChannel = EventChannel(binding.binaryMessenger, EVENT_CHANNEL).apply {
            setStreamHandler(sink)
        }
    }

    /** Releases this engine's channels and event sink; the ringing components stay. */
    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
        eventChannel?.setStreamHandler(null)
        eventChannel = null
        eventSink?.let { components?.events?.detach(it) }
        eventSink = null
        handler = null
        components = null
        StreamTelecomManager.releaseIfIdle()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) = attachActivity(binding)

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) =
        attachActivity(binding)

    override fun onDetachedFromActivityForConfigChanges() = detachActivity()

    override fun onDetachedFromActivity() = detachActivity()

    private fun attachActivity(binding: ActivityPluginBinding) {
        detachActivity()
        activityBinding = binding
        handler?.activity = binding.activity
        binding.addRequestPermissionsResultListener(permissionsResultListener)
    }

    private fun detachActivity() {
        activityBinding?.removeRequestPermissionsResultListener(permissionsResultListener)
        activityBinding = null
        handler?.activity = null
    }
}
