package io.getstream.video.flutter.stream_video_push_notification.telecom

import android.content.Context
import android.os.Build
import androidx.test.core.app.ApplicationProvider
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallConstants
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.util.ReflectionHelpers

/**
 * Pins how the Telecom configuration is read from the `android.telecom` section Dart sends with
 * `initData`, how it is persisted for cold starts, and the platform default on both sides of
 * Android 17. The tests run on SDK 34 (`robolectric.properties`); the Android 17 side is reached
 * by setting `Build.VERSION.SDK_INT` for one test, since no Robolectric SDK is that new yet.
 */
@RunWith(RobolectricTestRunner::class)
class TelecomConfigTest {

    private val context get() = ApplicationProvider.getApplicationContext<Context>()

    private fun configuration(telecom: Map<String, Any?>?) = mapOf(
        "android" to mapOf("telecom" to telecom),
    )

    @Test
    fun `reads an explicit enabled flag and schema`() {
        val config = TelecomConfig.fromConfiguration(
            context,
            configuration(mapOf("enabled" to true, "schema" to "myapp")),
        )

        assertTrue(config.enabled)
        assertEquals("myapp", config.schema)
    }

    @Test
    fun `an absent telecom section falls back to the platform default and the package name`() {
        val config = TelecomConfig.fromConfiguration(context, configuration(null))

        // The platform default is off on SDK 34, see `below Android 17 the platform default is off`.
        assertFalse(config.enabled)
        assertEquals(PACKAGE_SCHEME, config.schema)
    }

    @Test
    fun `a missing configuration altogether behaves the same`() {
        val config = TelecomConfig.fromConfiguration(context, null)

        assertFalse(config.enabled)
        assertEquals(PACKAGE_SCHEME, config.schema)
    }

    @Test
    fun `an explicit opt-out wins over the platform default`() {
        val config = TelecomConfig.fromConfiguration(context, configuration(mapOf("enabled" to false)))

        assertFalse(config.enabled)
    }

    @Test
    fun `a blank schema falls back to the package name`() {
        val config = TelecomConfig.fromConfiguration(context, configuration(mapOf("schema" to "  ")))

        assertEquals(PACKAGE_SCHEME, config.schema)
    }

    @Test
    fun `the schema is folded into a valid URI scheme`() {
        val underscore = TelecomConfig.fromConfiguration(context, configuration(mapOf("schema" to "my_app")))
        assertEquals("my-app", underscore.schema)

        val leadingDigit = TelecomConfig.fromConfiguration(context, configuration(mapOf("schema" to "1app")))
        assertEquals("stream-1app", leadingDigit.schema)

        val allowed = TelecomConfig.fromConfiguration(context, configuration(mapOf("schema" to "my+app-v2.x")))
        assertEquals("my+app-v2.x", allowed.schema)
    }

    @Test
    fun `below Android 17 the platform default is off`() {
        // SDK 34, from robolectric.properties.
        assertFalse(TelecomConfig.defaultEnabled())
    }

    @Test
    fun `from Android 17 the platform default is on`() {
        withSdkInt(IncomingCallConstants.SDK_INT_CINNAMON_BUN) {
            assertTrue(TelecomConfig.defaultEnabled())
            assertTrue(TelecomConfig.fromConfiguration(context, configuration(null)).enabled)
            // An explicit opt-out still wins there.
            assertFalse(TelecomConfig.fromConfiguration(context, configuration(mapOf("enabled" to false))).enabled)
        }
    }

    private fun withSdkInt(sdkInt: Int, block: () -> Unit) {
        val original = Build.VERSION.SDK_INT
        ReflectionHelpers.setStaticField(Build.VERSION::class.java, "SDK_INT", sdkInt)
        try {
            block()
        } finally {
            ReflectionHelpers.setStaticField(Build.VERSION::class.java, "SDK_INT", original)
        }
    }

    @Test
    fun `persist and load round-trip, and load without a stored value gives the defaults`() {
        TelecomConfig.persist(context, TelecomConfig(enabled = true, schema = "myapp"))
        assertEquals(TelecomConfig(enabled = true, schema = "myapp"), TelecomConfig.load(context))

        TelecomConfig.persist(context, TelecomConfig(enabled = false, schema = "other"))
        assertEquals(TelecomConfig(enabled = false, schema = "other"), TelecomConfig.load(context))

        // An absent key resolves to the platform default (off on SDK 34), not to an opt-out.
        TelecomConfig.persist(context, TelecomConfig(enabled = true, schema = ""))
        context.getSharedPreferences("stream_video_incoming_call_preferences", Context.MODE_PRIVATE)
            .edit().clear().commit()
        val loaded = TelecomConfig.load(context)
        assertFalse(loaded.enabled)
        assertEquals(PACKAGE_SCHEME, loaded.schema)
    }

    @Test
    fun `persist with a null context stores nothing`() {
        TelecomConfig.persist(null, TelecomConfig(enabled = true, schema = "myapp"))

        // Nothing was stored, so loading gives the defaults, not what was passed.
        assertEquals(TelecomConfig(enabled = false, schema = PACKAGE_SCHEME), TelecomConfig.load(context))
    }

    @Test
    fun `the package name the default scheme comes from`() {
        // Guards the literal below. The unit tests run as the module's test package, whose
        // underscores a URI scheme does not allow.
        assertEquals("io.getstream.video.flutter.stream_video_push_notification.test", context.packageName)
    }

    private companion object {
        /** The scheme the package name yields when no schema is configured. */
        const val PACKAGE_SCHEME = "io.getstream.video.flutter.stream-video-push-notification.test"
    }
}
