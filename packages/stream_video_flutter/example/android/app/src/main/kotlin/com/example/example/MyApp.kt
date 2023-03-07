package com.example.example

import android.app.Application
import android.os.Build
import android.util.Log
import androidx.annotation.ChecksSdkIntAtLeast
import io.getstream.log.Priority
import io.getstream.log.StreamLog
import io.getstream.log.StreamLogger
import io.getstream.log.helper.stringify

private const val TAG = "StreamTestApp"

class MyApp : Application() {

    override fun onCreate() {
        super.onCreate()
        StreamLog.setValidator { _, _ -> true }
        StreamLog.install(AndroidStreamLogger())
        StreamLog.i(TAG) { "[onCreate] no args" }
    }
}

private class AndroidStreamLogger constructor(
    private val maxTagLength: Int = DEFAULT_MAX_TAG_LENGTH,
) : StreamLogger {

    override fun log(priority: Priority, tag: String, message: String, throwable: Throwable?) {
        val androidPriority = priority.toAndroidPriority()
        val androidTag = tag.takeIf { it.length > maxTagLength && !isNougatOrHigher() }
            ?.substring(0, maxTagLength)
            ?: tag

        val thread = Thread.currentThread().run { "$name:$id" }
        val composed = "($thread) $message"
        val finalMessage = throwable?.let {
            "$composed\n${it.stringify()}"
        } ?: composed

        Log.println(androidPriority, androidTag, finalMessage)
    }

    private fun Priority.toAndroidPriority(): Int {
        return when (this) {
            Priority.VERBOSE -> Log.VERBOSE
            Priority.DEBUG -> Log.DEBUG
            Priority.INFO -> Log.INFO
            Priority.WARN -> Log.WARN
            Priority.ERROR -> Log.ERROR
            Priority.ASSERT -> Log.ASSERT
            else -> Log.ERROR
        }
    }

    @ChecksSdkIntAtLeast(api = Build.VERSION_CODES.N)
    private fun isNougatOrHigher() = Build.VERSION.SDK_INT >= Build.VERSION_CODES.N

    companion object {
        internal const val DEFAULT_MAX_TAG_LENGTH = 23
    }
}
