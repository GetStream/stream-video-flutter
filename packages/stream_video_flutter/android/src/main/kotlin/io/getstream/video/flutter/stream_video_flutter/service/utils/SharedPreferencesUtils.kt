package io.getstream.video.flutter.stream_video_flutter.service.utils

import android.content.Context
import android.content.SharedPreferences

private const val PREFERENCES_FILE_NAME = "stream_video_flutter"
private var prefs: SharedPreferences? = null
private var editor: SharedPreferences.Editor? = null

private fun initInstance(context: Context) {
    prefs = context.getSharedPreferences(PREFERENCES_FILE_NAME, Context.MODE_PRIVATE)
    editor = prefs?.edit()
}

fun putBoolean(context: Context?, key: String, value: Boolean) {
    if (context == null) return
    initInstance(context)
    editor?.putBoolean(key, value)
    editor?.commit()
}

fun getBoolean(context: Context?, key: String, defaultValue: Boolean = false): Boolean {
    if (context == null) return defaultValue;
    initInstance(context)
    return prefs?.getBoolean(key, defaultValue) ?: defaultValue
}

fun remove(context: Context?, key: String) {
    if (context == null) return
    initInstance(context)
    editor?.remove(key)
    editor?.commit()
}
