package io.getstream.video.flutter.stream_video_push_notification.telecom

import android.util.Log
import androidx.core.telecom.CallControlResult
import androidx.core.telecom.CallEndpointCompat
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.launch
import kotlinx.coroutines.withTimeoutOrNull

/**
 * Carries out the [TelecomCallAction.RequestEndpoint]s of one call, one at a time: a newer request
 * cancels the one still running, which then answers false.
 *
 * [calls] is the repository's view of its calls, whose endpoints Telecom keeps current;
 * [requestEndpointChange] is the call scope's own.
 */
internal class EndpointSwitcher(
    private val callId: String,
    private val calls: StateFlow<Map<String, TelecomCall.Registered>>,
    private val requestEndpointChange: suspend (CallEndpointCompat) -> CallControlResult,
    private val waitMs: Long = ENDPOINT_WAIT_MS,
) {

    private var running: Job? = null

    /**
     * Runs [request] in [scope] beside the call's other actions, cancelling the request still
     * running. The answer is also given on completion: a job cancelled before it starts never
     * runs its body.
     */
    fun request(scope: CoroutineScope, request: TelecomCallAction.RequestEndpoint) {
        running?.cancel()
        running = scope.launch { request.result.complete(switch(request)) }
            .apply { invokeOnCompletion { request.result.complete(false) } }
    }

    /** Cancels the request still running, which answers false. */
    fun cancel() {
        running?.cancel()
    }

    /**
     * Routes the call to an endpoint of the request's type, waiting up to [waitMs] for Telecom to
     * offer one. Returns whether the call is routed there.
     */
    suspend fun switch(request: TelecomCallAction.RequestEndpoint): Boolean {
        val type = request.endpointType
        // Telecom lists the endpoints shortly after the call scope starts, and a headset only
        // once it has connected, so the endpoint may not be offered yet.
        val call = withTimeoutOrNull(waitMs) {
            calls.map { it[callId] }.first { call ->
                call == null || call.availableCallEndpoints.any { it.type == type }
            }
        } ?: calls.value[callId] ?: return false

        val name = AudioEndpointUtils.endpointTypeToString(type)
        return when (
            val choice = AudioEndpointUtils.chooseEndpoint(
                type,
                call.currentCallEndpoint,
                call.availableCallEndpoints,
                request.endpointName,
            )
        ) {
            AudioEndpointUtils.EndpointChoice.AlreadyCurrent -> true

            AudioEndpointUtils.EndpointChoice.Unavailable -> {
                Log.w(TAG, "[switch] $callId has no $name endpoint")
                false
            }

            // A throw would fail the call scope and end a live call, so it is only logged.
            is AudioEndpointUtils.EndpointChoice.Request -> try {
                when (val result = requestEndpointChange(choice.endpoint)) {
                    is CallControlResult.Success -> true
                    is CallControlResult.Error -> {
                        Log.e(TAG, "[switch] $callId to $name failed: ${result.errorCode}")
                        false
                    }
                }
            } catch (error: CancellationException) {
                throw error
            } catch (error: Exception) {
                Log.e(TAG, "[switch] $callId to $name threw", error)
                false
            }
        }
    }

    companion object {
        private const val TAG = "StreamTelecomEndpoint"

        /** How long a request waits for Telecom to offer the endpoint. */
        const val ENDPOINT_WAIT_MS = 2_000L
    }
}
