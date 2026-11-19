package io.getstream.video.flutter.stream_video_push_notification.permissions

import android.app.Activity
import android.content.pm.PackageManager
import android.widget.TextView
import androidx.appcompat.app.AlertDialog
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.Robolectric
import org.robolectric.RobolectricTestRunner
import org.robolectric.shadows.ShadowDialog

/** Pins which texts the denied-permission dialog shows. */
@RunWith(RobolectricTestRunner::class)
class NotificationPermissionFlowTest {

    @Test
    fun `a request without an activity keeps the texts of the last real request`() {
        val activity = Robolectric.buildActivity(Activity::class.java).setup().get()
        val flow = NotificationPermissionFlow()

        flow.request(
            activity,
            mapOf("title" to "First", "postNotificationMessageRequired" to "Open settings"),
        )
        // Another engine, with no activity attached, asks too.
        flow.request(
            null,
            mapOf("title" to "Second", "postNotificationMessageRequired" to "Other text"),
        )
        flow.onRequestPermissionsResult(
            activity,
            NotificationPermissionFlow.REQUEST_CODE,
            intArrayOf(PackageManager.PERMISSION_DENIED),
        )

        val dialog = ShadowDialog.getLatestDialog() as AlertDialog
        assertEquals(
            "Open settings",
            dialog.findViewById<TextView>(android.R.id.message)?.text.toString(),
        )
    }
}
