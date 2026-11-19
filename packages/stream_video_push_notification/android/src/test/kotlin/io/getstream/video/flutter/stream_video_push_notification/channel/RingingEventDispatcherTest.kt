package io.getstream.video.flutter.stream_video_push_notification.channel

import android.os.Looper
import io.flutter.plugin.common.EventChannel
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.Shadows.shadowOf

/** Pins which engine sinks an event reaches. */
@RunWith(RobolectricTestRunner::class)
class RingingEventDispatcherTest {

    private val dispatcher = RingingEventDispatcher()

    private class RecordingSink : EventChannel.EventSink {
        val received = mutableListOf<Any?>()
        override fun success(event: Any?) {
            received += event
        }
        override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) = Unit
        override fun endOfStream() = Unit
    }

    private fun listening(): RecordingSink {
        val recorder = RecordingSink()
        dispatcher.attach().onListen(null, recorder)
        return recorder
    }

    private fun send() {
        dispatcher.send("event", mapOf("id" to "call-1"))
        shadowOf(Looper.getMainLooper()).idle()
    }

    @Test
    fun `an event reaches every listening engine`() {
        val first = listening()
        val second = listening()

        send()

        val expected = mapOf("event" to "event", "body" to mapOf("id" to "call-1"))
        assertEquals(listOf(expected), first.received)
        assertEquals(listOf(expected), second.received)
    }

    @Test
    fun `a detached engine gets nothing, also for an event sent before it detached`() {
        val kept = listening()
        val detachedRecorder = RecordingSink()
        val detached = dispatcher.attach().apply { onListen(null, detachedRecorder) }

        dispatcher.send("before", emptyMap())
        dispatcher.detach(detached)
        send()

        assertEquals(emptyList<Any?>(), detachedRecorder.received)
        assertEquals(2, kept.received.size)
    }

    @Test
    fun `an engine that is not listening gets nothing`() {
        val recorder = RecordingSink()
        val sink = dispatcher.attach()
        sink.onListen(null, recorder)
        sink.onCancel(null)

        send()

        assertEquals(emptyList<Any?>(), recorder.received)
    }
}
