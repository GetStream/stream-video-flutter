package io.getstream.video.flutter.stream_video_push_notification.telecom

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.telecom.TelecomManager
import androidx.core.content.ContextCompat
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallConstants

/**
 * Capability and permission checks required before handing a call to the Telecom stack.
 */
internal object TelecomPermissions {

    /**
     * `androidx.core.telecom` requires API 26 to register an app with Telecom.
     */
    fun isSupportedApiLevel(): Boolean = Build.VERSION.SDK_INT >= Build.VERSION_CODES.O

    fun hasPermissions(context: Context): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return true
        return ContextCompat.checkSelfPermission(
            context,
            Manifest.permission.MANAGE_OWN_CALLS,
        ) == PackageManager.PERMISSION_GRANTED
    }

    /**
     * Set once the device has been confirmed capable.
     *
     * `defaultDialerPackage` is an IPC into the system server and [canUseTelecom] runs on the main
     * thread for every ring, accept and decline, so a confirmed yes is worth keeping. Only the yes:
     * `defaultDialerPackage` can still be empty shortly after boot, which is exactly when a
     * push-woken process starts, and caching that no would disable Telecom for the whole process
     * lifetime over a transient answer.
     */
    @Volatile
    private var supportConfirmed: Boolean = false

    /**
     * Whether this device is one we are willing to hand calls to.
     *
     * From Android 17 this only checks the API level, because the integration is what makes
     * ringing work there: anything else turned off would take correct ringing with it. The
     * platform agrees — self-managed calls through `CallsManager` need `MANAGE_OWN_CALLS` and
     * nothing more, no telephony stack and no default dialer.
     *
     * Below 17 the extra telephony and default-dialer conditions are kept. They are **stricter
     * than the platform requires** and turn the integration off on Wi-Fi-only tablets where it
     * would most likely work, but they are inherited verbatim from
     * `TelecomPermissions.supportsTelecom` in the Android SDK, their reason is not recorded, and
     * on those versions the integration is opt-in and ringing works without it either way — so
     * there is nothing to gain by relaxing them on a guess.
     */
    fun supportsTelecom(context: Context): Boolean {
        if (Build.VERSION.SDK_INT >= IncomingCallConstants.SDK_INT_CINNAMON_BUN) return true
        if (supportConfirmed) return true
        val packageManager = context.packageManager
        val hasTelephony = packageManager.hasSystemFeature(PackageManager.FEATURE_TELEPHONY)
        val hasDefaultDialer =
            safeTelecomManager(context)?.defaultDialerPackage?.isNotEmpty() == true
        return (hasTelephony && hasDefaultDialer).also { if (it) supportConfirmed = true }
    }

    fun canUseTelecom(context: Context): Boolean =
        isSupportedApiLevel() && supportsTelecom(context) && hasPermissions(context)

    private fun safeTelecomManager(context: Context): TelecomManager? = try {
        context.getSystemService(Context.TELECOM_SERVICE) as? TelecomManager
    } catch (error: Throwable) {
        // Robolectric and some stripped-down ROMs throw instead of returning null.
        null
    }
}
