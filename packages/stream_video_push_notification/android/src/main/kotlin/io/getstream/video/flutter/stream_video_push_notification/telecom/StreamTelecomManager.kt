package io.getstream.video.flutter.stream_video_push_notification.telecom

import android.annotation.SuppressLint
import android.content.Context
import android.net.Uri
import android.os.Build
import android.telecom.DisconnectCause
import android.util.Log
import io.getstream.video.flutter.stream_video_push_notification.Data
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallBroadcastReceiver
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallConstants
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallNotificationService
import io.getstream.video.flutter.stream_video_push_notification.StreamVideoPushNotificationPlugin
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import java.util.Collections
import java.util.concurrent.ConcurrentHashMap

/**
 * Bridges the Android Telecom stack into this package's existing ringing flow.
 *
 * All entry points are no-ops unless the integrator opted in via
 * `AndroidPushConfiguration.telecom` and the device actually supports Telecom.
 */
internal object StreamTelecomManager {

    private const val TAG = "StreamTelecomManager"

    /** Payload key used for the [IncomingCallConstants.ACTION_CALL_CUSTOM] audio-endpoint event. */
    private const val CUSTOM_EVENT_AUDIO_ENDPOINTS = "telecomAudioEndpointsChanged"

    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Default)

    private var appContext: Context? = null
    private var config: TelecomConfig = TelecomConfig.DISABLED

    /** Guards the one-off read of the persisted configuration. */
    @Volatile
    private var isConfigResolved: Boolean = false

    @SuppressLint("NewApi")
    private var repository: TelecomCallRepository? = null

    /** Calls whose registration was started but has not reached the Telecom scope yet. */
    private val registeringCallIds: MutableSet<String> = ConcurrentHashMap.newKeySet()

    /** Actions requested before the Telecom scope was ready, replayed on registration. */
    private val pendingActions = ConcurrentHashMap<String, MutableList<TelecomCallAction>>()

    /**
     * Calls Telecom has connected: answered incoming ones and activated outgoing ones.
     *
     * Used to pick the right disconnect broadcast. A call that never connected was declined, while
     * one that did was ended, and the two take very different paths on the Dart side.
     */
    private val connectedCallIds: MutableSet<String> = ConcurrentHashMap.newKeySet()

    /**
     * Calls this app placed, so a system hang-up is reported as an end rather than a decline.
     */
    private val outgoingCallIds: MutableSet<String> = ConcurrentHashMap.newKeySet()

    /** Calls currently on hold, so hold events are only emitted on an actual transition. */
    private val heldCallIds: MutableSet<String> = ConcurrentHashMap.newKeySet()

    /**
     * Hold values we asked Telecom for, so the resulting change is not echoed back to Flutter.
     *
     * [heldCallIds] cannot do this job: it dedupes repeated transitions, not originators, so an
     * app-requested hold still came back as a second identical event on top of the one the plugin
     * had already emitted.
     */
    private val selfRequestedHold = ConcurrentHashMap<String, Boolean>()

    /** Data of tracked calls, needed to rebuild broadcast intents for system-originated events. */
    private val trackedCallData = ConcurrentHashMap<String, Data>()

    private val actionLock = Any()

    // region setup

    /**
     * Applies the configuration sent from Dart. Safe to call repeatedly; the last configuration
     * wins and is persisted for cold starts.
     */
    fun init(context: Context, configuration: Map<String, Any?>?) {
        appContext = context.applicationContext
        config = TelecomConfig.fromConfiguration(context, configuration)
        isConfigResolved = true
        TelecomConfig.persist(context, config)
        Log.d(TAG, "[init] telecom enabled=${config.enabled}, schema=${config.schema}")

        // Warm up the repository here rather than on the first incoming call. Creating it registers
        // the app with Telecom, which is a one-off cost we do not want on the ringing path. 
        val appContext = context.applicationContext
        scope.launch {
            if (isEnabled(appContext)) requireRepository(appContext)
        }
    }

    private fun ensureInitialized(context: Context) {
        if (appContext == null) {
            appContext = context.applicationContext
        }
        if (isConfigResolved) return

        synchronized(this) {
            if (isConfigResolved) return
            config = TelecomConfig.load(context)
            isConfigResolved = true
        }
    }

    /** Whether calls should be handed to Telecom on this device with the current configuration. */
    fun isEnabled(context: Context): Boolean {
        ensureInitialized(context)
        return config.enabled && TelecomPermissions.canUseTelecom(context)
    }

    @SuppressLint("NewApi")
    private fun requireRepository(context: Context): TelecomCallRepository? {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return null

        repository?.let { return it }
        return synchronized(this) {
            repository ?: try {
                TelecomCallRepository(context.applicationContext)
                    .also { it.setListener(repositoryListener) }
                    .also { it.warmUp() }
                    .also { repository = it }
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
    fun registerIncomingCall(context: Context, data: Data) = register(context, data, incoming = true)

    /** Registers an outgoing call with Telecom and immediately makes it active. */
    fun registerOutgoingCall(context: Context, data: Data) =
        register(context, data, incoming = false)

    private fun describeAvailability(context: Context): String = when {
        !config.enabled -> "turned off through AndroidPushConfiguration.telecom"
        !TelecomPermissions.isSupportedApiLevel() ->
            "unsupported API level ${Build.VERSION.SDK_INT}, needs 26+"
        !TelecomPermissions.hasPermissions(context) -> "MANAGE_OWN_CALLS not granted"
        !TelecomPermissions.supportsTelecom(context) ->
            "no telephony feature or default dialer (pre-Android 17 requirement)"
        else -> "available"
    }

    @SuppressLint("NewApi", "MissingPermission")
    private fun register(context: Context, data: Data, incoming: Boolean) {
        if (!isEnabled(context)) {
            Log.d(TAG, "[register] skipped: ${describeAvailability(context)}")
            return
        }
        val repository = requireRepository(context) ?: return

        val callId = data.id
        if (callId.isBlank()) {
            Log.w(TAG, "[register] missing call id, skipping telecom registration")
            return
        }

        trackedCallData[callId] = data
        if (!incoming) outgoingCallIds.add(callId)

        if (repository.getCall(callId) != null || !registeringCallIds.add(callId)) {
            Log.w(TAG, "[register] $callId already registered with telecom")
            return
        }

        Log.d(
            TAG,
            "[register] ${if (incoming) "incoming" else "outgoing"} call $callId as " +
                "${addressOf(data)} (video=${data.type == 1})",
        )

        scope.launch {
            try {
                repository.registerCall(
                    callId = callId,
                    displayName = displayNameOf(data),
                    address = addressOf(data),
                    isIncoming = incoming,
                    isVideo = data.type == 1,
                )
            } catch (error: Exception) {
                Log.e(TAG, "[register] registration of $callId failed", error)
            } finally {
                cleanUp(callId)
            }
        }
    }

    private fun displayNameOf(data: Data): String = data.callerName
        .takeIf { it.isNotBlank() }
        ?: data.handle.takeIf { it.isNotBlank() }
        ?: "Unknown Caller"

    private fun addressOf(data: Data): Uri {
        val identifier = (data.extra["callCid"] as? String)?.takeIf { it.isNotBlank() } ?: data.id
        return Uri.parse("${config.schema}:$identifier")
    }

    // endregion

    // region actions

    /** True once [register] has run for this call and before it was cleaned up. */
    private fun isTracked(callId: String) = trackedCallData.containsKey(callId)

    /** Answers a call in Telecom. Idempotent, so it is safe on both app- and system-originated accepts. */
    fun answer(context: Context, callId: String) {
        if (!isEnabled(context) || !isTracked(callId)) return
        // A system-originated answer already marked the call, so this is the echo of our own
        // broadcast and there is nothing left to ask Telecom for.
        if (!connectedCallIds.add(callId)) return
        processAction(context, callId, TelecomCallAction.Answer)
    }

    /** Disconnects a call in Telecom with a cause matching the reason the ringing flow ended. */
    fun disconnect(context: Context, callId: String, cause: Int) {
        if (!isEnabled(context)) return
        processAction(context, callId, TelecomCallAction.Disconnect(DisconnectCause(cause)))
    }

    /** Marks a call as active, used once an outgoing or accepted call is connected. */
    fun activate(context: Context, callId: String) {
        if (!isEnabled(context)) return
        processAction(context, callId, TelecomCallAction.Activate)
    }

    fun setOnHold(context: Context, callId: String, isOnHold: Boolean) {
        if (!isEnabled(context) || !isTracked(callId)) return
        selfRequestedHold[callId] = isOnHold
        processAction(
            context,
            callId,
            if (isOnHold) TelecomCallAction.Hold else TelecomCallAction.Activate,
        )
    }

    /** Disconnects every call Telecom still knows about. */
    fun disconnectAll(context: Context, cause: Int) {
        if (!isEnabled(context)) return
        val repository = repository ?: return
        repository.calls.value.keys.toList().forEach { disconnect(context, it, cause) }
        registeringCallIds.toList().forEach { disconnect(context, it, cause) }
    }

    @SuppressLint("NewApi")
    private fun processAction(context: Context, callId: String, action: TelecomCallAction) {
        requireRepository(context) ?: return
        processAction(callId, action)
    }

    @SuppressLint("NewApi")
    private fun processAction(callId: String, action: TelecomCallAction) {
        val repository = repository ?: return

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

                // Registration is still in flight; queue and replay once the scope is up. This is
                // the race the React Native implementation solves with its pending-action queue.
                call != null || registeringCallIds.contains(callId) -> {
                    pendingActions
                        .getOrPut(callId) { Collections.synchronizedList(mutableListOf()) }
                        .add(action)
                }

                else -> Log.d(TAG, "[processAction] $callId is not known to telecom, ignoring")
            }
        }
    }

    private fun drainPendingActions(callId: String) {
        val repository = repository ?: return

        synchronized(actionLock) {
            val call = repository.getCall(callId) ?: return
            val actions = pendingActions.remove(callId) ?: return
            val snapshot = synchronized(actions) { actions.toList() }

            // A queued disconnect wins over everything else that piled up behind it.
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
        selfRequestedHold.remove(callId)
        trackedCallData.remove(callId)
    }

    /**
     * Releases the Telecom registration, but only when nothing is in flight.
     *
     * This is what engine detach calls. The unguarded [release] must not be used there: a Flutter
     * app's background isolate attaches and detaches routinely, including while a call is ringing
     * or connected, and tearing Telecom down then would drop a call the user is still in.
     */
    @SuppressLint("NewApi")
    fun releaseIfIdle() {
        if (trackedCallData.isNotEmpty() || repository?.hasAnyCalls() == true) {
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
        selfRequestedHold.clear()
        trackedCallData.clear()
    }

    // endregion

    // region repository callbacks

    private val repositoryListener = object : TelecomCallListener {

        override fun onCallRegistered(callId: String, incoming: Boolean) {
            registeringCallIds.remove(callId)
            drainPendingActions(callId)

            Log.d(TAG, "[onCallRegistered] $callId registered with telecom, incoming=$incoming")

            if (incoming) {
                // The ringing foreground service was very likely promoted before this
                // registration finished, so re-promote it now that the call exists in the Telecom
                // stack and the platform can grant it while-in-use capabilities.
                IncomingCallNotificationService.repromoteRingingForeground()
            } else {
                // An outgoing call stays in the dialing state until it is explicitly activated.
                // The Android SDK does this on a fixed delay after registering; doing it once the
                // scope is actually up avoids racing that timer.
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
            // Only react to answers coming from outside the app (watch, car, headset). Our own
            // accepts already went through the broadcast flow that triggered this action.
            if (source != TelecomEventSource.SYS) return

            val context = appContext ?: return
            val data = trackedCallData[callId] ?: return
            context.sendBroadcast(
                IncomingCallBroadcastReceiver.getIntentAccept(context, data.toBundle()),
            )
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
            // An outgoing call is never "answered" from this side, so it would otherwise fall
            // through to the decline branch below.
            val endsRatherThanDeclines =
                connectedCallIds.contains(callId) || outgoingCallIds.contains(callId)
            val data = trackedCallData[callId]
            cleanUp(callId)

            if (source != TelecomEventSource.SYS) return

            val context = appContext ?: return
            if (data == null) return

            val bundle = data.toBundle()
            val intent = if (endsRatherThanDeclines) {
                // Marked as coming from the platform call UI. A plain ended event is ambiguous on
                // Android, where it also means the notification was dismissed, so the Dart side
                // ignores it; a hang-up from a watch, headset or head unit is authoritative and
                // has to leave the call.
                bundle.putBoolean(IncomingCallConstants.EXTRA_CALL_ENDED_BY_SYSTEM, true)
                IncomingCallBroadcastReceiver.getIntentEnded(context, bundle)
            } else {
                IncomingCallBroadcastReceiver.getIntentDecline(context, bundle)
            }
            context.sendBroadcast(intent)
        }

        // State is updated before the suppression check in both handlers, so heldCallIds stays
        // accurate even when the event itself is withheld.
        override fun onIsCallActive(callId: String) {
            // A call also becomes active on connect and on answer, both of which mean it can no
            // longer be disconnected as a decline.
            connectedCallIds.add(callId)
            val wasHeld = heldCallIds.remove(callId)
            if (selfRequestedHold.remove(callId, false)) return
            if (!wasHeld) return
            sendEvent(IncomingCallConstants.ACTION_CALL_TOGGLE_HOLD, callId, "isOnHold" to false)
        }

        override fun onIsCallInactive(callId: String) {
            val isNewHold = heldCallIds.add(callId)
            if (selfRequestedHold.remove(callId, true)) return
            if (!isNewHold) return
            sendEvent(IncomingCallConstants.ACTION_CALL_TOGGLE_HOLD, callId, "isOnHold" to true)
        }

        override fun onMuteCallChanged(callId: String, isMuted: Boolean) {
            sendEvent(IncomingCallConstants.ACTION_CALL_TOGGLE_MUTE, callId, "isMuted" to isMuted)
        }

        override fun onHoldChangeFailed(callId: String, requestedOnHold: Boolean) {
            // The request was refused, so the transition it was waiting to suppress never comes.
            // Leaving the flag set would swallow the next system-originated hold on this call, and
            // clearing one that belongs to a different request would do the same.
            selfRequestedHold.remove(callId, requestedOnHold)
        }

        override fun onCallAudioEndpointsChanged(callId: String, snapshot: Map<String, Any?>) {
            sendEvent(
                IncomingCallConstants.ACTION_CALL_CUSTOM,
                callId,
                "type" to CUSTOM_EVENT_AUDIO_ENDPOINTS,
                "audio" to snapshot,
            )
        }

        private fun sendEvent(event: String, callId: String, vararg values: Pair<String, Any?>) {
            // Honour the same gate the broadcast-driven events go through, so silenceEvents() means
            // silence for Telecom-originated events too.
            if (IncomingCallBroadcastReceiver.silenceEvents) return

            StreamVideoPushNotificationPlugin.sendEvent(
                event,
                mapOf("id" to callId) + values.toMap(),
            )
        }
    }

    // endregion
}
