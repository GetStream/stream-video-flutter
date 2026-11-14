package io.getstream.video.flutter.stream_video_push_notification.core

import android.content.Context
import com.fasterxml.jackson.core.type.TypeReference
import io.getstream.video.flutter.stream_video_push_notification.Utils

/**
 * A [CallStore] kept as a JSON list under [KEY] in the plugin's SharedPreferences file, which
 * survives the process.
 *
 * Every change is one read-modify-write under a lock shared by all instances in the process, and
 * is written with `apply()`.
 */
internal class PrefsCallStore(context: Context) : CallStore {

    private val prefs = context.applicationContext
        .getSharedPreferences(PREFERENCES_FILE_NAME, Context.MODE_PRIVATE)

    override fun add(call: RingingCall) = update { calls ->
        val index = calls.indexOfFirst { it.id == call.id }
        if (index >= 0) {
            calls[index] = calls[index].copy(isAccepted = call.isAccepted)
        } else {
            calls += call
        }
    }

    override fun remove(id: String) = update { calls -> calls.removeAll { it.id == id } }

    override fun removeAll() {
        synchronized(lock) { prefs.edit().remove(KEY).apply() }
    }

    override fun byId(id: String): RingingCall? = all().firstOrNull { it.id == id }

    override fun byCallCid(callCid: String): List<RingingCall> =
        all().filter { it.callCid == callCid }

    override fun all(): List<RingingCall> = synchronized(lock) { read() }

    private fun update(change: (MutableList<RingingCall>) -> Unit) {
        synchronized(lock) {
            val calls = read().toMutableList()
            change(calls)
            write(calls)
        }
    }

    private fun read(): List<RingingCall> {
        val json = prefs.getString(KEY, null) ?: return emptyList()
        val entries: List<Map<String, Any?>> =
            Utils.getGsonInstance().readValue(json, ENTRIES_TYPE)
        return entries.map(CallPayloadMapper::fromStoredMap)
    }

    private fun write(calls: List<RingingCall>) {
        val json = Utils.getGsonInstance()
            .writeValueAsString(calls.map(CallPayloadMapper::toStoredMap))
        prefs.edit().putString(KEY, json).apply()
    }

    companion object {
        const val PREFERENCES_FILE_NAME = "stream_video_incoming_call_preferences"
        const val KEY = "ACTIVE_CALLS"

        private val lock = Any()
        private val ENTRIES_TYPE = object : TypeReference<List<Map<String, Any?>>>() {}
    }
}
