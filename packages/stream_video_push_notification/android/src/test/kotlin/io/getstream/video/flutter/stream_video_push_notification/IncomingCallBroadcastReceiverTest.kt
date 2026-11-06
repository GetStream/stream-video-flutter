package io.getstream.video.flutter.stream_video_push_notification

import android.app.Application
import android.app.Notification
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.os.Looper
import android.telecom.DisconnectCause
import androidx.test.core.app.ApplicationProvider
import com.fasterxml.jackson.databind.JsonNode
import com.fasterxml.jackson.databind.ObjectMapper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.StandardMethodCodec
import io.getstream.video.flutter.stream_video_push_notification.telecom.StreamTelecomManager
import io.mockk.mockkObject
import io.mockk.unmockkObject
import io.mockk.verify
import java.io.File
import java.nio.ByteBuffer
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.Robolectric
import org.robolectric.RobolectricTestRunner
import org.robolectric.Shadows.shadowOf
import org.robolectric.android.controller.ServiceController

/**
 * Pins what the broadcast receiver does for each call action: the notification it shows or
 * clears, the event Dart receives, the active-calls list Dart reads back, the ringing service it
 * starts or stops, and the Telecom call it registers or ends.
 *
 * Everything Dart sees is observed through the plugin's real method and event channels, with a
 * fake engine on the other end. The receiver is driven with the intents the plugin and the
 * notifications send it.
 */
@RunWith(RobolectricTestRunner::class)
class IncomingCallBroadcastReceiverTest {

    private val context: Application get() = ApplicationProvider.getApplicationContext()
    private val notifications: NotificationManager
        get() = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    private lateinit var dart: FakeDartSide
    private var ringingService: ServiceController<IncomingCallNotificationService>? = null

    @Before
    fun attachPlugin() {
        resetPlugin()
        IncomingCallBroadcastReceiver.silenceEvents = false
        dart = FakeDartSide(context)
        // A spy: the real Telecom code runs, and is off at this SDK level.
        mockkObject(StreamTelecomManager)
    }

    @After
    fun detachPlugin() {
        ringingService?.destroy()
        ringingService = null
        unmockkObject(StreamTelecomManager)
        IncomingCallBroadcastReceiver.silenceEvents = false
        resetPlugin()
    }

