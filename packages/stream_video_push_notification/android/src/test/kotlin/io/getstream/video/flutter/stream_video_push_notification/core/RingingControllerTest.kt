package io.getstream.video.flutter.stream_video_push_notification.core

import android.content.Context
import android.os.Bundle
import android.telecom.DisconnectCause
import androidx.test.core.app.ApplicationProvider
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallBroadcastReceiver
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallConstants
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallNotificationManager
import io.getstream.video.flutter.stream_video_push_notification.telecom.StreamTelecomManager
import io.mockk.every
import io.mockk.mockk
import io.mockk.mockkObject
import io.mockk.unmockkObject
import io.mockk.verify
import io.mockk.verifyOrder
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner

/**
 * Pins each step of [RingingController] against an in-memory store, a mocked notification
 * manager and the Telecom manager with its calls recorded.
 */
@RunWith(RobolectricTestRunner::class)
class RingingControllerTest {

    private val context: Context get() = ApplicationProvider.getApplicationContext()

    private val store = InMemoryCallStore()
    private val notifications = mockk<IncomingCallNotificationManager>(relaxed = true)
    private val events = mutableListOf<Pair<String, Map<String, Any?>>>()
    private lateinit var controller: RingingController

    @Before
    fun createController() {
        mockkObject(StreamTelecomManager)
        IncomingCallBroadcastReceiver.silenceEvents = false
        controller = RingingController(context, store, notifications) { event, body ->
            events += event to body
        }
    }

    @After
    fun releaseTelecom() {
        unmockkObject(StreamTelecomManager)
        IncomingCallBroadcastReceiver.silenceEvents = false
    }

    private val call = RingingCall(id = CALL_ID, callerName = "Ada")
    private val bundle: Bundle get() = CallPayloadMapper.toBundle(call)

    private fun eventNames() = events.map { it.first }

    @Test
    fun `incoming registers with Telecom before showing, then reports and stores the call`() {
        val data = bundle

        controller.handle(IncomingCallConstants.ACTION_CALL_INCOMING, data)

        verifyOrder {
            StreamTelecomManager.registerIncomingCall(any(), call)
            notifications.showIncomingNotification(data)
        }
        assertEquals(listOf(IncomingCallConstants.ACTION_CALL_INCOMING), eventNames())
        assertEquals(listOf(call), store.all())
    }

    @Test
    fun `incoming still rings when the Telecom registration throws`() {
        every { StreamTelecomManager.registerIncomingCall(any(), any()) } throws
            IllegalStateException("telecom down")
        val data = bundle

        controller.handle(IncomingCallConstants.ACTION_CALL_INCOMING, data)

        verify { notifications.showIncomingNotification(data) }
        assertEquals(listOf(call), store.all())
    }

    @Test
    fun `start reports the call, stores it accepted and registers it as outgoing`() {
        controller.handle(IncomingCallConstants.ACTION_CALL_START, bundle)

        assertEquals(listOf(IncomingCallConstants.ACTION_CALL_START), eventNames())
        assertEquals(listOf(call.copy(isAccepted = true)), store.all())
        verify { StreamTelecomManager.registerOutgoingCall(any(), call) }
    }

    @Test
    fun `accept clears the ring as accepted, reports, stores accepted and answers Telecom`() {
        store.add(call)
        val data = bundle

        controller.handle(IncomingCallConstants.ACTION_CALL_ACCEPT, data)

        verify { notifications.clearIncomingNotification(data, true) }
        assertEquals(listOf(IncomingCallConstants.ACTION_CALL_ACCEPT), eventNames())
        assertEquals(true, store.byId(CALL_ID)?.isAccepted)
        verify { StreamTelecomManager.answer(any(), CALL_ID) }
    }

