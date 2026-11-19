package io.getstream.video.flutter.stream_video_push_notification

import android.annotation.SuppressLint
import android.telecom.DisconnectCause
import android.app.Activity
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import android.os.Handler
import android.os.Looper
import java.lang.ref.WeakReference
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.*
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.getstream.video.flutter.stream_video_push_notification.Utils.Companion.reapCollection
import io.getstream.video.flutter.stream_video_push_notification.core.CallPayloadMapper
import io.getstream.video.flutter.stream_video_push_notification.core.CallStore
import io.getstream.video.flutter.stream_video_push_notification.core.PrefsCallStore
import io.getstream.video.flutter.stream_video_push_notification.telecom.StreamTelecomManager

class StreamVideoPushNotificationPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.RequestPermissionsResultListener {
  companion object {
        const val EXTRA_CALL_CALL_DATA = "EXTRA_CALL_CALL_DATA"

        @SuppressLint("StaticFieldLeak")
        private lateinit var instance: StreamVideoPushNotificationPlugin

        fun getInstance(): StreamVideoPushNotificationPlugin? {
            if (hasInstance()) {
                return instance
            }
            return null
        }

        fun hasInstance(): Boolean {
            return ::instance.isInitialized
        }

        private val methodChannels = mutableMapOf<BinaryMessenger, MethodChannel>()
        private val eventChannels = mutableMapOf<BinaryMessenger, EventChannel>()
        private val eventHandlers = mutableListOf<WeakReference<EventCallbackHandler>>()

        fun sendEvent(event: String, body: Map<String, Any?>) {
            eventHandlers.reapCollection().forEach {
                it.get()?.send(event, body)
            }
        }

        fun sharePluginWithRegister(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
            initSharedInstance(
                flutterPluginBinding.applicationContext,
                flutterPluginBinding.binaryMessenger
            )
        }

        fun initSharedInstance(context: Context, binaryMessenger: BinaryMessenger) {
            if (!::instance.isInitialized) {
                instance = StreamVideoPushNotificationPlugin()
                instance.incomingCallSoundPlayerManager = IncomingCallSoundPlayerManager(context)
                instance.incomingCallNotificationManager = IncomingCallNotificationManager(context, instance.incomingCallSoundPlayerManager)
                instance.context = context
            }

            val channel = MethodChannel(binaryMessenger, "stream_video_push_notification")
            methodChannels[binaryMessenger] = channel
            channel.setMethodCallHandler(instance)

            val events = EventChannel(binaryMessenger, "stream_video_push_notification_events")
            eventChannels[binaryMessenger] = events

            val handler = EventCallbackHandler()
            eventHandlers.add(WeakReference(handler))
            events.setStreamHandler(handler)

        }

    }

  private var activity: Activity? = null
  private var context: Context? = null

      private var incomingCallNotificationManager: IncomingCallNotificationManager? = null
    private var incomingCallSoundPlayerManager: IncomingCallSoundPlayerManager? = null

    fun getIncomingCallNotificationManager(): IncomingCallNotificationManager? {
        return incomingCallNotificationManager
    }

