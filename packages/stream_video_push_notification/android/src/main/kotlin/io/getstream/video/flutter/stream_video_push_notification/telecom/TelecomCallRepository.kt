package io.getstream.video.flutter.stream_video_push_notification.telecom

import android.content.Context
import android.net.Uri
import android.os.Build
import android.telecom.DisconnectCause
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.core.telecom.CallAttributesCompat
import androidx.core.telecom.CallControlResult
import androidx.core.telecom.CallControlScope
import androidx.core.telecom.CallsManager
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.channels.ReceiveChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.atomic.AtomicBoolean

/**
 * Keeps track of calls registered with the Android Telecom stack.
 */
@RequiresApi(Build.VERSION_CODES.O)
internal class TelecomCallRepository(private val context: Context) {

    companion object {
        private const val TAG = "StreamTelecomRepo"
    }

    /** Per-call flags telling whether an action was started by us or by the system. */
    private class CallActionFlags {
        val isSelfAnswered = AtomicBoolean(false)
        val isSelfDisconnected = AtomicBoolean(false)
    }

    private val _calls = MutableStateFlow<Map<String, TelecomCall.Registered>>(emptyMap())
    val calls: StateFlow<Map<String, TelecomCall.Registered>> = _calls.asStateFlow()

    private val actionFlags = ConcurrentHashMap<String, CallActionFlags>()
    private val registrationMutex = Mutex()
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Default)

    /**
     * Volatile: `release()` clears this from the main thread while the collectors below, which run
     * on [Dispatchers.Default], are reading it to dispatch callbacks.
     */
    @Volatile
    private var listener: TelecomCallListener? = null

    // Not volatile: only ever touched from setListener and release, both on the main thread.
    private var observeCallsJob: Job? = null

    @Volatile
    private var isReleased = false

    private val callsManager: CallsManager by lazy {
        CallsManager(context.applicationContext).apply {
            registerAppWithTelecom(
                capabilities = CallsManager.CAPABILITY_SUPPORTS_CALL_STREAMING or
                    CallsManager.CAPABILITY_SUPPORTS_VIDEO_CALLING,
            )
        }
    }

    /** True once [warmUp] has registered the app with Telecom. */
    private var isWarm: Boolean = false

    /**
     * Performs the one-off app registration with Telecom now.
     *
     * [callsManager] is lazy, so without this the `registerAppWithTelecom` call inside it is
     * deferred until the first `addCall` — which puts it back on the ringing path that warming up
     * exists to keep clear.
     */
    fun warmUp() {
        if (isWarm) return
        isWarm = callsManager.let { true }
    }

    fun setListener(listener: TelecomCallListener?) {
        this.listener = listener
        observeCallsJob?.cancel()
        observeCallsJob = observeCalls()
    }

    fun getCall(callId: String): TelecomCall.Registered? = _calls.value[callId]

    fun hasAnyCalls(): Boolean = _calls.value.isNotEmpty()

    fun release() {
        if (isReleased) return
        isReleased = true

        _calls.value.values.forEach {
            // A false return means the call scope is already gone, so there is nothing left to
            // disconnect — worth a line either way, since it is otherwise indistinguishable
            // from a disconnect that was delivered.
            if (!it.processAction(
                    TelecomCallAction.Disconnect(DisconnectCause(DisconnectCause.LOCAL)),
                )
            ) {
                Log.w(TAG, "[release] ${it.id} could not be disconnected; its scope had ended")
            }
            // The map is cleared below, so the disconnect callback will no longer find the call to
            // close its action stream. Closing it here keeps the call scope from staying suspended
            // after the queued disconnect has been delivered.
            it.closeActionSource()
        }
        _calls.value = emptyMap()
        actionFlags.clear()

        observeCallsJob?.cancel()
        observeCallsJob = null
        listener = null
        scope.cancel()
    }

    /**
     * Registers a call with Telecom and keeps the call scope alive until the call is disconnected.
     *
     * Suspends for the whole lifetime of the call, so callers must launch it on their own scope.
     */
    suspend fun registerCall(
        callId: String,
        displayName: String,
        address: Uri,
        isIncoming: Boolean,
        isVideo: Boolean,
    ) {
        if (isReleased) {
            Log.w(TAG, "[registerCall] repository released, ignoring $callId")
            return
        }

        val attributes: CallAttributesCompat
        val actionSource: Channel<TelecomCallAction>
        val flags: CallActionFlags

        registrationMutex.withLock {
            if (_calls.value.containsKey(callId)) {
                Log.w(TAG, "[registerCall] $callId already registered, ignoring duplicate")
                return
            }

            attributes = createCallAttributes(displayName, address, isIncoming, isVideo)
            // Use UNLIMITED channel to avoid losing actions when collector is suspended.
            actionSource = Channel(Channel.UNLIMITED)
            flags = CallActionFlags()
            actionFlags[callId] = flags

            // Added to the map up-front so duplicate registrations are rejected while the
            // Telecom scope is still starting. Actions arriving in that window are queued by
            // StreamTelecomManager and replayed once `isPending` clears.
            addCall(
                callId,
                TelecomCall.Registered(
                    id = callId,
                    callAttributes = attributes,
                    isActive = false,
                    isOnHold = false,
                    isMuted = false,
                    isPending = true,
                    errorCode = null,
                    currentCallEndpoint = null,
                    availableCallEndpoints = emptyList(),
                    actionSource = actionSource,
                ),
            )
        }

        try {
            callsManager.addCall(
                attributes,
                onIsCallAnswered(callId, flags),
                onIsCallDisconnected(callId, flags),
                onIsCallActive(callId),
                onIsCallInactive(callId),
            ) {
                // The call is live in Telecom now.
                updateCallById(callId) { copy(isPending = false) }

                val observers = listOf(
                    launch {
                        currentCallEndpoint.collect { endpoint ->
                            updateCallById(callId) { copy(currentCallEndpoint = endpoint) }
                        }
                    },
                    launch {
                        availableEndpoints.collect { endpoints ->
                            updateCallById(callId) { copy(availableCallEndpoints = endpoints) }
                        }
                    },
                    launch {
                        isMuted.collect { muted ->
                            updateCallById(callId) { copy(isMuted = muted) }
                        }
                    },
                )

                launch {
                    try {
                        // Consumes actions until the call is disconnected and its channel is
                        // closed. The channel is buffered, so actions that arrived while this
                        // scope was starting are replayed rather than lost.
                        processCallActions(callId, flags, actionSource)
                    } finally {
                        // `addCall` runs this block inside a `coroutineScope`, so it does not
                        // return until every coroutine started here has finished. The endpoint and
                        // mute flows are backed by channels Telecom never closes, so without
                        // cancelling them the call scope, and the cleanup that follows it, would
                        // leak for the process lifetime.
                        observers.forEach { it.cancel() }
                    }
                }
            }
        } catch (error: CancellationException) {
            throw error
        } catch (error: Exception) {
            Log.e(TAG, "[registerCall] failed to register $callId", error)
            removeCall(callId)
            actionFlags.remove(callId)
            listener?.onRegistrationFailed(callId, error)
            return
        } finally {
            removeCall(callId)
            actionFlags.remove(callId)
        }
    }

    private fun createCallAttributes(
        displayName: String,
        address: Uri,
        isIncoming: Boolean,
        isVideo: Boolean,
    ) = CallAttributesCompat(
        displayName = displayName,
        address = address,
        direction = if (isIncoming) {
            CallAttributesCompat.DIRECTION_INCOMING
        } else {
            CallAttributesCompat.DIRECTION_OUTGOING
        },
        callType = if (isVideo) {
            CallAttributesCompat.CALL_TYPE_VIDEO_CALL
        } else {
            CallAttributesCompat.CALL_TYPE_AUDIO_CALL
        },
        callCapabilities = CallAttributesCompat.SUPPORTS_SET_INACTIVE or
            CallAttributesCompat.SUPPORTS_STREAM or
            CallAttributesCompat.SUPPORTS_TRANSFER,
    )

    private fun observeCalls(): Job {
        var previousCalls: Map<String, TelecomCall.Registered> = emptyMap()

        return calls
            .onEach { allCalls ->
                // Pending calls are not in Telecom yet, don't report them.
                val currentCalls = allCalls.filterValues { !it.isPending }

                for ((callId, call) in currentCalls) {
                    val previous = previousCalls[callId]
                    if (previous == null) {
                        listener?.onCallRegistered(callId, call.isIncoming())
                        continue
                    }
                    if (previous.isMuted != call.isMuted) {
                        listener?.onMuteCallChanged(callId, call.isMuted)
                    }
                    if (previous.currentCallEndpoint != call.currentCallEndpoint ||
                        previous.availableCallEndpoints != call.availableCallEndpoints
                    ) {
                        listener?.onCallAudioEndpointsChanged(
                            callId,
                            AudioEndpointUtils.snapshot(
                                call.currentCallEndpoint,
                                call.availableCallEndpoints,
                            ),
                        )
                    }
                }

                previousCalls = currentCalls
            }
            .launchIn(scope)
    }

    private suspend fun CallControlScope.processCallActions(
        callId: String,
        flags: CallActionFlags,
        actionSource: ReceiveChannel<TelecomCallAction>,
    ) {
        for (action in actionSource) {
            when (action) {
                is TelecomCallAction.Answer -> doAnswer(callId, flags)

                is TelecomCallAction.Disconnect -> {
                    flags.isSelfDisconnected.set(true)
                    disconnect(action.cause)
                    onIsCallDisconnected(callId, flags)(action.cause)
                    // The call is gone, so stop consuming instead of failing whatever was still
                    // queued behind the disconnect.
                    return
                }

                is TelecomCallAction.Hold -> when (val result = setInactive()) {
                    is CallControlResult.Success -> onIsCallInactive(callId)()
                    is CallControlResult.Error -> {
                        Log.e(TAG, "[processCallActions] hold failed: ${result.errorCode}")
                        updateCallById(callId) { copy(errorCode = result.errorCode) }
                        // No transition will follow, so whoever is suppressing the echo of this
                        // request has to be told, or it suppresses the next real one instead.
                        listener?.onHoldChangeFailed(callId, requestedOnHold = true)
                    }
                }

                is TelecomCallAction.Activate -> when (val result = setActive()) {
                    is CallControlResult.Success -> onIsCallActive(callId)()
                    is CallControlResult.Error -> {
                        Log.e(TAG, "[processCallActions] activate failed: ${result.errorCode}")
                        updateCallById(callId) { copy(errorCode = result.errorCode) }
                        listener?.onHoldChangeFailed(callId, requestedOnHold = false)
                    }
                }
            }
        }
    }

    private suspend fun CallControlScope.doAnswer(callId: String, flags: CallActionFlags) {
        flags.isSelfAnswered.set(true)
        val callType = _calls.value[callId]?.callAttributes?.callType
            ?: CallAttributesCompat.CALL_TYPE_VIDEO_CALL

        when (val result = answer(callType)) {
            is CallControlResult.Success -> onIsCallAnswered(callId, flags)(callType)
            is CallControlResult.Error -> {
                Log.e(TAG, "[doAnswer] answer failed: ${result.errorCode}")
                flags.isSelfAnswered.set(false)

                // Call disconnect to ensure Telecom call teardown before removing locally.
                val cause = DisconnectCause(DisconnectCause.BUSY)
                flags.isSelfDisconnected.set(true)
                disconnect(cause)
                onIsCallDisconnected(callId, flags)(cause)
            }
        }
    }

    private fun onIsCallAnswered(
        callId: String,
        flags: CallActionFlags,
    ): suspend (type: Int) -> Unit = {
        updateCallById(callId) { copy(isActive = true, isOnHold = false) }
        val source = if (flags.isSelfAnswered.get()) TelecomEventSource.APP else TelecomEventSource.SYS
        if (_calls.value.containsKey(callId)) {
            listener?.onIsCallAnswered(callId, source)
        }
        flags.isSelfAnswered.set(false)
    }

    private fun onIsCallDisconnected(
        callId: String,
        flags: CallActionFlags,
    ): suspend (cause: DisconnectCause) -> Unit = { cause ->
        val source = if (flags.isSelfDisconnected.get()) TelecomEventSource.APP else TelecomEventSource.SYS
        val disconnected = _calls.value[callId]
        val wasTracked = disconnected != null
        removeCall(callId)
        // Both a disconnect we asked for and one the system performed land here, so this is the
        // single place that can end the action stream and let the Telecom call scope finish.
        disconnected?.closeActionSource()
        if (wasTracked) {
            listener?.onIsCallDisconnected(callId, cause, source)
        }
        flags.isSelfDisconnected.set(false)
    }

    private fun onIsCallActive(callId: String): suspend () -> Unit = {
        updateCallById(callId) { copy(errorCode = null, isActive = true, isOnHold = false) }
        if (_calls.value.containsKey(callId)) {
            listener?.onIsCallActive(callId)
        }
    }

    private fun onIsCallInactive(callId: String): suspend () -> Unit = {
        updateCallById(callId) { copy(errorCode = null, isOnHold = true) }
        if (_calls.value.containsKey(callId)) {
            listener?.onIsCallInactive(callId)
        }
    }

    private fun updateCallById(
        callId: String,
        transform: TelecomCall.Registered.() -> TelecomCall,
    ) {
        _calls.update { current ->
            val call = current[callId] ?: return@update current
            when (val updated = call.transform()) {
                is TelecomCall.Registered -> current + (callId to updated)
                else -> current - callId
            }
        }
    }

    private fun addCall(callId: String, call: TelecomCall.Registered) {
        _calls.update { it + (callId to call) }
    }

    private fun removeCall(callId: String) {
        _calls.update { it - callId }
    }
}
