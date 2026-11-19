package io.getstream.video.flutter.stream_video_push_notification

import android.content.Context
import android.os.Looper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.StandardMethodCodec
import java.nio.ByteBuffer
import org.robolectric.Shadows.shadowOf

/** Forgets the plugin's process-wide instance, so each test attaches with its own context. */
internal fun resetPlugin() {
    StreamVideoPushNotificationPlugin::class.java.getDeclaredField("instance").apply {
        isAccessible = true
        set(null, null)
    }
}

/**
 * Stands in for one Flutter engine on the other end of the plugin's channels: it attaches the
 * plugin, listens on the event channel the way the Dart side does, and decodes what arrives.
 */
internal class FakeDartSide(context: Context) : BinaryMessenger {

    private val handlers = mutableMapOf<String, BinaryMessenger.BinaryMessageHandler>()
    private val events = mutableListOf<Map<String, Any?>>()

    init {
        StreamVideoPushNotificationPlugin.initSharedInstance(context, this)
        handlers.getValue(EVENTS).onMessage(encode(MethodCall("listen", null))) {}
    }

    override fun send(channel: String, message: ByteBuffer?) = send(channel, message, null)

    override fun send(channel: String, message: ByteBuffer?, callback: BinaryMessenger.BinaryReply?) {
        if (channel == EVENTS && message != null) {
            message.rewind()
            @Suppress("UNCHECKED_CAST")
            events += codec.decodeEnvelope(message) as Map<String, Any?>
        }
        callback?.reply(null)
    }

    override fun setMessageHandler(channel: String, handler: BinaryMessenger.BinaryMessageHandler?) {
        if (handler == null) handlers.remove(channel) else handlers[channel] = handler
    }

    /** The events received so far, each a map of `event` and `body`. */
    fun receivedEvents(): List<Map<String, Any?>> {
        shadowOf(Looper.getMainLooper()).idle()
        return events.toList()
    }

    /** Calls [method] on the plugin's method channel and returns what it answered. */
    fun invoke(method: String, arguments: Any? = null): Any? {
        var answer: ByteBuffer? = null
        handlers.getValue(METHODS).onMessage(encode(MethodCall(method, arguments))) { answer = it }
        val reply = answer ?: error("the plugin did not answer $method")
        reply.rewind()
        return codec.decodeEnvelope(reply)
    }

    private fun encode(call: MethodCall) = codec.encodeMethodCall(call).also { it.rewind() }

    private companion object {
        const val EVENTS = "stream_video_push_notification_events"
        const val METHODS = "stream_video_push_notification"
        val codec: StandardMethodCodec = StandardMethodCodec.INSTANCE
    }
}
