package io.getstream.video.flutter.stream_video_push_notification.telecom

import android.os.ParcelUuid
import androidx.core.telecom.CallEndpointCompat
import java.util.UUID
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner

/** Pins the shape of the audio-endpoint payload sent to Dart in `ACTION_CALL_CUSTOM`. */
@RunWith(RobolectricTestRunner::class)
class AudioEndpointUtilsTest {

    private val speakerId = UUID.fromString("00000000-0000-0000-0000-000000000001")
    private val headsetId = UUID.fromString("00000000-0000-0000-0000-000000000002")

    private fun endpoint(name: String, type: Int, id: UUID) =
        CallEndpointCompat(name, type, ParcelUuid(id))

    @Test
    fun `every known endpoint type has a wire name and the rest are unknown`() {
        assertEquals("earpiece", AudioEndpointUtils.endpointTypeToString(CallEndpointCompat.TYPE_EARPIECE))
        assertEquals("speaker", AudioEndpointUtils.endpointTypeToString(CallEndpointCompat.TYPE_SPEAKER))
        assertEquals("wired_headset", AudioEndpointUtils.endpointTypeToString(CallEndpointCompat.TYPE_WIRED_HEADSET))
        assertEquals("bluetooth", AudioEndpointUtils.endpointTypeToString(CallEndpointCompat.TYPE_BLUETOOTH))
        assertEquals("unknown", AudioEndpointUtils.endpointTypeToString(CallEndpointCompat.TYPE_STREAMING))
        assertEquals("unknown", AudioEndpointUtils.endpointTypeToString(-1))
    }

    @Test
    fun `an endpoint maps to id, name and type`() {
        val map = AudioEndpointUtils.toMap(endpoint("Speaker", CallEndpointCompat.TYPE_SPEAKER, speakerId))

        assertEquals(
            mapOf("id" to speakerId.toString(), "name" to "Speaker", "type" to "speaker"),
            map,
        )
    }

    @Test
    fun `a snapshot carries the current endpoint and every available one`() {
        val speaker = endpoint("Speaker", CallEndpointCompat.TYPE_SPEAKER, speakerId)
        val headset = endpoint("Headset", CallEndpointCompat.TYPE_WIRED_HEADSET, headsetId)

        val snapshot = AudioEndpointUtils.snapshot(current = headset, available = listOf(speaker, headset))

        assertEquals(AudioEndpointUtils.toMap(headset), snapshot["currentEndpoint"])
        assertEquals(listOf(AudioEndpointUtils.toMap(speaker), AudioEndpointUtils.toMap(headset)), snapshot["endpoints"])
    }

    @Test
    fun `a snapshot without a current endpoint sends null for it`() {
        val snapshot = AudioEndpointUtils.snapshot(current = null, available = emptyList())

        assertNull(snapshot["currentEndpoint"])
        assertEquals(emptyList<Map<String, Any?>>(), snapshot["endpoints"])
    }
}