    fun getIncomingCallSoundPlayerManager(): IncomingCallSoundPlayerManager? {
        return incomingCallSoundPlayerManager
    }

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    sharePluginWithRegister(flutterPluginBinding)
  }

  private fun callStore(): CallStore? = context?.let { PrefsCallStore(it) }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
     try {
            when (call.method) {
                "showIncomingCall" -> {
                    val data = CallPayloadMapper.fromArgs(call.arguments() ?: emptyMap())
                        .copy(from = "notification")
                    //send BroadcastReceiver
                    context?.sendBroadcast(
                        IncomingCallBroadcastReceiver.getIntentIncoming(
                            requireNotNull(context),
                            CallPayloadMapper.toBundle(data)
                        )
                    )

                    result.success(true)
                }

                "showMissCallNotification" -> {
                    val data = CallPayloadMapper.fromArgs(call.arguments() ?: emptyMap())
                        .copy(from = "notification")
                    
                    incomingCallNotificationManager?.clearIncomingNotification(CallPayloadMapper.toBundle(data), false)
                    incomingCallNotificationManager?.showMissCallNotification(CallPayloadMapper.toBundle(data))
                    result.success(true)
                }

                "startCall" -> {
                    val data = CallPayloadMapper.fromArgs(call.arguments() ?: emptyMap())
                    context?.sendBroadcast(
                        IncomingCallBroadcastReceiver.getIntentStart(
                            requireNotNull(context),
                            CallPayloadMapper.toBundle(data)
                        )
                    )

                    result.success(true)
                }

                "initData" -> {
                    val configuration = call.arguments as? Map<String, Any?>
                    context?.let { StreamTelecomManager.init(it, configuration) }

                    result.success(null)
                }

                "muteCall" -> {
                    val map = buildMap {
                        val args = call.arguments
                        if (args is Map<*, *>) {
                            putAll(args as Map<String, Any>)
                        }
                    }
                    sendEvent(IncomingCallConstants.ACTION_CALL_TOGGLE_MUTE, map)


                    result.success(true)
                }

                "holdCall" -> {
                    val map = buildMap {
                        val args = call.arguments
                        if (args is Map<*, *>) {
                            putAll(args as Map<String, Any>)
                        }
                    }
                    sendEvent(IncomingCallConstants.ACTION_CALL_TOGGLE_HOLD, map)

                    val callId = map["id"] as? String
                    if (callId != null && context != null) {
                        StreamTelecomManager.setOnHold(
                            requireNotNull(context),
                            callId,
                            map["isOnHold"] as? Boolean ?: true
                        )
                    }

                    result.success(true)
                }

                "isMuted" -> {
                    val callId = (call.arguments as? Map<*, *>)?.get("id") as? String
                    result.success(callId?.let { StreamTelecomManager.isMuted(it) } ?: false)
                }

                "endCall" -> {
                    val data = CallPayloadMapper.fromArgs(call.arguments() ?: emptyMap())
                    val currentCall = callStore()?.byId(data.id)
                    if (currentCall != null && context != null) {
                        if(currentCall.isAccepted) {
                            context?.sendBroadcast(
                                IncomingCallBroadcastReceiver.getIntentEnded(
                                    requireNotNull(context),
                                    CallPayloadMapper.toBundle(currentCall)
                                )
                            )
                        }else {
                            context?.sendBroadcast(
                                IncomingCallBroadcastReceiver.getIntentDecline(
                                    requireNotNull(context),
                                    CallPayloadMapper.toBundle(currentCall)
                                )
                            )
                        }
                    }
                    result.success(true)
                }

                "callConnected" -> {
                    val data = CallPayloadMapper.fromArgs(call.arguments() ?: emptyMap())
                    val currentCall = callStore()?.byId(data.id)
                    if (currentCall != null && context != null) {
                        context?.sendBroadcast(
                            IncomingCallBroadcastReceiver.getIntentConnected(
                                requireNotNull(context),
                                CallPayloadMapper.toBundle(currentCall)
                            )
                        )
                    }
                    result.success(true)
                }

                "endAllCalls" -> {
                    val calls = callStore()?.all().orEmpty()
                    calls.forEach {
                        if (it.isAccepted) {
                            context?.sendBroadcast(
                                IncomingCallBroadcastReceiver.getIntentEnded(
                                    requireNotNull(context),
                                    CallPayloadMapper.toBundle(it)
                                )
                            )
                        } else {
                            context?.sendBroadcast(
                                IncomingCallBroadcastReceiver.getIntentDecline(
                                    requireNotNull(context),
                                    CallPayloadMapper.toBundle(it)
                                )
                            )
                        }
                    }
                    callStore()?.removeAll()

                    // Also sweep Telecom directly. The loop above only covers entries still in
                    // ACTIVE_CALLS, so a call that fell out of that list while remaining live in
                    // the Telecom stack would never be disconnected.
                    context?.let {
                        StreamTelecomManager.disconnectAll(it, DisconnectCause.LOCAL)
                    }

                    result.success(true)
                }

                // Ends the ring, not the call: the user accepted and is in the call now, so the
                // notification and ringtone go but the Telecom registration stays. Kept apart from
                // "endAllCalls" because an ENDED broadcast alone cannot say which of the two it is.
                "dismissRingingCall" -> {
                    val requestedCid = (call.arguments as? Map<*, *>)?.get("id") as? String
                    val store = callStore()
                    val calls = requestedCid
                        ?.let { cid -> store?.byCallCid(cid) }
                        ?.takeIf { it.isNotEmpty() }
                        ?: store?.all().orEmpty()

                    calls.forEach { callData ->
                        context?.let { ctx ->
                            // Answer it rather than reading `isAccepted`. An accept from the
                            // Flutter UI never fires the native ACCEPT broadcast, which is the
                            // only thing that sets that flag and the only thing that answers the
                            // Telecom call — so the flag says false for the most common accept
                            // path, and trusting it here both left the call ringing in Telecom
                            // forever and tore it down as REJECTED. This method is only ever
                            // called for a call the user accepted, so answering is the truth.
                            // Idempotent, so an accept from the notification action is unaffected.
                            StreamTelecomManager.answer(ctx, callData.id)

                            ctx.sendBroadcast(
                                IncomingCallBroadcastReceiver.getIntentEnded(
                                    ctx,
                                    CallPayloadMapper.toBundle(callData),
                                    keepSystemCall = true
                                )
                            )
                        }
                    }
                    result.success(true)
                }

                "activeCalls" -> {
                    result.success(
                        callStore()?.all().orEmpty().map(CallPayloadMapper::toStoredMap),
                    )
                }

                "getDevicePushTokenVoIP" -> {
                    result.success("")
                }

                "silenceEvents" -> {
                    val silence = call.arguments as? Boolean ?: false
                    IncomingCallBroadcastReceiver.silenceEvents = silence
                    result.success(true)
                }

                "requestNotificationPermission" -> {
                    val map = buildMap {
                        val args = call.arguments
                        if (args is Map<*, *>) {
                            putAll(args as Map<String, Any>)
                        }
                    }
                    incomingCallNotificationManager?.requestNotificationPermission(activity, map)
                    result.success(true)
                }

                "canUseFullScreenIntent" -> {
                    result.success(incomingCallNotificationManager?.canUseFullScreenIntent() ?: true)
                }

                // EDIT - clear the incoming notification/ring (after accept/decline/timeout)
                "hideIncomingCall" -> {
                    val data = CallPayloadMapper.fromArgs(call.arguments() ?: emptyMap())
                    incomingCallSoundPlayerManager?.stop()
                    incomingCallNotificationManager?.clearIncomingNotification(CallPayloadMapper.toBundle(data), false)
                    result.success(true)
                }

                "ensureFullScreenIntentPermission" -> {
                    val notificationManager = context?.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                    if (Build.VERSION.SDK_INT >= 34) {
                        if (!notificationManager.canUseFullScreenIntent()) {
                            incomingCallNotificationManager?.requestFullIntentPermission(activity)
                        }
                    }
                    result.success(true)
                }

                else -> result.notImplemented()
            }
        } catch (error: Exception) {
            result.error("error", error.message, "")
        }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
     methodChannels.remove(binding.binaryMessenger)?.setMethodCallHandler(null)
        eventChannels.remove(binding.binaryMessenger)?.setStreamHandler(null)
        StreamTelecomManager.releaseIfIdle()
        // The notification and ringtone managers are shared by every engine and by the
        // manifest-declared receiver and service, so they live as long as the process.
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    instance.context = binding.activity.applicationContext
        instance.activity = binding.activity
        binding.addRequestPermissionsResultListener(this)
  }

override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        instance.context = binding.activity.applicationContext
        instance.activity = binding.activity
        binding.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivity() {
        instance.activity = null
    }

    class EventCallbackHandler : EventChannel.StreamHandler {

        private var eventSink: EventChannel.EventSink? = null

        override fun onListen(arguments: Any?, sink: EventChannel.EventSink) {
            eventSink = sink
        }

        fun send(event: String, body: Map<String, Any?>) {
            val data = mapOf(
                "event" to event,
                "body" to body
            )
            Handler(Looper.getMainLooper()).post {
                eventSink?.success(data)
            }
        }

        override fun onCancel(arguments: Any?) {
            eventSink = null
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        instance.incomingCallNotificationManager?.onRequestPermissionsResult(
            instance.activity,
            requestCode,
            grantResults
        )
        return true
    }
}
