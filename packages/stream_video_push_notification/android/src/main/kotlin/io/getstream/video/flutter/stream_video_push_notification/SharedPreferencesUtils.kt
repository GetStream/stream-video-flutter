package io.getstream.video.flutter.stream_video_push_notification

import android.content.Context
import android.content.SharedPreferences

/** The plugin's SharedPreferences file, which holds the stored calls and the Telecom settings. */
internal const val PREFERENCES_FILE_NAME = "stream_video_incoming_call_preferences"

private fun preferences(context: Context): SharedPreferences =
    context.getSharedPreferences(PREFERENCES_FILE_NAME, Context.MODE_PRIVATE)

/** Writes several values in one edit, committed together. */
internal fun putStrings(context: Context?, vararg entries: Pair<String, String?>) {
    if (context == null || entries.isEmpty()) return
    val editor = preferences(context).edit()
    entries.forEach { (key, value) -> editor.putString(key, value) }
    editor.commit()
}

internal fun getString(context: Context?, key: String, defaultValue: String = ""): String? {
    if (context == null) return null
    return preferences(context).getString(key, defaultValue)
}
