package io.getstream.video.flutter.stream_video_push_notification.permissions

import android.Manifest
import android.app.Activity
import android.content.DialogInterface
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.appcompat.app.AlertDialog
import androidx.core.app.ActivityCompat
import io.getstream.video.flutter.stream_video_push_notification.R

/**
 * Asks for `POST_NOTIFICATIONS` on Android 13 and later. When the user denies it, shows the
 * rationale and asks again, or, once the system no longer shows the prompt, offers the app's
 * settings.
 *
 * The dialog texts come from the map the last [request] was given: `title`,
 * `rationaleMessagePermission` and `postNotificationMessageRequired`.
 */
internal class NotificationPermissionFlow {

    private var messages: Map<String, Any> = emptyMap()

    fun request(activity: Activity?, messages: Map<String, Any>) {
        this.messages = messages
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) return
        activity ?: return
        if (ActivityCompat.checkSelfPermission(activity, Manifest.permission.POST_NOTIFICATIONS) !=
            PackageManager.PERMISSION_GRANTED
        ) {
            ActivityCompat.requestPermissions(
                activity,
                arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                REQUEST_CODE,
            )
        }
    }

    fun onRequestPermissionsResult(activity: Activity?, requestCode: Int, grantResults: IntArray) {
        if (requestCode != REQUEST_CODE) return
        if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            return
        }
        activity ?: return

        val title = messages["title"] as? String
        if (ActivityCompat.shouldShowRequestPermissionRationale(
                activity,
                Manifest.permission.POST_NOTIFICATIONS,
            )
        ) {
            val rationale = messages["rationaleMessagePermission"] as? String
            if (title != null && rationale != null) {
                showDialog(activity, title, rationale) { dialog, _ ->
                    dialog?.dismiss()
                    request(activity, messages)
                }
            } else {
                request(activity, messages)
            }
        } else {
            val required = messages["postNotificationMessageRequired"] as? String
            val useGiven = title != null && required != null
            showDialog(
                activity,
                if (useGiven) title!! else activity.getString(R.string.text_title_post_notification),
                if (useGiven) {
                    required!!
                } else {
                    activity.getString(R.string.text_post_notification_message_required)
                },
            ) { dialog, _ ->
                dialog?.dismiss()
                val intent = Intent(
                    Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                    Uri.fromParts("package", activity.packageName, null),
                )
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                activity.startActivity(intent)
            }
        }
    }

    private fun showDialog(
        activity: Activity,
        title: String,
        message: String,
        okListener: DialogInterface.OnClickListener,
    ) {
        AlertDialog.Builder(activity, R.style.DialogTheme)
            .setTitle(title)
            .setMessage(message)
            .setPositiveButton(android.R.string.ok, okListener)
            .setNegativeButton(android.R.string.cancel, null)
            .create()
            .show()
    }

    companion object {
        const val REQUEST_CODE = 6969
    }
}
