package io.getstream.video.flutter.stream_video_push_notification.permissions

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.core.app.NotificationManagerCompat

/** The full-screen intent permission, which Android 14 and later let the user revoke. */
internal class FullScreenIntentPermission(private val context: Context) {

    /** Whether the app may show full-screen intents; always true below Android 14. */
    fun canUse(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.UPSIDE_DOWN_CAKE) return true
        return NotificationManagerCompat.from(context).canUseFullScreenIntent()
    }

    /** Opens the system setting for the permission when the app may not use it. */
    fun request(activity: Activity?) {
        if (canUse()) return
        activity ?: return
        val intent = Intent(Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT).apply {
            data = Uri.fromParts("package", activity.packageName, null)
        }
        activity.startActivity(intent)
    }
}
