package io.getstream.video.flutter.stream_video_push_notification

import android.content.Context
import android.content.SharedPreferences
import io.getstream.video.flutter.stream_video_push_notification.core.PrefsCallStore

private fun preferences(context: Context): SharedPreferences =
    context.getSharedPreferences(PrefsCallStore.PREFERENCES_FILE_NAME, Context.MODE_PRIVATE)

/**
 * Writes several values in one edit.
 *
 * Values that belong together stay consistent, and the whole write costs a single commit instead
 * of one blocking disk write per key.
 */
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