    @Test
    fun `decline clears the ring, reports, forgets the call and rejects it in Telecom`() {
        store.add(call)
        val data = bundle

        controller.handle(IncomingCallConstants.ACTION_CALL_DECLINE, data)

        verify { notifications.clearIncomingNotification(data, false) }
        assertEquals(listOf(IncomingCallConstants.ACTION_CALL_DECLINE), eventNames())
        assertNull(store.byId(CALL_ID))
        verify { StreamTelecomManager.disconnect(any(), CALL_ID, DisconnectCause.REJECTED) }
    }

    @Test
    fun `ended disconnects Telecom unless the system call is kept`() {
        store.add(call)
        controller.handle(IncomingCallConstants.ACTION_CALL_ENDED, bundle)

        verify { notifications.clearIncomingNotification(any(), false) }
        assertNull(store.byId(CALL_ID))
        verify(exactly = 1) {
            StreamTelecomManager.disconnect(any(), CALL_ID, DisconnectCause.LOCAL)
        }

        store.add(call)
        controller.handle(IncomingCallConstants.ACTION_CALL_ENDED, bundle, keepSystemCall = true)

        assertNull(store.byId(CALL_ID))
        verify(exactly = 1) { StreamTelecomManager.disconnect(any(), any(), any()) }
        assertEquals(
            listOf(
                IncomingCallConstants.ACTION_CALL_ENDED,
                IncomingCallConstants.ACTION_CALL_ENDED,
            ),
            eventNames(),
        )
    }

    @Test
    fun `timeout clears the ring, reports, forgets the call and misses it in Telecom`() {
        store.add(call)

        controller.handle(IncomingCallConstants.ACTION_CALL_TIMEOUT, bundle)

        verify { notifications.clearIncomingNotification(any(), false) }
        assertEquals(listOf(IncomingCallConstants.ACTION_CALL_TIMEOUT), eventNames())
        assertNull(store.byId(CALL_ID))
        verify { StreamTelecomManager.disconnect(any(), CALL_ID, DisconnectCause.MISSED) }
    }

    @Test
    fun `connected reports and activates the Telecom call`() {
        controller.handle(IncomingCallConstants.ACTION_CALL_CONNECTED, bundle)

        assertEquals(listOf(IncomingCallConstants.ACTION_CALL_CONNECTED), eventNames())
        verify { StreamTelecomManager.activate(any(), CALL_ID) }
    }

    @Test
    fun `callback clears the missed-call notification and reports`() {
        val data = bundle

        controller.handle(IncomingCallConstants.ACTION_CALL_CALLBACK, data)

        verify { notifications.clearMissCallNotification(data) }
        assertEquals(listOf(IncomingCallConstants.ACTION_CALL_CALLBACK), eventNames())
    }

    @Test
    fun `an event carries endedBySystem from the Bundle`() {
        val data = bundle.apply {
            putBoolean(IncomingCallConstants.EXTRA_CALL_ENDED_BY_SYSTEM, true)
        }

        controller.handle(IncomingCallConstants.ACTION_CALL_ENDED, data)

        assertEquals(true, events.single().second["endedBySystem"])
    }

    @Test
    fun `while events are silenced the step runs without reporting`() {
        IncomingCallBroadcastReceiver.silenceEvents = true

        controller.handle(IncomingCallConstants.ACTION_CALL_DECLINE, bundle)

        assertEquals(emptyList<String>(), eventNames())
        verify { StreamTelecomManager.disconnect(any(), CALL_ID, DisconnectCause.REJECTED) }
    }

    @Test
    fun `a step that throws skips the rest of that step only`() {
        every { notifications.clearIncomingNotification(any(), any()) } throws
            IllegalStateException("notification manager down")
        store.add(call)

        controller.handle(IncomingCallConstants.ACTION_CALL_DECLINE, bundle)
        controller.handle(IncomingCallConstants.ACTION_CALL_CONNECTED, bundle)

        assertEquals(listOf(IncomingCallConstants.ACTION_CALL_CONNECTED), eventNames())
        assertEquals(listOf(call), store.all())
    }

