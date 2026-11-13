package io.getstream.video.flutter.stream_video_push_notification.channel

import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallBroadcastReceiver
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallConstants
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallNotificationManager
import io.getstream.video.flutter.stream_video_push_notification.core.CallPayloadMapper
import io.getstream.video.flutter.stream_video_push_notification.core.CallStore
import io.getstream.video.flutter.stream_video_push_notification.core.DismissReason
import io.getstream.video.flutter.stream_video_push_notification.core.RingingComponents
import io.getstream.video.flutter.stream_video_push_notification.core.RingingCall
import io.getstream.video.flutter.stream_video_push_notification.core.RingingController
import io.getstream.video.flutter.stream_video_push_notification.notification.RingtonePlayer
import io.getstream.video.flutter.stream_video_push_notification.permissions.FullScreenIntentPermission
import io.getstream.video.flutter.stream_video_push_notification.permissions.NotificationPermissionFlow
import io.getstream.video.flutter.stream_video_push_notification.telecom.AudioEndpointUtils
import io.getstream.video.flutter.stream_video_push_notification.telecom.TelecomIntegration

/**
 * The method channel of one Flutter engine: reads each call's arguments and hands it to the
 * controller, the call store, the notifications, Telecom or the permission flows. Any exception
 * is answered as an `error` result.
 */
@Suppress("UNCHECKED_CAST")
internal class PushMethodCallHandler(
    private val context: Context,
    private val controller: RingingController,
    private val store: CallStore,
    private val notifications: IncomingCallNotificationManager,
    private val ringtone: RingtonePlayer,
    private val events: RingingEventDispatcher,
    private val telecom: TelecomIntegration,
    private val notificationPermission: NotificationPermissionFlow,
    private val fullScreenIntentPermission: FullScreenIntentPermission,
) : MethodChannel.MethodCallHandler {

    /** The activity this engine is attached to, for the permission requests. */
    var activity: Activity? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            handle(call, result)
        } catch (error: Exception) {
            result.error("error", error.message, "")
        }
    }

    private fun handle(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "initData" -> {
                telecom.init(call.arguments as? Map<String, Any?>)
                result.success(null)
            }

            "showIncomingCall" -> {
                val data = callArgument(call).copy(from = "notification")
                context.sendBroadcast(
                    IncomingCallBroadcastReceiver.getIntentIncoming(
                        context,
                        CallPayloadMapper.toBundle(data),
                    ),
                )
                result.success(true)
            }

            "showMissCallNotification" -> {
                controller.showMissedCall(
                    CallPayloadMapper.toBundle(callArgument(call).copy(from = "notification")),
                )
                result.success(true)
            }

            "startCall" -> {
                context.sendBroadcast(
                    IncomingCallBroadcastReceiver.getIntentStart(
                        context,
                        CallPayloadMapper.toBundle(callArgument(call)),
                    ),
                )
                result.success(true)
            }

            "muteCall" -> {
                events.send(IncomingCallConstants.ACTION_CALL_TOGGLE_MUTE, mapArgument(call))
                result.success(true)
            }

            // The hold event follows once Telecom has held or resumed the call.
            "holdCall" -> {
                val args = mapArgument(call)
                (args["id"] as? String)?.let { callId ->
                    telecom.setOnHold(
                        callId,
                        args["isOnHold"] as? Boolean ?: true,
                    )
                }
                result.success(true)
            }

            // Answers whether Telecom routed the cid's calls to the endpoint; false without
            // Telecom or for an endpoint type it does not name.
            "requestAudioEndpoint" -> {
                val args = mapArgument(call)
                val callCid = args["cid"] as? String
                val type = AudioEndpointUtils.endpointTypeFromString(args["type"] as? String)
                if (callCid == null || type == null) {
                    result.success(false)
                } else {
                    telecom.requestEndpoint(callCid, type) { routed -> result.success(routed) }
                }
            }

            "isMuted" -> {
                val callId = idArgument(call)
                result.success(callId?.let { telecom.isMuted(it) } ?: false)
            }

            "endCall" -> {
                controller.endCall(callArgument(call).id)
                result.success(true)
            }

            "callConnected" -> {
                controller.callConnected(callArgument(call).id)
                result.success(true)
            }

            "endAllCalls" -> {
                controller.endAllCalls()
                result.success(true)
            }

            // Ends the ring of the cid's calls for the reason Dart gives; see DismissReason.
            "dismissRingingCall" -> {
                val reason = (call.arguments as? Map<*, *>)?.get("reason") as? String
                controller.dismissRingingCall(idArgument(call), DismissReason.fromWireName(reason))
                result.success(true)
            }

            "activeCalls" -> result.success(store.all().map(CallPayloadMapper::toStoredMap))

            "getDevicePushTokenVoIP" -> result.success("")

            "silenceEvents" -> {
                IncomingCallBroadcastReceiver.silenceEvents = call.arguments as? Boolean ?: false
                result.success(true)
            }

            "requestNotificationPermission" -> {
                notificationPermission.request(
                    activity,
                    mapArgument(call).filterValues { it != null } as Map<String, Any>,
                )
                result.success(true)
            }

            "canUseFullScreenIntent" -> result.success(fullScreenIntentPermission.canUse())

            "hideIncomingCall" -> {
                ringtone.stop()
                notifications.clearIncomingNotification(
                    CallPayloadMapper.toBundle(callArgument(call)),
                    false,
                )
                result.success(true)
            }

            "ensureFullScreenIntentPermission" -> {
                fullScreenIntentPermission.request(activity)
                result.success(true)
            }

            else -> result.notImplemented()
        }
    }

    /**
     * Runs the result of a permission request this engine's activity received. Returns true only
     * for the notification permission request this plugin made.
     */
    fun onRequestPermissionsResult(requestCode: Int, grantResults: IntArray): Boolean {
        if (requestCode != NotificationPermissionFlow.REQUEST_CODE) return false
        notificationPermission.onRequestPermissionsResult(activity, requestCode, grantResults)
        return true
    }

    /** The call the arguments describe; the default call without arguments. */
    private fun callArgument(call: MethodCall): RingingCall {
        val arguments = call.arguments ?: return CallPayloadMapper.fromArgs(emptyMap())
        require(arguments is Map<*, *>) { "${call.method} expects a map of call parameters" }
        return CallPayloadMapper.fromArgs(arguments as Map<String, Any?>)
    }

    /** The arguments as a map with String keys; empty when they are not a map. */
    private fun mapArgument(call: MethodCall): Map<String, Any?> = buildMap {
        (call.arguments as? Map<*, *>)?.forEach { (key, value) ->
            if (key is String) put(key, value)
        }
    }

    private fun idArgument(call: MethodCall) = (call.arguments as? Map<*, *>)?.get("id") as? String

    companion object {
        fun create(context: Context, components: RingingComponents) = PushMethodCallHandler(
            context = context,
            controller = components.controller,
            store = components.callStore,
            notifications = components.notifications,
            ringtone = components.ringtone,
            events = components.events,
            telecom = components.telecom,
            notificationPermission = components.notificationPermission,
            fullScreenIntentPermission = components.fullScreenIntentPermission,
        )
    }
}
