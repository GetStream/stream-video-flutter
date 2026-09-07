package io.getstream.video.flutter.stream_video_push_notification.telecom

import android.content.Context
import android.os.Build
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallConstants
import io.getstream.video.flutter.stream_video_push_notification.getString
import io.getstream.video.flutter.stream_video_push_notification.putStrings

/**
 * Integrator-provided Telecom settings.
 *
 * @param enabled whether calls should be handed to the Android Telecom stack at all. When the
 * integrator says nothing this follows [defaultEnabled]: opt-out from Android 17, where ringing
 * cannot work correctly without it, and opt-in below that, where it can.
 * @param schema URI scheme used to build the call address reported to Telecom, e.g. `myapp` gives
 * an address of `myapp:<callCid>`.
 */
internal data class TelecomConfig(
    val enabled: Boolean,
    val schema: String,
) {

    companion object {
        private const val KEY_ENABLED = "TELECOM_ENABLED"
        private const val KEY_SCHEMA = "TELECOM_SCHEMA"

        val DISABLED = TelecomConfig(enabled = false, schema = "")

        /**
         * Reads the `android.telecom` section of the configuration sent from Dart by
         * `StreamVideoPushNotificationPlatform.init`.
         */
        @Suppress("UNCHECKED_CAST")
        fun fromConfiguration(context: Context, configuration: Map<String, Any?>?): TelecomConfig {
            val android = configuration?.get("android") as? Map<String, Any?>
            // No telecom section at all is not the same as an explicit opt-out, so it falls
            // through to the platform default rather than returning DISABLED.
            val telecom = android?.get("telecom") as? Map<String, Any?> ?: emptyMap()

            val enabled = telecom["enabled"] as? Boolean ?: defaultEnabled()
            val schema = (telecom["schema"] as? String)?.takeIf { it.isNotBlank() }
                ?: defaultSchema(context)

            return TelecomConfig(enabled = enabled, schema = sanitizeSchema(schema))
        }

        /** Persisted so that cold starts from a notification action can still resolve the config. */
        fun persist(context: Context?, config: TelecomConfig) {
            putStrings(
                context,
                KEY_ENABLED to config.enabled.toString(),
                KEY_SCHEMA to config.schema,
            )
        }

        /**
         * Whether Telecom is on when the integrator has expressed no preference.
         *
         * Android 17 refuses to play audio from a service that was started by a push and has no
         * while-in-use capability, and those capabilities are granted by the call being in the
         * Telecom stack. So on 17 and up the ringtone of an incoming call is silently dropped
         * without this, which makes it a default rather than a feature. Below 17 the old path
         * works, so nothing changes for an existing integration.
         */
        fun defaultEnabled(): Boolean =
            Build.VERSION.SDK_INT >= IncomingCallConstants.SDK_INT_CINNAMON_BUN

        fun load(context: Context): TelecomConfig {
            // An empty default, not "false": an absent key means nothing was ever stored, which
            // has to resolve to the platform default and not to an opt-out.
            val enabled = getString(context, KEY_ENABLED, "")?.toBooleanStrictOrNull()
                ?: defaultEnabled()
            val schema = getString(context, KEY_SCHEMA, "")?.takeIf { it.isNotBlank() }
                ?: defaultSchema(context)
            return TelecomConfig(enabled = enabled, schema = sanitizeSchema(schema))
        }

        private fun defaultSchema(context: Context): String = context.packageName

        /**
         * URI schemes only allow `ALPHA *( ALPHA / DIGIT / "+" / "-" / "." )`, while package names
         * may contain underscores, so anything else is folded into `-`.
         */
        private fun sanitizeSchema(schema: String): String {
            val sanitized = schema.map { char ->
                if (char.isLetterOrDigit() || char == '+' || char == '-' || char == '.') char else '-'
            }.joinToString("")

            return if (sanitized.firstOrNull()?.isLetter() == true) sanitized else "stream-$sanitized"
        }
    }
}
