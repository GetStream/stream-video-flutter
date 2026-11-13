package io.getstream.video.flutter.stream_video_push_notification.core

/** The calls the plugin is ringing or has accepted, which `activeCalls` reports to Dart. */
internal interface CallStore {

    /**
     * Adds [call]. When a call with the same id is already stored, only its
     * [RingingCall.isAccepted] is updated, to the value [call] carries.
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
