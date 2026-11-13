package io.getstream.video.flutter.stream_video_push_notification

import android.app.Application
import androidx.test.core.app.ApplicationProvider
import io.getstream.video.flutter.stream_video_push_notification.telecom.StreamTelecomManager
import io.mockk.every
import io.mockk.mockkObject
import io.mockk.unmockkObject
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner

/**
 * Pins what the plugin's method channel answers, observed through a fake engine attached to the
 * real channels.
 */
@RunWith(RobolectricTestRunner::class)
class StreamVideoPushNotificationPluginTest {

    private val context: Application get() = ApplicationProvider.getApplicationContext()

    private lateinit var dart: FakeDartSide

    @Before
    fun attachPlugin() {
        resetPlugin()
        dart = FakeDartSide(context)
        mockkObject(StreamTelecomManager)
    }

    @After
    fun detachPlugin() {
        unmockkObject(StreamTelecomManager)
        resetPlugin()
    }

    @Test
    fun `isMuted answers the mute state Telecom reported for the call`() {
        every { StreamTelecomManager.isMuted(CALL_ID) } returns true
        assertEquals(true, dart.invoke("isMuted", mapOf("id" to CALL_ID)))

        every { StreamTelecomManager.isMuted(CALL_ID) } returns false
        assertEquals(false, dart.invoke("isMuted", mapOf("id" to CALL_ID)))
    }

    @Test
    fun `isMuted answers false for a call Telecom does not hold`() {
        // The real lookup: nothing registered this id with Telecom.
        assertEquals(false, dart.invoke("isMuted", mapOf("id" to CALL_ID)))
    }

    @Test
    fun `isMuted answers false without a call id`() {
        assertEquals(false, dart.invoke("isMuted", emptyMap<String, Any?>()))
        assertEquals(false, dart.invoke("isMuted"))
    }

    /** Forgets the plugin's process-wide instance, so each test attaches with its own context. */
    private fun resetPlugin() {
        StreamVideoPushNotificationPlugin::class.java.getDeclaredField("instance").apply {
            isAccessible = true
            set(null, null)
        }
    }

    private companion object {
        const val CALL_ID = "call-uuid"
    }
}
