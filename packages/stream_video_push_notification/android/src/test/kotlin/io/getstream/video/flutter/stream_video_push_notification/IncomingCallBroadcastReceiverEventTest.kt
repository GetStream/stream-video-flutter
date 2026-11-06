package io.getstream.video.flutter.stream_video_push_notification

import android.os.Bundle
import io.mockk.every
import io.mockk.just
import io.mockk.mockkObject
import io.mockk.runs
import io.mockk.slot
import io.mockk.unmockkObject
import io.mockk.verify
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner

/**
 * Pins the shape of the event body the receiver sends to Dart for the call events
 * (`ACTION_CALL_INCOMING`, `ACCEPT`, `DECLINE`, `ENDED`, ...): the top-level keys, the `android`
 * section, and the defaults a bundle without the keys produces. This is the Android half of the
 * payload `CallData.fromJson` reads on the Dart side.
 */
@RunWith(RobolectricTestRunner::class)
class IncomingCallBroadcastReceiverEventTest {

    private val sentEvent = slot<String>()
    private val sentBody = slot<Map<String, Any?>>()

    @Before
    fun captureEvents() {
        mockkObject(StreamVideoPushNotificationPlugin.Companion)
        every { StreamVideoPushNotificationPlugin.sendEvent(capture(sentEvent), capture(sentBody)) } just runs
        IncomingCallBroadcastReceiver.silenceEvents = false
    }

    @After
    fun releaseEvents() {
        unmockkObject(StreamVideoPushNotificationPlugin.Companion)
        IncomingCallBroadcastReceiver.silenceEvents = false
    }

    private fun data() = Data(
        mapOf(
            "id" to "call-uuid",
            "callerName" to "Ada",
            "handle" to "ada",
            "type" to 1,
            "duration" to 15000,
            "extra" to hashMapOf<String, Any?>("callCid" to "default:ada"),
            "android" to hashMapOf<String, Any?>(
                "ringtonePath" to "ring.mp3",
                "defaultAvatar" to "avatar.png",
                "avatar" to "ada.png",
                "isImportant" to true,
                "missedCallNotification" to mapOf("id" to 7, "subtitle" to "Missed"),
                "incomingCallNotification" to mapOf("textAccept" to "Pick up"),
            ),
        ),
    )

    @Test
    fun `forwards the call fields the Dart side reads`() {
        IncomingCallBroadcastReceiver().sendEventFlutter(
            IncomingCallConstants.ACTION_CALL_INCOMING,
            data().toBundle(),
        )

        assertEquals(IncomingCallConstants.ACTION_CALL_INCOMING, sentEvent.captured)
        val body = sentBody.captured
        assertEquals("call-uuid", body["id"])
        assertEquals("Ada", body["callerName"])
        assertEquals("ada.png", body["avatar"])
        // The handle travels under `number`.
        assertEquals("ada", body["number"])
        assertEquals(1, body["type"])
        assertEquals(15000L, body["duration"])
        assertEquals(false, body["endedBySystem"])
        @Suppress("UNCHECKED_CAST")
        val extra = body["extra"] as Map<String, Any?>
        assertEquals("default:ada", extra["callCid"])
    }

    @Test
    fun `forwards the android section with its nested notification settings`() {
        IncomingCallBroadcastReceiver().sendEventFlutter(
            IncomingCallConstants.ACTION_CALL_ACCEPT,
            data().toBundle(),
        )

        @Suppress("UNCHECKED_CAST")
        val android = sentBody.captured["android"] as Map<String, Any?>
        assertEquals("ring.mp3", android["ringtonePath"])
        assertEquals("avatar.png", android["defaultAvatar"])
        assertEquals(true, android["isImportant"])
        assertEquals(false, android["isBot"])
        @Suppress("UNCHECKED_CAST")
        val missed = android["missedCallNotification"] as Map<String, Any?>
        assertEquals(7, missed["id"])
        assertEquals("Missed", missed["subtitle"])
        @Suppress("UNCHECKED_CAST")
        val incoming = android["incomingCallNotification"] as Map<String, Any?>
        assertEquals("Pick up", incoming["textAccept"])
    }

    @Test
    fun `endedBySystem is forwarded when the bundle carries it`() {
        val bundle = data().toBundle().apply {
            putBoolean(IncomingCallConstants.EXTRA_CALL_ENDED_BY_SYSTEM, true)
        }

        IncomingCallBroadcastReceiver().sendEventFlutter(IncomingCallConstants.ACTION_CALL_ENDED, bundle)

        assertEquals(true, sentBody.captured["endedBySystem"])
    }

    @Test
    fun `a bundle without the keys produces the receiver's own defaults`() {
        // Current behaviour, pinned: `isImportant` defaults to true here although Data defaults it
        // to false, and `duration` to 0 although Data defaults it to 30000 (C-2 of FLU-1197).
        IncomingCallBroadcastReceiver().sendEventFlutter(IncomingCallConstants.ACTION_CALL_DECLINE, Bundle())

        val body = sentBody.captured
        assertEquals("", body["id"])
        assertEquals(0, body["type"])
        assertEquals(0L, body["duration"])
        @Suppress("UNCHECKED_CAST")
        val android = body["android"] as Map<String, Any?>
        assertEquals(true, android["isImportant"])
        @Suppress("UNCHECKED_CAST")
        val missed = android["missedCallNotification"] as Map<String, Any?>
        assertEquals(0, missed["id"])
        assertEquals(false, missed["showNotification"])
    }

    @Test
    fun `nothing is sent while events are silenced`() {
        IncomingCallBroadcastReceiver.silenceEvents = true

        IncomingCallBroadcastReceiver().sendEventFlutter(IncomingCallConstants.ACTION_CALL_INCOMING, data().toBundle())

        assertFalse(sentEvent.isCaptured)
        verify(exactly = 0) { StreamVideoPushNotificationPlugin.sendEvent(any(), any()) }
    }

    @Test
    fun `the same body is sent for every call event name`() {
        for (event in listOf(
            IncomingCallConstants.ACTION_CALL_INCOMING,
            IncomingCallConstants.ACTION_CALL_START,
            IncomingCallConstants.ACTION_CALL_ACCEPT,
            IncomingCallConstants.ACTION_CALL_DECLINE,
            IncomingCallConstants.ACTION_CALL_ENDED,
            IncomingCallConstants.ACTION_CALL_TIMEOUT,
            IncomingCallConstants.ACTION_CALL_CONNECTED,
            IncomingCallConstants.ACTION_CALL_CALLBACK,
        )) {
            IncomingCallBroadcastReceiver().sendEventFlutter(event, data().toBundle())
            assertEquals(event, sentEvent.captured)
            assertTrue(sentBody.captured.containsKey("id"))
            assertTrue(sentBody.captured.containsKey("android"))
        }
    }
}
