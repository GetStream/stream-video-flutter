package io.getstream.video.flutter.stream_video_push_notification.telecom

import android.content.Context
import android.net.Uri
import android.os.ParcelUuid
import android.telecom.DisconnectCause
import androidx.core.telecom.CallControlResult
import androidx.core.telecom.CallControlScope
import androidx.core.telecom.CallEndpointCompat
import androidx.core.telecom.CallException
import androidx.core.telecom.CallsManager
import androidx.test.core.app.ApplicationProvider
import io.mockk.coEvery
import io.mockk.mockk
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.emptyFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.withTimeout
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import java.util.UUID
import java.util.concurrent.CopyOnWriteArrayList

/**
 * Pins what [CoreTelecomCallRepository] sends to Telecom's call control, against a [CallsManager]
 * that runs each call's block in a [FakeCallControlScope].
 */
@RunWith(RobolectricTestRunner::class)
class CoreTelecomCallRepositoryTest {

    private val context: Context get() = ApplicationProvider.getApplicationContext()

    private val disconnectCauses = CopyOnWriteArrayList<Int>()
    private val reported = CopyOnWriteArrayList<String>()

    private val listener = object : TelecomCallListener {
        override fun onRegistrationFailed(callId: String, error: Throwable?) {
            reported += "registration failed $callId"
        }

        override fun onIsCallDisconnected(
            callId: String,
            cause: DisconnectCause,
            source: TelecomEventSource,
        ) {
            reported += "disconnected $callId cause=${cause.code} source=$source"
        }
    }

    private fun callsManager(answerResult: CallControlResult): CallsManager =
        mockk<CallsManager>().also { manager ->
            coEvery { manager.addCall(any(), any(), any(), any(), any(), any()) } coAnswers {
                val block = arg<CallControlScope.() -> Unit>(5)
                coroutineScope {
                    FakeCallControlScope(this, answerResult, disconnectCauses).block()
                }
            }
        }

    private var repository: CoreTelecomCallRepository? = null

    @After
    fun release() {
        repository?.release()
    }

    @Test
    fun `a failed answer disconnects the call with a cause Telecom accepts`() = runBlocking {
        val manager = callsManager(CallControlResult.Error(CallException.ERROR_UNKNOWN))
        val repository = CoreTelecomCallRepository(context, callsManagerFactory = { manager })
            .also { repository = it }
        repository.setListener(listener)

        val registration = launch(Dispatchers.Default) {
            repository.registerCall(
                CALL_ID,
                displayName = "Ada",
                address = Uri.parse("tel:1"),
                isIncoming = true,
                isVideo = false,
            )
        }
        withTimeout(TIMEOUT_MS) {
            while (repository.getCall(CALL_ID) == null) delay(10)
        }

        repository.getCall(CALL_ID)!!.processAction(TelecomCallAction.Answer)
        withTimeout(TIMEOUT_MS) { registration.join() }

        assertEquals(listOf(DisconnectCause.LOCAL), disconnectCauses.toList())
        assertEquals(
            listOf("disconnected $CALL_ID cause=${DisconnectCause.LOCAL} source=APP"),
            reported.toList(),
        )
        assertNull(repository.getCall(CALL_ID))
    }

    /**
     * A [CallControlScope] whose answer returns [answerResult] and whose disconnect, like the
     * platform's call control, throws for a cause other than LOCAL, REMOTE, MISSED or REJECTED.
     */
    private class FakeCallControlScope(
        scope: CoroutineScope,
        private val answerResult: CallControlResult,
        private val disconnectCauses: MutableList<Int>,
    ) : CallControlScope, CoroutineScope by scope {

        override fun getCallId(): ParcelUuid = ParcelUuid(UUID(0, 0))

        override suspend fun setActive(): CallControlResult = CallControlResult.Success()

        override suspend fun setInactive(): CallControlResult = CallControlResult.Success()

        override suspend fun answer(callType: Int): CallControlResult = answerResult

        override suspend fun disconnect(disconnectCause: DisconnectCause): CallControlResult {
            require(disconnectCause.code in CALL_CONTROL_CAUSES) {
                "unsupported disconnect cause ${disconnectCause.code}"
            }
            disconnectCauses += disconnectCause.code
            return CallControlResult.Success()
        }

        override suspend fun requestEndpointChange(endpoint: CallEndpointCompat) =
            CallControlResult.Success()

        override val currentCallEndpoint: Flow<CallEndpointCompat> = emptyFlow()

        override val availableEndpoints: Flow<List<CallEndpointCompat>> = emptyFlow()

        override val isMuted: Flow<Boolean> = emptyFlow()
    }

    private companion object {
        const val CALL_ID = "call-1"
        const val TIMEOUT_MS = 5_000L

        val CALL_CONTROL_CAUSES = setOf(
            DisconnectCause.LOCAL,
            DisconnectCause.REMOTE,
            DisconnectCause.MISSED,
            DisconnectCause.REJECTED,
        )
    }
}
