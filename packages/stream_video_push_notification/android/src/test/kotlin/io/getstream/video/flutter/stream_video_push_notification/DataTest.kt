package io.getstream.video.flutter.stream_video_push_notification

import android.os.Bundle
import androidx.test.core.app.ApplicationProvider
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner

/**
 * Pins how [Data] is built from the method-channel map, how it survives a Bundle round trip, and
 * how it is persisted as the active-calls list. The defaults that differ between the constructor
 * and [Data.fromBundle] are asserted as they are, with the differing value named in the test.
 */
@RunWith(RobolectricTestRunner::class)
class DataTest {

    private val context get() = ApplicationProvider.getApplicationContext<android.content.Context>()

    private fun args(android: Map<String, Any?>? = null, vararg top: Pair<String, Any?>) =
        mutableMapOf<String, Any?>(
            "id" to "call-uuid",
            "callerName" to "Ada",
            "handle" to "ada",
            "type" to 1,
            "duration" to 15000,
            "extra" to hashMapOf<String, Any?>("callCid" to "default:ada"),
            "headers" to hashMapOf<String, Any?>("Authorization" to "token"),
        ).apply {
            if (android != null) put("android", HashMap(android))
            putAll(top)
        }

    // Construction from the method-channel map.

    @Test
    fun `reads the call fields and converts an Int duration to Long`() {
        val data = Data(args())

        assertEquals("call-uuid", data.id)
        assertEquals("call-uuid", data.uuid)
        assertEquals("Ada", data.callerName)
        assertEquals("ada", data.handle)
        assertEquals(1, data.type)
        assertEquals(15000L, data.duration)
        assertEquals("default:ada", data.extra["callCid"])
        assertEquals("token", data.headers["Authorization"])
        assertFalse(data.isAccepted)
    }

    @Test
    fun `defaults when the map is empty`() {
        val data = Data(emptyMap())

        assertEquals("", data.id)
        assertEquals(0, data.type)
        assertEquals(30000L, data.duration)
        assertEquals("", data.ringtonePath)
        assertNull(data.missedNotificationId)
        assertEquals(1, data.missedNotificationCount)
        assertTrue(data.showCallbackButton)
        assertTrue(data.isShowMissedCallNotification)
        assertTrue(data.showFullScreenOnLockScreen)
        assertFalse(data.isImportant)
        assertFalse(data.fullScreenShowLogo)
        assertEquals("", data.fullScreenBackgroundColor)
    }

    @Test
    fun `reads the android section when present and the top level otherwise`() {
        val nested = Data(
            args(
                android = mapOf(
                    "ringtonePath" to "ring.mp3",
                    "defaultAvatar" to "avatar.png",
                    "isImportant" to true,
                    "missedCallNotification" to mapOf(
                        "id" to 7,
                        "count" to 3,
                        "subtitle" to "Missed",
                        "showCallbackButton" to false,
                    ),
                    "incomingCallNotification" to mapOf(
                        "fullScreenShowLogo" to true,
                        "textAccept" to "Pick up",
                        "showCallHandle" to true,
                    ),
                ),
            ),
        )
        assertEquals("ring.mp3", nested.ringtonePath)
        assertEquals("avatar.png", nested.defaultAvatar)
        assertTrue(nested.isImportant)
        assertEquals(7, nested.missedNotificationId)
        assertEquals(3, nested.missedNotificationCount)
        assertEquals("Missed", nested.missedNotificationSubtitle)
        assertFalse(nested.showCallbackButton)
        assertTrue(nested.fullScreenShowLogo)
        assertEquals("Pick up", nested.textAccept)
        assertTrue(nested.showCallHandle)

        val flat = Data(args(top = arrayOf("ringtonePath" to "flat.mp3", "isBot" to true)))
        assertEquals("flat.mp3", flat.ringtonePath)
        assertTrue(flat.isBot)
    }

    @Test
    fun `equality and hash are by id only`() {
        val a = Data(args())
        val b = Data(args(top = arrayOf("callerName" to "Someone else")))
        val c = Data(args(top = arrayOf("id" to "other")))

        assertEquals(a, b)
        assertEquals(a.hashCode(), b.hashCode())
        assertFalse(a == c)
    }

    // Bundle round trip.

