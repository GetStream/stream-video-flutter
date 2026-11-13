package io.getstream.video.flutter.stream_video_push_notification.telecom

import android.net.Uri
import android.telecom.DisconnectCause
import androidx.core.telecom.CallAttributesCompat
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.channels.Channel

/**
 * A [TelecomCallRepository] the test drives: a registration stays pending until
 * [completeRegistration], lasts until [disconnect], and the actions sent to a call are read back
 * with [actions].
 */
internal class FakeTelecomCallRepository : TelecomCallRepository {

    data class Registration(
        val callId: String,
        val displayName: String,
        val address: Uri,
        val isIncoming: Boolean,
        val isVideo: Boolean,
    )

    val registrations = mutableListOf<Registration>()
    var released = false
        private set

    private var listener: TelecomCallListener? = null
    private val calls = mutableMapOf<String, TelecomCall.Registered>()
    private val actionSources = mutableMapOf<String, Channel<TelecomCallAction>>()
    private val callEnds = mutableMapOf<String, CompletableDeferred<Unit>>()

    override fun warmUp() = Unit

    override fun setListener(listener: TelecomCallListener?) {
        this.listener = listener
    }

    override fun getCall(callId: String) = calls[callId]

    override fun callIds(): Set<String> = calls.keys.toSet()

    override fun hasAnyCalls() = calls.isNotEmpty()

    override fun release() {
        released = true
    }

    override suspend fun registerCall(
        callId: String,
        displayName: String,
        address: Uri,
        isIncoming: Boolean,
        isVideo: Boolean,
    ) {
        registrations += Registration(callId, displayName, address, isIncoming, isVideo)
        val actionSource = Channel<TelecomCallAction>(Channel.UNLIMITED)
        actionSources[callId] = actionSource
        calls[callId] = TelecomCall.Registered(
            id = callId,
            callAttributes = CallAttributesCompat(
                displayName = displayName,
                address = address,
                direction = if (isIncoming) {
                    CallAttributesCompat.DIRECTION_INCOMING
                } else {
                    CallAttributesCompat.DIRECTION_OUTGOING
                },
            ),
            isActive = false,
            isOnHold = false,
            isMuted = false,
            isPending = true,
            errorCode = null,
            currentCallEndpoint = null,
            availableCallEndpoints = emptyList(),
            actionSource = actionSource,
        )
        val end = CompletableDeferred<Unit>().also { callEnds[callId] = it }
        try {
            end.await()
        } finally {
            calls.remove(callId)
        }
    }

    /** Telecom brings up the call's scope. */
    fun completeRegistration(callId: String) {
        startScope(callId)
        reportRegistered(callId)
    }

    /** The call's scope is up; the repository has not reported it yet. */
    fun startScope(callId: String) {
        calls[callId] = calls.getValue(callId).copy(isPending = false)
    }

    /** The repository reports the call whose scope is up. */
    fun reportRegistered(callId: String) {
        listener?.onCallRegistered(callId, calls.getValue(callId).isIncoming())
    }

    /** The call's scope stops taking actions, as when it ended without a callback yet. */
    fun endScope(callId: String) {
        calls.getValue(callId).closeActionSource()
    }

    fun setMuted(callId: String, isMuted: Boolean) {
        calls[callId] = calls.getValue(callId).copy(isMuted = isMuted)
    }

    /** The actions sent to the call's scope so far, each read once. */
    fun actions(callId: String): List<TelecomCallAction> = buildList {
        val source = actionSources.getValue(callId)
        while (true) add(source.tryReceive().getOrNull() ?: break)
    }

    fun answer(callId: String, source: TelecomEventSource) {
        listener?.onIsCallAnswered(callId, source)
    }

    fun active(callId: String) = listener?.onIsCallActive(callId)

    fun inactive(callId: String) = listener?.onIsCallInactive(callId)

    fun holdChangeFailed(callId: String, requestedOnHold: Boolean) =
        listener?.onHoldChangeFailed(callId, requestedOnHold)

    /** Telecom disconnects the call, which ends its registration. */
    fun disconnect(callId: String, source: TelecomEventSource) {
        listener?.onIsCallDisconnected(callId, DisconnectCause(DisconnectCause.LOCAL), source)
        callEnds.getValue(callId).complete(Unit)
    }
}
