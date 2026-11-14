package io.getstream.video.flutter.stream_video_push_notification.telecom

import android.annotation.SuppressLint
import android.content.Context
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.telecom.DisconnectCause
import android.util.Log
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallBroadcastReceiver
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallConstants
import io.getstream.video.flutter.stream_video_push_notification.core.RingingCall
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import java.util.Collections
import java.util.concurrent.ConcurrentHashMap

/**
 * Bridges the Android Telecom stack into this package's ringing flow.
 *
 * All entry points are no-ops unless the integrator opted in via
 * `AndroidPushConfiguration.telecom` and the device actually supports Telecom.
 *
 * @param repositoryFactory builds the repository the first time a call needs Telecom; returns
 * null where Telecom is not available.
 * @param scope runs the registrations, each of which lasts as long as its call.
 * @param mainThread runs the [Listener] callbacks for answers and disconnects from the system.
 */
internal class TelecomIntegration(
    context: Context,
    private val repositoryFactory: (Context) -> TelecomCallRepository? = ::coreRepository,
    private val permissions: TelecomPermissions = TelecomPermissions(),
    private val scope: CoroutineScope = CoroutineScope(SupervisorJob() + Dispatchers.Default),
    private val mainThread: (Runnable) -> Unit = { Handler(Looper.getMainLooper()).post(it) },
) {

    /** What happened to a call in Telecom, and the events it reports. */
    interface Listener {
        /** An incoming call is now in the Telecom stack. */
        fun onIncomingCallRegistered()

        /** The user answered [call] somewhere else, such as on a watch or in a car. */
        fun onAnsweredBySystem(call: RingingCall)

        /**
         * The user ended [call] somewhere else. [wasConnected] tells an end of a connected or
         * outgoing call from the decline of a ringing one.
         */
        fun onDisconnectedBySystem(call: RingingCall, wasConnected: Boolean)

        /** A hold, mute or audio-route event to send to Dart. */
        fun onEvent(event: String, body: Map<String, Any?>)
    }

    private val appContext: Context = context.applicationContext

    /** Set once, by the components that own this integration. */
    @Volatile
    var listener: Listener? = null

    /** Deliberately not volatile: [isConfigResolved] is the barrier for it. */
    private var config: TelecomConfig = TelecomConfig.DISABLED

    /** Guards the one-off read of the persisted configuration. See [config]. */
    @Volatile
    private var isConfigResolved: Boolean = false

    @Volatile
    private var repository: TelecomCallRepository? = null

    /** Calls whose registration was started but has not reached the Telecom scope yet. */
    private val registeringCallIds: MutableSet<String> = ConcurrentHashMap.newKeySet()

    /** Actions requested before the Telecom scope was ready, replayed on registration. */
    private val pendingActions = ConcurrentHashMap<String, MutableList<TelecomCallAction>>()

    /**
     * Calls Telecom has connected: answered incoming ones and activated outgoing ones.
     *
     * A system disconnect of one of these is reported as an end; of any other incoming call, as a
     * decline.
     */
    private val connectedCallIds: MutableSet<String> = ConcurrentHashMap.newKeySet()

    /** Calls this app placed, so a system hang-up is reported as an end rather than a decline. */
    private val outgoingCallIds: MutableSet<String> = ConcurrentHashMap.newKeySet()

    /** Calls currently on hold, so hold events are only emitted on an actual transition. */
    private val heldCallIds: MutableSet<String> = ConcurrentHashMap.newKeySet()

    /** The calls registered with Telecom, from register until Telecom drops them. */
    private val trackedCalls = ConcurrentHashMap<String, RingingCall>()

    private val actionLock = Any()

    // region setup

    /**
     * Applies the configuration sent from Dart. Safe to call repeatedly; the last configuration
     * wins and is persisted for cold starts. Builds the repository when Telecom is enabled.
     */
    fun init(configuration: Map<String, Any?>?) {
        config = TelecomConfig.fromConfiguration(appContext, configuration)
        isConfigResolved = true
        TelecomConfig.persist(appContext, config)
        Log.d(TAG, "[init] telecom enabled=${config.enabled}, schema=${config.schema}")

        scope.launch {
            if (isEnabled()) requireRepository()
        }
    }

    private fun ensureConfigResolved() {
        if (isConfigResolved) return
        synchronized(this) {
            if (isConfigResolved) return
            config = TelecomConfig.load(appContext)
            isConfigResolved = true
        }
    }

    /** Whether calls should be handed to Telecom on this device with the current configuration. */
    fun isEnabled(): Boolean {
        ensureConfigResolved()
        return config.enabled && permissions.canUseTelecom(appContext)
    }

    private fun requireRepository(): TelecomCallRepository? {
        repository?.let { return it }
        return synchronized(this) {
            repository ?: try {
                repositoryFactory(appContext)
                    ?.also { it.setListener(repositoryListener) }
                    ?.also { it.warmUp() }
                    ?.also { repository = it }
            } catch (error: Throwable) {
                // Registering with Telecom can fail on devices with a broken telecom service.
                Log.e(TAG, "[requireRepository] unable to create repository", error)
                null
            }
        }
    }

    // endregion

    // region registration

    /** Registers a ringing incoming call with Telecom. */
    fun registerIncomingCall(call: RingingCall) = register(call, incoming = true)

    /** Registers an outgoing call with Telecom and makes it active once registered. */
    fun registerOutgoingCall(call: RingingCall) = register(call, incoming = false)

    private fun describeAvailability(): String = when {
        !config.enabled -> "turned off through AndroidPushConfiguration.telecom"
        !permissions.isSupportedApiLevel() ->
            "unsupported API level ${Build.VERSION.SDK_INT}, needs 26+"
        !permissions.hasPermissions(appContext) -> "MANAGE_OWN_CALLS not granted"
        !permissions.supportsTelecom(appContext) ->
            "no telephony feature or default dialer (pre-Android 17 requirement)"
        else -> "available"
    }

    @SuppressLint("MissingPermission")
    private fun register(call: RingingCall, incoming: Boolean) {
        if (!isEnabled()) {
            Log.d(TAG, "[register] skipped: ${describeAvailability()}")
            return
        }
        val repository = requireRepository() ?: return

        val callId = call.id
        if (callId.isBlank()) {
            Log.w(TAG, "[register] missing call id, skipping telecom registration")
            return
        }

        trackedCalls[callId] = call
        if (!incoming) outgoingCallIds.add(callId)

        if (repository.getCall(callId) != null || !registeringCallIds.add(callId)) {
            Log.w(TAG, "[register] $callId already registered with telecom")
            return
        }

        Log.d(
            TAG,
            "[register] ${if (incoming) "incoming" else "outgoing"} call $callId as " +
                "${addressOf(call)} (video=${call.type == 1})",
        )

        scope.launch {
            try {
                repository.registerCall(
                    callId = callId,
                    displayName = displayNameOf(call),
                    address = addressOf(call),
                    isIncoming = incoming,
                    isVideo = call.type == 1,
                )
            } catch (error: Exception) {
                Log.e(TAG, "[register] registration of $callId failed", error)
            } finally {
                cleanUp(callId)
            }
        }
    }

    private fun displayNameOf(call: RingingCall): String = call.callerName
        .takeIf { it.isNotBlank() }
        ?: call.handle.takeIf { it.isNotBlank() }
        ?: "Unknown Caller"

    private fun addressOf(call: RingingCall): Uri {
        val identifier = call.callCid?.takeIf { it.isNotBlank() } ?: call.id
        return Uri.parse("${config.schema}:$identifier")
    }

    // endregion

    // region actions

    /** True once [register] has run for this call and before it was cleaned up. */
    private fun isTracked(callId: String) = trackedCalls.containsKey(callId)

    /** Answers a call in Telecom. Answering a call Telecom already connected does nothing. */
    fun answer(callId: String) {
        if (!isEnabled() || !isTracked(callId)) return
        if (!connectedCallIds.add(callId)) return
        processAction(callId, TelecomCallAction.Answer, createRepository = true)
    }

    /** Disconnects a call in Telecom with [cause], a [DisconnectCause] code. */
    fun disconnect(callId: String, cause: Int) {
        if (!isEnabled()) return
        processAction(
            callId,
            TelecomCallAction.Disconnect(DisconnectCause(cause)),
            createRepository = true,
        )
    }

    /** Marks a call as active, used once an outgoing or accepted call is connected. */
    fun activate(callId: String) {
        if (!isEnabled()) return
        processAction(callId, TelecomCallAction.Activate, createRepository = true)
    }

    /**
     * Asks Telecom to hold or resume a call. The hold event is sent once Telecom has done it, as
     * for a hold from the system.
     */
    fun setOnHold(callId: String, isOnHold: Boolean) {
        if (!isEnabled() || !isTracked(callId)) return
        processAction(
            callId,
            if (isOnHold) TelecomCallAction.Hold else TelecomCallAction.Activate,
            createRepository = true,
        )
    }

    /** Disconnects every call Telecom holds or is still registering, with [cause]. */
    fun disconnectAll(cause: Int) {
        if (!isEnabled()) return
        val repository = repository ?: return
        repository.callIds().toList().forEach { disconnect(it, cause) }
        registeringCallIds.toList().forEach { disconnect(it, cause) }
    }

    /**
     * The mute state Telecom last reported for a call, or false when Telecom holds no call with
     * this id.
     */
    fun isMuted(callId: String): Boolean = repository?.getCall(callId)?.isMuted ?: false

    /**
     * Sends [action] to the call's Telecom scope, or queues it while the call is still
     * registering. Ignored for a call Telecom does not know.
     */
    private fun processAction(
        callId: String,
        action: TelecomCallAction,
        createRepository: Boolean = false,
    ) {
        val repository = (if (createRepository) requireRepository() else repository) ?: return

        synchronized(actionLock) {
            val call = repository.getCall(callId)
            when {
                call != null && !call.isPending -> {
                    if (!call.processAction(action)) {
                        Log.w(
                            TAG,
                            "[processAction] $callId dropped ${action::class.simpleName}: " +
                                "the telecom call scope has ended",
                        )
                    }
                }

                call != null || registeringCallIds.contains(callId) -> {
                    pendingActions
                        .getOrPut(callId) { Collections.synchronizedList(mutableListOf()) }
                        .add(action)
                }

                else -> Log.d(TAG, "[processAction] $callId is not known to telecom, ignoring")
            }
        }
    }

    /**
     * Replays the actions queued while [callId] registered. A queued disconnect is sent alone,
     * without the actions queued with it.
     */
    private fun drainPendingActions(callId: String) {
        val repository = repository ?: return

        synchronized(actionLock) {
            val call = repository.getCall(callId) ?: return
            val actions = pendingActions.remove(callId) ?: return
            val snapshot = synchronized(actions) { actions.toList() }

            val disconnect = snapshot.firstOrNull { it is TelecomCallAction.Disconnect }
            if (disconnect != null) {
                if (!call.processAction(disconnect)) {
                    Log.w(TAG, "[drainPendingActions] $callId lost its queued disconnect")
                }
                return
            }
            snapshot.forEach {
                if (!call.processAction(it)) {
                    Log.w(
                        TAG,
                        "[drainPendingActions] $callId lost queued ${it::class.simpleName}",
                    )
                }
            }
        }
    }

    private fun cleanUp(callId: String) {
        registeringCallIds.remove(callId)
        pendingActions.remove(callId)
        connectedCallIds.remove(callId)
        outgoingCallIds.remove(callId)
        heldCallIds.remove(callId)
        trackedCalls.remove(callId)
    }

    /** Releases the Telecom registration, but only when no call is tracked or registered. */
    fun releaseIfIdle() {
        if (trackedCalls.isNotEmpty() || repository?.hasAnyCalls() == true) {
            Log.d(TAG, "[releaseIfIdle] calls still in flight; keeping the telecom registration")
            return
        }
        release()
    }

    /** Releases the Telecom registration, disconnecting anything still active. */
    fun release() {
        repository?.release()
        repository = null
        isConfigResolved = false
        registeringCallIds.clear()
        pendingActions.clear()
        connectedCallIds.clear()
        outgoingCallIds.clear()
        heldCallIds.clear()
        trackedCalls.clear()
    }

    // endregion

    // region repository callbacks

    private val repositoryListener = object : TelecomCallListener {

        override fun onCallRegistered(callId: String, incoming: Boolean) {
            registeringCallIds.remove(callId)
            drainPendingActions(callId)

            Log.d(TAG, "[onCallRegistered] $callId registered with telecom, incoming=$incoming")

            if (incoming) {
                mainThread { listener?.onIncomingCallRegistered() }
            } else {
                // An outgoing call stays dialing until it is activated, here once its scope is up.
                processAction(callId, TelecomCallAction.Activate)
            }
        }

        override fun onRegistrationFailed(callId: String, error: Throwable?) {
            Log.w(TAG, "[onRegistrationFailed] $callId, falling back to notification-only flow")
            cleanUp(callId)
        }

        override fun onIsCallAnswered(callId: String, source: TelecomEventSource) {
            Log.d(TAG, "[onIsCallAnswered] $callId answered, source=$source")
            connectedCallIds.add(callId)
            if (source != TelecomEventSource.SYS) return

            val call = trackedCalls[callId] ?: return
            mainThread { listener?.onAnsweredBySystem(call) }
        }

        override fun onIsCallDisconnected(
            callId: String,
            cause: DisconnectCause,
            source: TelecomEventSource,
        ) {
            Log.d(
                TAG,
                "[onIsCallDisconnected] $callId disconnected, cause=${cause.code}, source=$source",
            )
            val wasConnected =
                connectedCallIds.contains(callId) || outgoingCallIds.contains(callId)
            val call = trackedCalls[callId]
            cleanUp(callId)

            if (source != TelecomEventSource.SYS) return
            if (call == null) return
            mainThread { listener?.onDisconnectedBySystem(call, wasConnected) }
        }

        /** Reports a resume when the call was held, whoever asked for it. */
        override fun onIsCallActive(callId: String) {
            // Active also follows a connect and an answer, after which a system disconnect is an
            // end, not a decline.
            connectedCallIds.add(callId)
            if (!heldCallIds.remove(callId)) return
            sendEvent(IncomingCallConstants.ACTION_CALL_TOGGLE_HOLD, callId, "isOnHold" to false)
        }

        /** Reports a hold when the call was not held yet, whoever asked for it. */
        override fun onIsCallInactive(callId: String) {
            if (!heldCallIds.add(callId)) return
            sendEvent(IncomingCallConstants.ACTION_CALL_TOGGLE_HOLD, callId, "isOnHold" to true)
        }

        override fun onMuteCallChanged(callId: String, isMuted: Boolean) {
            sendEvent(IncomingCallConstants.ACTION_CALL_TOGGLE_MUTE, callId, "isMuted" to isMuted)
        }

        /** A refused hold or resume changes nothing, so nothing is reported. */
        override fun onHoldChangeFailed(callId: String, requestedOnHold: Boolean) {
            Log.w(TAG, "[onHoldChangeFailed] $callId, requested onHold=$requestedOnHold")
        }

        override fun onCallAudioEndpointsChanged(callId: String, snapshot: Map<String, Any?>) {
            sendEvent(
                IncomingCallConstants.ACTION_CALL_CUSTOM,
                callId,
                "type" to CUSTOM_EVENT_AUDIO_ENDPOINTS,
                "audio" to snapshot,
            )
        }

        /** Sends an event unless events are silenced. */
        private fun sendEvent(event: String, callId: String, vararg values: Pair<String, Any?>) {
            if (IncomingCallBroadcastReceiver.silenceEvents) return
            listener?.onEvent(event, mapOf("id" to callId) + values.toMap())
        }
    }

    // endregion

    private companion object {
        const val TAG = "TelecomIntegration"

        /** Payload type of the [IncomingCallConstants.ACTION_CALL_CUSTOM] audio-endpoint event. */
        const val CUSTOM_EVENT_AUDIO_ENDPOINTS = "telecomAudioEndpointsChanged"
    }
}

/** A [CoreTelecomCallRepository] on Android 8 and later, null below. */
@SuppressLint("NewApi")
private fun coreRepository(context: Context): TelecomCallRepository? =
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) CoreTelecomCallRepository(context) else null