    @Test
    fun `a full Data survives the Bundle round trip`() {
        val original = Data(
            args(
                android = mapOf(
                    "ringtonePath" to "ring.mp3",
                    "defaultAvatar" to "avatar.png",
                    "avatar" to "ada.png",
                    "incomingCallNotificationChannelName" to "Incoming",
                    "missedCallNotification" to mapOf("id" to 7, "subtitle" to "Missed"),
                    "incomingCallNotification" to mapOf("textAccept" to "Pick up"),
                ),
            ),
        ).apply { from = "notification" }

        val restored = Data.fromBundle(original.toBundle())

        assertEquals(original.id, restored.id)
        assertEquals(original.callerName, restored.callerName)
        assertEquals(original.handle, restored.handle)
        assertEquals(original.avatar, restored.avatar)
        assertEquals(original.defaultAvatar, restored.defaultAvatar)
        assertEquals(original.type, restored.type)
        assertEquals(original.duration, restored.duration)
        assertEquals(original.textAccept, restored.textAccept)
        assertEquals(original.ringtonePath, restored.ringtonePath)
        assertEquals(original.missedNotificationId, restored.missedNotificationId)
        assertEquals(original.missedNotificationSubtitle, restored.missedNotificationSubtitle)
        assertEquals(original.showCallbackButton, restored.showCallbackButton)
        assertEquals(original.incomingCallNotificationChannelName, restored.incomingCallNotificationChannelName)
        assertEquals(original.from, restored.from)
        assertEquals(original.extra, restored.extra)
        assertEquals(original.headers, restored.headers)
        assertEquals(original.showFullScreenOnLockScreen, restored.showFullScreenOnLockScreen)
    }

    @Test
    fun `fromBundle defaults differ from the constructor defaults for a bundle without the keys`() {
        // Current behaviour, not a target. A bundle that only carries the two serializable maps
        // (which fromBundle requires) yields other defaults than Data(emptyMap()).
        val bundle = Bundle().apply {
            putSerializable(IncomingCallConstants.EXTRA_CALL_EXTRA, HashMap<String, Any?>())
            putSerializable(IncomingCallConstants.EXTRA_CALL_HEADERS, HashMap<String, Any?>())
        }

        val restored = Data.fromBundle(bundle)

        // Constructor: true. Bundle: false.
        assertFalse(restored.showCallbackButton)
        // Constructor: null. Bundle: 0, because getInt has no null form.
        assertEquals(0, restored.missedNotificationId)
        // Constructor: null. Bundle: "".
        assertEquals("", restored.missedNotificationSubtitle)
        assertEquals("", restored.missedNotificationCallbackText)
        // Same on both sides.
        assertEquals(30000L, restored.duration)
        assertTrue(restored.isShowMissedCallNotification)
        assertTrue(restored.showFullScreenOnLockScreen)
        assertFalse(restored.isImportant)
    }

    @Test(expected = NullPointerException::class)
    fun `fromBundle throws on a bundle without the extra map`() {
        // Current behaviour: the unchecked cast of a missing serializable.
        Data.fromBundle(Bundle())
    }

    // Persistence as the active-calls list.

    @Test
    fun `the active calls list round-trips through SharedPreferences`() {
        removeAllCalls(context)
        val data = Data(args(android = mapOf("ringtonePath" to "ring.mp3")))

        addCall(context, data, isAccepted = true)
        val restored = getDataActiveCalls(context)

        assertEquals(1, restored.size)
        assertEquals("call-uuid", restored.single().id)
        assertEquals("Ada", restored.single().callerName)
        assertEquals("ring.mp3", restored.single().ringtonePath)
        assertEquals("default:ada", restored.single().extra["callCid"])
        assertTrue(restored.single().isAccepted)
    }

    @Test
    fun `adding a call with the same id updates its accepted flag instead of duplicating it`() {
        removeAllCalls(context)
        val data = Data(args())

        addCall(context, data, isAccepted = false)
        addCall(context, Data(args(top = arrayOf("callerName" to "Renamed"))), isAccepted = true)
        val restored = getDataActiveCalls(context)

        assertEquals(1, restored.size)
        assertTrue(restored.single().isAccepted)
        // The first entry is kept; only the flag changed.
        assertEquals("Ada", restored.single().callerName)
    }

    @Test
    fun `the list handed to Flutter carries the id and the call cid`() {
        removeAllCalls(context)
        addCall(context, Data(args()))

        val forFlutter = getDataActiveCallsForFlutter(context)

        assertEquals("call-uuid", forFlutter.single()["id"])
        @Suppress("UNCHECKED_CAST")
        val extra = forFlutter.single()["extra"] as Map<String, Any?>
        assertEquals("default:ada", extra["callCid"])
    }

    @Test
    fun `an active call stored with keys Data no longer declares still reads`() {
        // isOnHold, audioRoute and isMuted, as earlier versions wrote them.
        putString(
            context,
            "ACTIVE_CALLS",
            """[{"id":"call-uuid","callerName":"Ada","extra":{"callCid":"default:ada"},""" +
                """"isAccepted":true,"isOnHold":false,"audioRoute":1,"isMuted":false}]""",
        )

        val restored = getDataActiveCalls(context)

        assertEquals("call-uuid", restored.single().id)
        assertEquals("Ada", restored.single().callerName)
        assertEquals("default:ada", restored.single().extra["callCid"])
        assertTrue(restored.single().isAccepted)
        removeAllCalls(context)
    }

    @Test
    fun `removing a call and removing all calls empty the list`() {
        removeAllCalls(context)
        addCall(context, Data(args()))
        addCall(context, Data(args(top = arrayOf("id" to "other"))))

        removeCall(context, Data(args()))
        assertEquals(listOf("other"), getDataActiveCalls(context).map { it.id })

        removeAllCalls(context)
        assertTrue(getDataActiveCalls(context).isEmpty())
    }
}
