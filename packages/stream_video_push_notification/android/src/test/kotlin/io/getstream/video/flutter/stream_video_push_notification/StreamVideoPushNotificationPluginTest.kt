package io.getstream.video.flutter.stream_video_push_notification

import android.app.Application
import androidx.test.core.app.ApplicationProvider
import io.getstream.video.flutter.stream_video_push_notification.telecom.StreamTelecomManager
import io.getstream.video.flutter.stream_video_push_notification.telecom.TelecomCall
import io.getstream.video.flutter.stream_video_push_notification.telecom.TelecomCallRepository
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry
import io.getstream.video.flutter.stream_video_push_notification.core.RingingComponents
import io.mockk.every
import io.mockk.mockk
import io.mockk.slot
import io.mockk.verify
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
    }

    @After
    fun detachPlugin() {
        setTelecomRepository(null)
        resetPlugin()
    }

    @Test
    fun `isMuted answers the mute state of the call Telecom holds`() {
        val call = mockk<TelecomCall.Registered>()
        setTelecomRepository(mockk { every { getCall(CALL_ID) } returns call })

        every { call.isMuted } returns true
        assertEquals(true, dart.invoke("isMuted", mapOf("id" to CALL_ID)))

        every { call.isMuted } returns false
        assertEquals(false, dart.invoke("isMuted", mapOf("id" to CALL_ID)))
    }

    @Test
    fun `isMuted answers false for a call Telecom does not hold`() {
        setTelecomRepository(mockk { every { getCall(CALL_ID) } returns null })

        assertEquals(false, dart.invoke("isMuted", mapOf("id" to CALL_ID)))
    }

    @Test
    fun `isMuted answers false while the Telecom integration has no repository`() {
        setTelecomRepository(null)

        assertEquals(false, dart.invoke("isMuted", mapOf("id" to CALL_ID)))
    }

    @Test
    fun `isMuted answers false without a call id`() {
        assertEquals(false, dart.invoke("isMuted", emptyMap<String, Any?>()))
        assertEquals(false, dart.invoke("isMuted"))
    }

    @Test
    fun `two engines both get an event, and a detached engine no longer does`() {
        val second = FakeDartSide(context)

        RingingComponents.get(context).events.send("event", mapOf("id" to CALL_ID))
        assertEquals(1, dart.receivedEvents().size)
        assertEquals(1, second.receivedEvents().size)

        second.detach()
        RingingComponents.get(context).events.send("event", mapOf("id" to CALL_ID))
        assertEquals(2, dart.receivedEvents().size)
        assertEquals(1, second.receivedEvents().size)
    }

    @Test
    fun `the permission listener is removed with the activity and answers only its own code`() {
        val listener = slot<PluginRegistry.RequestPermissionsResultListener>()
        val activityBinding = mockk<ActivityPluginBinding>(relaxed = true) {
            every { activity } returns mockk(relaxed = true)
            every { addRequestPermissionsResultListener(capture(listener)) } returns Unit
        }

        dart.plugin.onAttachedToActivity(activityBinding)
        assertEquals(
            false,
            listener.captured.onRequestPermissionsResult(1234, arrayOf(), intArrayOf()),
        )

        dart.plugin.onDetachedFromActivityForConfigChanges()
        dart.plugin.onReattachedToActivityForConfigChanges(activityBinding)
        dart.plugin.onDetachedFromActivity()

        verify(exactly = 2) { activityBinding.addRequestPermissionsResultListener(any()) }
        verify(exactly = 2) {
            activityBinding.removeRequestPermissionsResultListener(listener.captured)
        }
    }

    /** Replaces the repository [StreamTelecomManager] reads, which it otherwise builds itself. */
    private fun setTelecomRepository(repository: TelecomCallRepository?) {
        StreamTelecomManager::class.java.getDeclaredField("repository").apply {
            isAccessible = true
            set(null, repository)
        }
    }

    private companion object {
        const val CALL_ID = "call-uuid"
    }
}
