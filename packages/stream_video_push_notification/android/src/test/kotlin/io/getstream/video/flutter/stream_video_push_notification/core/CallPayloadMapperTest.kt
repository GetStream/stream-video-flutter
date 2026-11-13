package io.getstream.video.flutter.stream_video_push_notification.core

import android.os.Bundle
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallConstants
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner

/**
 * Pins every conversion of [CallPayloadMapper]: from the method-channel map, through a Bundle,
 * into an event body and through the stored active-calls entry.
 */
@RunWith(RobolectricTestRunner::class)
class CallPayloadMapperTest {

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

    // Method-channel map.

    @Test
    fun `reads the call fields and converts an Int duration to Long`() {
        val call = CallPayloadMapper.fromArgs(args())

        assertEquals("call-uuid", call.id)
        assertEquals("Ada", call.callerName)
        assertEquals("ada", call.handle)
        assertEquals(1, call.type)
        assertEquals(15000L, call.duration)
        assertEquals("default:ada", call.callCid)
        assertEquals("token", call.headers["Authorization"])
        assertFalse(call.isAccepted)
    }

    @Test
    fun `an empty map gives the call defaults`() {
        assertEquals(RingingCall(), CallPayloadMapper.fromArgs(emptyMap()))
    }

    @Test
    fun `reads the android section when present and the top level otherwise`() {
        val nested = CallPayloadMapper.fromArgs(
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
        assertEquals(true, nested.isImportant)
        assertEquals(7, nested.missedNotificationId)
        assertEquals(3, nested.missedNotificationCount)
        assertEquals("Missed", nested.missedNotificationSubtitle)
        assertEquals(false, nested.showCallbackButton)
        assertEquals(true, nested.fullScreenShowLogo)
        assertEquals("Pick up", nested.textAccept)
        assertEquals(true, nested.showCallHandle)

        val flat = CallPayloadMapper.fromArgs(
            args(top = arrayOf("ringtonePath" to "flat.mp3", "isBot" to true)),
        )
        assertEquals("flat.mp3", flat.ringtonePath)
        assertEquals(true, flat.isBot)
    }

    @Test
    fun `accept and decline texts come from the incoming section when there is one`() {
        val withSection = CallPayloadMapper.fromArgs(
            args(
                android = mapOf("incomingCallNotification" to mapOf("textDecline" to "No")),
                "textAccept" to "Top accept",
            ),
        )
        assertEquals("", withSection.textAccept)
        assertEquals("No", withSection.textDecline)

        val withoutSection = CallPayloadMapper.fromArgs(
            args(top = arrayOf("textAccept" to "Top accept")),
        )
        assertEquals("Top accept", withoutSection.textAccept)
    }

    // Bundle.

    @Test
    fun `every field survives the Bundle round trip except isAccepted`() {
        val restored = CallPayloadMapper.fromBundle(CallPayloadMapper.toBundle(FULL_CALL))

        assertEquals(FULL_CALL.copy(isAccepted = false), restored)
    }

    @Test
    fun `the default call survives the Bundle round trip`() {
        val bundle = CallPayloadMapper.toBundle(RingingCall())

        assertFalse(bundle.containsKey(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_ID))
        assertEquals(RingingCall(), CallPayloadMapper.fromBundle(bundle))
    }

    @Test
    fun `an empty Bundle gives the call defaults, where it used to give its own or throw`() {
        // Reading a Bundle without the keys used to give showCallbackButton false, a missed-call
        // id of 0 and empty missed-call texts, and threw without the extra map.
        assertEquals(RingingCall(), CallPayloadMapper.fromBundle(Bundle()))
    }

    // Event body.

    @Test
    fun `the event body carries the fields Dart receives for a call`() {
        val body = CallPayloadMapper.toEventBody(FULL_CALL, endedBySystem = true)

        assertEquals(
            mapOf(
                "id" to "call-1",
                "callerName" to "Ada",
                "avatar" to "ada.png",
                "number" to "ada",
                "type" to 1,
                "duration" to 45000L,
                "endedBySystem" to true,
                "extra" to mapOf("callCid" to "default:call-1", "n" to 3),
                "android" to mapOf(
                    "ringtonePath" to "ring.mp3",
                    "defaultAvatar" to "default.png",
                    "missedCallNotification" to mapOf(
                        "id" to 7,
                        "showNotification" to false,
                        "count" to 2,
                        "subtitle" to "You missed it",
                        "callbackText" to "Call back",
                        "showCallbackButton" to false,
                    ),
                    "incomingCallNotification" to mapOf(
                        "fullScreenShowLogo" to true,
                        "fullScreenLogoUrl" to "logo.png",
                        "fullScreenBackgroundColor" to "#000000",
                        "fullScreenBackgroundUrl" to "bg.png",
                        "fullScreenTextColor" to "#ffffff",
                        "textAccept" to "Pick up",
                        "textDecline" to "Hang up",
                    ),
                    "incomingCallNotificationChannelName" to "Incoming",
                    "missedCallNotificationChannelName" to "Missed",
                    "isImportant" to true,
                    "isBot" to true,
                ),
            ),
            body,
        )
    }

    @Test
    fun `the event body sends a missing missed-call id as 0 and missing channel names as empty`() {
        val body = CallPayloadMapper.toEventBody(RingingCall())

        @Suppress("UNCHECKED_CAST")
        val android = body["android"] as Map<String, Any?>
        @Suppress("UNCHECKED_CAST")
        val missed = android["missedCallNotification"] as Map<String, Any?>
        assertEquals(0, missed["id"])
        assertEquals(null, missed["subtitle"])
        assertEquals("", android["incomingCallNotificationChannelName"])
        assertEquals("", android["missedCallNotificationChannelName"])
        assertEquals(false, body["endedBySystem"])
    }

    // Stored entry.

    @Test
    fun `every field survives the stored entry round trip`() {
        val accepted = FULL_CALL.copy(isAccepted = true)

        assertEquals(accepted, CallPayloadMapper.fromStoredMap(CallPayloadMapper.toStoredMap(accepted)))
        assertEquals(
            RingingCall(),
            CallPayloadMapper.fromStoredMap(CallPayloadMapper.toStoredMap(RingingCall())),
        )
    }

    companion object {
        /** A call with every field set to something other than its default. */
        internal val FULL_CALL = RingingCall(
            id = "call-1",
            callerName = "Ada",
            handle = "ada",
            type = 1,
            duration = 45000L,
            extra = mapOf("callCid" to "default:call-1", "n" to 3),
            headers = mapOf("Authorization" to "token"),
            avatar = "ada.png",
            defaultAvatar = "default.png",
            ringtonePath = "ring.mp3",
            from = "notification",
            textAccept = "Pick up",
            textDecline = "Hang up",
            showCallHandle = true,
            fullScreenShowLogo = true,
            fullScreenLogoUrl = "logo.png",
            fullScreenBackgroundColor = "#000000",
            fullScreenBackgroundUrl = "bg.png",
            fullScreenTextColor = "#ffffff",
            showFullScreenOnLockScreen = false,
            incomingCallNotificationChannelName = "Incoming",
            missedCallNotificationChannelName = "Missed",
            missedNotificationId = 7,
            showMissedCallNotification = false,
            missedNotificationCount = 2,
            missedNotificationSubtitle = "You missed it",
            missedNotificationCallbackText = "Call back",
            showCallbackButton = false,
            isImportant = true,
            isBot = true,
            isAccepted = true,
        )
    }
}
