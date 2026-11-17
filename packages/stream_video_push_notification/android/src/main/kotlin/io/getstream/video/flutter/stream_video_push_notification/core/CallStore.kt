package io.getstream.video.flutter.stream_video_push_notification.core

/** The calls the plugin is ringing or has accepted, which `activeCalls` reports to Dart. */
internal interface CallStore {

    /**
     * Adds [call]. When a call with the same id is already stored, the stored call is kept and
     * only marked accepted when [call] is: a call once accepted stays accepted, so a repeated
     * incoming for it does not turn it back into a ringing call.
     */
    fun add(call: RingingCall)

    /** Removes the call with [id], if stored. */
    fun remove(id: String)

    fun removeAll()

    fun byId(id: String): RingingCall?

    /** The stored calls whose [RingingCall.callCid] is [callCid], in the order they were added. */
    fun byCallCid(callCid: String): List<RingingCall>

    /** Every stored call, in the order they were added. */
    fun all(): List<RingingCall>
}
