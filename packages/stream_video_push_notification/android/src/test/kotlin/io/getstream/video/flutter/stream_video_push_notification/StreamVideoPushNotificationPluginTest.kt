package io.getstream.video.flutter.stream_video_push_notification

import android.app.Activity
import android.app.Application
import androidx.test.core.app.ApplicationProvider
import io.getstream.video.flutter.stream_video_push_notification.telecom.StreamTelecomManager
import io.getstream.video.flutter.stream_video_push_notification.telecom.TelecomCall
import io.getstream.video.flutter.stream_video_push_notification.telecom.TelecomCallRepository
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry
import io.getstream.video.flutter.stream_video_push_notification.core.RingingComponents
import io.mockk.CapturingSlot
import io.mockk.every
import io.mockk.mockk
import io.mockk.mockkObject
import io.mockk.slot
import io.mockk.unmockkObject
import io.mockk.verify
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertSame
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.Robolectric
import org.robolectric.RobolectricTestRunner
import org.robolectric.Shadows.shadowOf

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
    fun `the notification permission is asked from the attached activity, until it detaches`() {
        val listener = slot<PluginRegistry.RequestPermissionsResultListener>()
        val first = Robolectric.buildActivity(Activity::class.java).setup().get()
        val second = Robolectric.buildActivity(Activity::class.java).setup().get()
        val firstBinding = activityBinding(first, listener)
        val secondBinding = activityBinding(second, listener)

        dart.plugin.onAttachedToActivity(firstBinding)
        dart.invoke("requestNotificationPermission", emptyMap<String, Any?>())
        assertNotNull(shadowOf(first).lastRequestedPermission)
        assertEquals(
            false,
            listener.captured.onRequestPermissionsResult(1234, arrayOf(), intArrayOf()),
        )

        dart.plugin.onDetachedFromActivityForConfigChanges()
        dart.plugin.onReattachedToActivityForConfigChanges(secondBinding)
        dart.invoke("requestNotificationPermission", emptyMap<String, Any?>())
        assertNotNull(shadowOf(second).lastRequestedPermission)

        dart.plugin.onDetachedFromActivity()
        val lastRequest = shadowOf(second).lastRequestedPermission
        dart.invoke("requestNotificationPermission", emptyMap<String, Any?>())
        assertSame(lastRequest, shadowOf(second).lastRequestedPermission)
        verify { firstBinding.removeRequestPermissionsResultListener(listener.captured) }
        verify { secondBinding.removeRequestPermissionsResultListener(listener.captured) }
    }

    @Test
    fun `Telecom is released only when the last engine detaches`() {
        mockkObject(StreamTelecomManager)
        try {
            val second = FakeDartSide(context)

            second.detach()
            verify(exactly = 0) { StreamTelecomManager.releaseIfIdle() }

            dart.detach()
            verify(exactly = 1) { StreamTelecomManager.releaseIfIdle() }
        } finally {
            unmockkObject(StreamTelecomManager)
        }
    }

    private fun activityBinding(
        activity: Activity,
        listener: CapturingSlot<PluginRegistry.RequestPermissionsResultListener>,
    ): ActivityPluginBinding = mockk(relaxed = true) {
        every { this@mockk.activity } returns activity
        every { addRequestPermissionsResultListener(capture(listener)) } returns Unit
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