    private fun data(vararg extraTopLevel: Pair<String, Any?>) = Data(
        mapOf(
            "id" to CALL_ID,
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
                "missedCallNotification" to mapOf("id" to MISSED_ID, "subtitle" to "Missed"),
                "incomingCallNotification" to mapOf("textAccept" to "Pick up"),
            ),
            *extraTopLevel,
        ),
    )

    /** Delivers [intent] to a receiver created now, as the system creates one per broadcast. */
    private fun receive(intent: Intent) {
        IncomingCallBroadcastReceiver().onReceive(context, intent)
        shadowOf(Looper.getMainLooper()).idle()
    }

    private fun incoming(bundle: Bundle = data().toBundle()) =
        receive(IncomingCallBroadcastReceiver.getIntentIncoming(context, bundle))

    /** Creates the ringing service as the system would, so a stop request can be observed. */
    private fun runRingingService() {
        ringingService = Robolectric.buildService(IncomingCallNotificationService::class.java)
            .create()
    }

    private fun ringingServiceWasStopped() =
        shadowOf(context).nextStoppedService?.component?.className ==
            IncomingCallNotificationService::class.java.name

    private fun shownNotificationIds() = notifications.activeNotifications.map { it.id }

    private fun eventNames() = dart.receivedEvents().map { it["event"] }

    @Suppress("UNCHECKED_CAST")
    private fun lastEventBody() = dart.receivedEvents().last()["body"] as Map<String, Any?>

    @Suppress("UNCHECKED_CAST")
    private fun activeCalls() = dart.invoke("activeCalls") as List<Map<String, Any?>>

    @Test
    fun `an incoming call is shown, reported to Dart and stored`() {
        incoming()

        assertEquals(listOf(CALL_ID.hashCode()), shownNotificationIds())
        assertEquals(listOf(IncomingCallConstants.ACTION_CALL_INCOMING), eventNames())
        assertEquals(listOf(CALL_ID), activeCalls().map { it["id"] })
        assertEquals(false, activeCalls().single()["isAccepted"])
        verify { StreamTelecomManager.registerIncomingCall(any(), match { it.id == CALL_ID }) }
    }

    @Test
    fun `the event body is the shared Android payload`() {
        incoming()

        assertMatchesFixture(lastEventBody(), "android_call_event.json")
    }

    @Test
    fun `accepting starts the ringing service, reports it and marks the call accepted`() {
        incoming()

        receive(IncomingCallBroadcastReceiver.getIntentAccept(context, data().toBundle()))

        val started = shadowOf(context).nextStartedService
        assertEquals(IncomingCallNotificationService::class.java.name, started.component?.className)
        assertEquals(IncomingCallConstants.ACTION_CALL_ACCEPT, started.action)
        assertEquals(IncomingCallConstants.ACTION_CALL_ACCEPT, eventNames().last())
        assertEquals(true, activeCalls().single()["isAccepted"])
        verify { StreamTelecomManager.answer(any(), CALL_ID) }
    }

    @Test
    fun `declining clears the ring, reports it and forgets the call`() {
        incoming()
        runRingingService()

        receive(IncomingCallBroadcastReceiver.getIntentDecline(context, data().toBundle()))

        assertEquals(emptyList<Int>(), shownNotificationIds())
        assertTrue(ringingServiceWasStopped())
        assertTrue(fullScreenActivityWasToldToClose())
        assertEquals(IncomingCallConstants.ACTION_CALL_DECLINE, eventNames().last())
        assertEquals(emptyList<Any?>(), activeCalls())
        verify { StreamTelecomManager.disconnect(any(), CALL_ID, DisconnectCause.REJECTED) }
    }

    @Test
    fun `ending clears the ring, reports it and disconnects Telecom`() {
        incoming()
        runRingingService()

        receive(IncomingCallBroadcastReceiver.getIntentEnded(context, data().toBundle()))

        assertEquals(emptyList<Int>(), shownNotificationIds())
        assertTrue(ringingServiceWasStopped())
        assertTrue(fullScreenActivityWasToldToClose())
        assertEquals(IncomingCallConstants.ACTION_CALL_ENDED, eventNames().last())
        assertEquals(emptyList<Any?>(), activeCalls())
        verify { StreamTelecomManager.disconnect(any(), CALL_ID, DisconnectCause.LOCAL) }
    }

    @Test
    fun `ending with keepSystemCall clears the ring but keeps the Telecom call`() {
        incoming()

        receive(
            IncomingCallBroadcastReceiver.getIntentEnded(
                context,
                data().toBundle(),
                keepSystemCall = true,
            ),
        )

        assertEquals(emptyList<Int>(), shownNotificationIds())
        assertEquals(IncomingCallConstants.ACTION_CALL_ENDED, eventNames().last())
        assertEquals(emptyList<Any?>(), activeCalls())
        verify(exactly = 0) { StreamTelecomManager.disconnect(any(), any(), any()) }
    }

    @Test
    fun `an end reported by the system reaches Dart as endedBySystem`() {
        incoming()
        val bundle = data().toBundle().apply {
            putBoolean(IncomingCallConstants.EXTRA_CALL_ENDED_BY_SYSTEM, true)
        }

        receive(IncomingCallBroadcastReceiver.getIntentEnded(context, bundle))

        assertEquals(true, lastEventBody()["endedBySystem"])
    }

    @Test
    fun `a timeout clears the ring, reports it and disconnects Telecom as missed`() {
        incoming()
        runRingingService()

        receive(IncomingCallBroadcastReceiver.getIntentTimeout(context, data().toBundle()))

        assertEquals(emptyList<Int>(), shownNotificationIds())
        assertTrue(ringingServiceWasStopped())
        assertEquals(IncomingCallConstants.ACTION_CALL_TIMEOUT, eventNames().last())
        assertEquals(emptyList<Any?>(), activeCalls())
        verify { StreamTelecomManager.disconnect(any(), CALL_ID, DisconnectCause.MISSED) }
    }

    @Test
    fun `clearing a call that no longer owns the ring leaves the ringing service running`() {
        incoming()
        incoming(data("id" to OTHER_CALL_ID).toBundle())
        runRingingService()

        receive(IncomingCallBroadcastReceiver.getIntentDecline(context, data().toBundle()))

        assertEquals(listOf(OTHER_CALL_ID.hashCode()), shownNotificationIds())
        assertFalse(ringingServiceWasStopped())

        receive(
            IncomingCallBroadcastReceiver.getIntentDecline(
                context,
                data("id" to OTHER_CALL_ID).toBundle(),
            ),
        )

        assertEquals(emptyList<Int>(), shownNotificationIds())
        assertTrue(ringingServiceWasStopped())
    }

    @Test
    fun `connected is reported and activates the Telecom call`() {
        receive(IncomingCallBroadcastReceiver.getIntentConnected(context, data().toBundle()))

        assertEquals(listOf(IncomingCallConstants.ACTION_CALL_CONNECTED), eventNames())
        verify { StreamTelecomManager.activate(any(), CALL_ID) }
    }

    @Test
    fun `a call back clears the missed-call notification and is reported`() {
        notifications.notify(MISSED_ID, Notification())

        receive(IncomingCallBroadcastReceiver.getIntentCallback(context, data().toBundle()))

        assertEquals(emptyList<Int>(), shownNotificationIds())
        assertEquals(listOf(IncomingCallConstants.ACTION_CALL_CALLBACK), eventNames())
    }

    @Test
    fun `starting an outgoing call starts the service, reports it and stores it accepted`() {
        receive(IncomingCallBroadcastReceiver.getIntentStart(context, data().toBundle()))

        val started = shadowOf(context).nextStartedService
        assertEquals(IncomingCallConstants.ACTION_CALL_START, started.action)
        assertEquals(listOf(IncomingCallConstants.ACTION_CALL_START), eventNames())
        assertEquals(true, activeCalls().single()["isAccepted"])
        verify { StreamTelecomManager.registerOutgoingCall(any(), match { it.id == CALL_ID }) }
    }

    @Test
    fun `an intent without call data is ignored`() {
        receive(
            Intent(context, IncomingCallBroadcastReceiver::class.java).apply {
                action = "${context.packageName}.${IncomingCallConstants.ACTION_CALL_INCOMING}"
            },
        )

        assertEquals(emptyList<Int>(), shownNotificationIds())
        assertEquals(emptyList<Any?>(), eventNames())
        assertEquals(emptyList<Any?>(), activeCalls())
    }

    @Test
    fun `while events are silenced nothing reaches Dart and the rest still happens`() {
        IncomingCallBroadcastReceiver.silenceEvents = true

        incoming()

        assertEquals(emptyList<Any?>(), eventNames())
        assertEquals(listOf(CALL_ID.hashCode()), shownNotificationIds())
        assertEquals(listOf(CALL_ID), activeCalls().map { it["id"] })
    }

    @Test
    fun `a bundle without the keys reaches Dart with the receiver's own defaults`() {
        // Current behaviour, pinned: here `isImportant` defaults to true and `duration` to 0,
        // while Data defaults them to false and 30000.
        receive(IncomingCallBroadcastReceiver.getIntentDecline(context, Bundle()))

        val body = lastEventBody()
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

    private fun fullScreenActivityWasToldToClose() = shadowOf(context).broadcastIntents.any {
        it.action == "${context.packageName}.io.getstream.video.ACTION_ENDED_CALL_INCOMING"
    }

    /** Compares [body] with the fixture both sides of the channel test against. */
    private fun assertMatchesFixture(body: Map<String, Any?>, fixture: String) {
        val file = File(FIXTURES, fixture)
        assertTrue("no fixture at ${file.absolutePath}", file.exists())

        val mapper = ObjectMapper()
        val expected = mapper.readTree(file)
        val actual = mapper.valueToTree<JsonNode>(body)
        // The codec keeps Int and Long apart; JSON does not.
        val numbersByValue = Comparator<JsonNode> { a, b ->
            when {
                a.isNumber && b.isNumber -> a.decimalValue().compareTo(b.decimalValue())
                a == b -> 0
                else -> 1
            }
        }
        assertTrue(
            "the event body drifted from $fixture\nexpected: $expected\nactual:   $actual",
            expected.equals(numbersByValue, actual),
        )
    }

    /** Forgets the plugin's process-wide instance, so each test attaches with its own context. */
    private fun resetPlugin() {
        StreamVideoPushNotificationPlugin::class.java.getDeclaredField("instance").apply {
            isAccessible = true
            set(null, null)
        }
    }

    private companion object {
        const val CALL_ID = "call-uuid"
        const val OTHER_CALL_ID = "other-call-uuid"
        const val MISSED_ID = 7

        /** Shared with the Dart tests, relative to the module directory the tests run in. */
        val FIXTURES = File("../test/fixtures/ringing_events")
    }
}

/**
 * Stands in for one Flutter engine on the other end of the plugin's channels: it attaches the
 * plugin, listens on the event channel the way the Dart side does, and decodes what arrives.
 */
private class FakeDartSide(context: Context) : BinaryMessenger {

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
