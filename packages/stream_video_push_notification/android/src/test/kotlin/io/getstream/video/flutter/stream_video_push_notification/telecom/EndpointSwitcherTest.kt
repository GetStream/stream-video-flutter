package io.getstream.video.flutter.stream_video_push_notification.telecom

import android.net.Uri
import android.os.ParcelUuid
import androidx.core.telecom.CallAttributesCompat
import androidx.core.telecom.CallControlResult
import androidx.core.telecom.CallEndpointCompat
import androidx.core.telecom.CallException
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.async
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.test.advanceTimeBy
import kotlinx.coroutines.test.runCurrent
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import java.util.UUID

/** Pins [EndpointSwitcher] on virtual time. */
@OptIn(ExperimentalCoroutinesApi::class)
@RunWith(RobolectricTestRunner::class)
class EndpointSwitcherTest {

    private val earpiece = endpoint("Earpiece", CallEndpointCompat.TYPE_EARPIECE)
    private val speaker = endpoint("Speaker", CallEndpointCompat.TYPE_SPEAKER)

    private val calls = MutableStateFlow(mapOf(CALL_ID to call(earpiece, listOf(earpiece))))
    private val requested = mutableListOf<CallEndpointCompat>()
    private var answer: () -> CallControlResult = { CallControlResult.Success() }

    private val switcher = EndpointSwitcher(CALL_ID, calls, { endpoint ->
        requested += endpoint
        answer()
    })

    private fun speakerRequest() =
        TelecomCallAction.RequestEndpoint(CallEndpointCompat.TYPE_SPEAKER)

    @Test
    fun `waits for Telecom to offer the endpoint, then asks for it`() = runTest {
        val routed = async { switcher.switch(speakerRequest()) }
        advanceTimeBy(500)
        assertTrue(requested.isEmpty())

        calls.value = mapOf(CALL_ID to call(earpiece, listOf(earpiece, speaker)))
        runCurrent()

        assertTrue(routed.await())
        assertEquals(listOf(speaker), requested)
    }

    @Test
    fun `answers false when Telecom does not offer the endpoint in time`() = runTest {
        val routed = async { switcher.switch(speakerRequest()) }
        advanceTimeBy(EndpointSwitcher.ENDPOINT_WAIT_MS - 1)
        assertFalse(routed.isCompleted)

        advanceTimeBy(2)

        assertFalse(routed.await())
        assertTrue(requested.isEmpty())
    }

    @Test
    fun `answers false when the call goes while waiting`() = runTest {
        val routed = async { switcher.switch(speakerRequest()) }
        advanceTimeBy(500)

        calls.value = emptyMap()
        runCurrent()

        assertFalse(routed.await())
        assertTrue(requested.isEmpty())
    }

    @Test
    fun `answers true without asking when the call already uses the endpoint`() = runTest {
        calls.value = mapOf(CALL_ID to call(speaker, listOf(earpiece, speaker)))

        assertTrue(switcher.switch(speakerRequest()))
        assertTrue(requested.isEmpty())
    }

    @Test
    fun `answers false when Telecom refuses or the change throws`() = runTest {
        calls.value = mapOf(CALL_ID to call(earpiece, listOf(earpiece, speaker)))

        answer = { CallControlResult.Error(CallException.ERROR_UNKNOWN) }
        assertFalse(switcher.switch(speakerRequest()))

        answer = { throw IllegalStateException("telecom is gone") }
        assertFalse(switcher.switch(speakerRequest()))

        assertEquals(listOf(speaker, speaker), requested)
    }

    @Test
    fun `a newer request cancels the one still waiting, which answers false`() = runTest {
        val older = speakerRequest()
        val newer = speakerRequest()

        switcher.request(this, older)
        advanceTimeBy(500)
        switcher.request(this, newer)
        calls.value = mapOf(CALL_ID to call(earpiece, listOf(earpiece, speaker)))
        runCurrent()

        assertFalse(older.result.await())
        assertTrue(newer.result.await())
        assertEquals(listOf(speaker), requested)
    }

    @Test
    fun `a request cancelled before it starts still answers false`() = runTest {
        val first = speakerRequest()

        switcher.request(this, first)
        switcher.cancel()
        runCurrent()

        assertTrue(first.result.isCompleted)
        assertFalse(first.result.await())
    }

    private fun endpoint(name: String, type: Int) =
        CallEndpointCompat(name, type, ParcelUuid(UUID.randomUUID()))

    private fun call(current: CallEndpointCompat, available: List<CallEndpointCompat>) =
        TelecomCall.Registered(
            id = CALL_ID,
            callAttributes = CallAttributesCompat(
                "Ada",
                Uri.parse("tel:1"),
                CallAttributesCompat.DIRECTION_OUTGOING,
            ),
            isActive = true,
            isOnHold = false,
            isMuted = false,
            isPending = false,
            errorCode = null,
            currentCallEndpoint = current,
            availableCallEndpoints = available,
            actionSource = Channel(),
        )

    private companion object {
        const val CALL_ID = "call-1"
    }
}
