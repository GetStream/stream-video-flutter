package io.getstream.video.flutter.stream_video_push_notification.channel

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel
import java.util.concurrent.CopyOnWriteArraySet

/**
 * Sends ringing events to every attached Flutter engine's event channel.
 *
 * One per process. Each engine attaches its own [EngineSink] and detaches it with the engine; an
 * event reaches the sinks Dart is listening on, on the main thread.
 */
internal class RingingEventDispatcher {

    private val sinks = CopyOnWriteArraySet<EngineSink>()

    /** A new sink for one engine's event channel, which gets every event from now on. */
    fun attach(): EngineSink = EngineSink().also { sinks += it }

    /** Stops sending to [sink]. */
    fun detach(sink: EngineSink) {
        sinks -= sink
        sink.close()
    }

    /** Sends [event] with [body] to every attached sink. */
    fun send(event: String, body: Map<String, Any?>) {
        val message = mapOf("event" to event, "body" to body)
        sinks.forEach { it.send(message) }
    }

    /** The event channel handler of one engine. */
    class EngineSink internal constructor() : EventChannel.StreamHandler {

        @Volatile
        private var eventSink: EventChannel.EventSink? = null

        private val mainHandler = Handler(Looper.getMainLooper())

        override fun onListen(arguments: Any?, sink: EventChannel.EventSink) {
            eventSink = sink
        }

        override fun onCancel(arguments: Any?) {
            eventSink = null
        }

        internal fun send(message: Map<String, Any?>) {
            mainHandler.post { eventSink?.success(message) }
        }

        internal fun close() {
            eventSink = null
        }
    }
}