    @Test
    fun `endCall ends an accepted call and declines one that was not accepted`() {
        store.add(call.copy(isAccepted = true))
        store.add(RingingCall(id = "other"))

        controller.endCall(CALL_ID)
        controller.endCall("other")
        controller.endCall("unknown")

        assertEquals(
            listOf(
                IncomingCallConstants.ACTION_CALL_ENDED,
                IncomingCallConstants.ACTION_CALL_DECLINE,
            ),
            eventNames(),
        )
        verify { StreamTelecomManager.disconnect(any(), CALL_ID, DisconnectCause.LOCAL) }
        verify { StreamTelecomManager.disconnect(any(), "other", DisconnectCause.REJECTED) }
        assertEquals(emptyList<RingingCall>(), store.all())
    }

    @Test
    fun `callConnected reports a stored call and ignores an unknown one`() {
        store.add(call)

        controller.callConnected(CALL_ID)
        controller.callConnected("unknown")

        assertEquals(listOf(IncomingCallConstants.ACTION_CALL_CONNECTED), eventNames())
        verify(exactly = 1) { StreamTelecomManager.activate(any(), any()) }
    }

    @Test
    fun `endAllCalls ends every stored call, forgets them and sweeps Telecom`() {
        store.add(call.copy(isAccepted = true))
        store.add(RingingCall(id = "other"))

        controller.endAllCalls()

        assertEquals(
            listOf(
                IncomingCallConstants.ACTION_CALL_ENDED,
                IncomingCallConstants.ACTION_CALL_DECLINE,
            ),
            eventNames(),
        )
        assertEquals(emptyList<RingingCall>(), store.all())
        verify { StreamTelecomManager.disconnectAll(any(), DisconnectCause.LOCAL) }
    }

    @Test
    fun `dismissRingingCall answers and ends the ring of the cid's calls, keeping Telecom`() {
        store.add(RingingCall(id = "a", extra = mapOf("callCid" to "default:a")))
        store.add(RingingCall(id = "b", extra = mapOf("callCid" to "default:b")))

        controller.dismissRingingCall("default:a")

        verify { StreamTelecomManager.answer(any(), "a") }
        verify(exactly = 0) { StreamTelecomManager.answer(any(), "b") }
        verify(exactly = 0) { StreamTelecomManager.disconnect(any(), any(), any()) }
        assertEquals(listOf("b"), store.all().map { it.id })
    }

    @Test
    fun `dismissRingingCall with no matching cid dismisses every stored call`() {
        store.add(RingingCall(id = "a", extra = mapOf("callCid" to "default:a")))
        store.add(RingingCall(id = "b", extra = mapOf("callCid" to "default:b")))

        controller.dismissRingingCall("default:none")

        verify { StreamTelecomManager.answer(any(), "a") }
        verify { StreamTelecomManager.answer(any(), "b") }
        assertEquals(emptyList<RingingCall>(), store.all())
    }

    @Test
    fun `an unknown action does nothing`() {
        controller.handle("io.getstream.video.ACTION_UNKNOWN", bundle)

        assertEquals(emptyList<String>(), eventNames())
        assertEquals(emptyList<RingingCall>(), store.all())
    }

    private companion object {
        const val CALL_ID = "call-uuid"
    }
}

/** A [CallStore] in memory, with the same add semantics as [PrefsCallStore]. */
private class InMemoryCallStore : CallStore {
    private val calls = mutableListOf<RingingCall>()

    override fun add(call: RingingCall) {
        val index = calls.indexOfFirst { it.id == call.id }
        if (index >= 0) calls[index] = calls[index].copy(isAccepted = call.isAccepted)
        else calls += call
    }

    override fun remove(id: String) {
        calls.removeAll { it.id == id }
    }

    override fun removeAll() = calls.clear()

    override fun byId(id: String) = calls.firstOrNull { it.id == id }

    override fun byCallCid(callCid: String) = calls.filter { it.callCid == callCid }

    override fun all(): List<RingingCall> = calls.toList()
}
