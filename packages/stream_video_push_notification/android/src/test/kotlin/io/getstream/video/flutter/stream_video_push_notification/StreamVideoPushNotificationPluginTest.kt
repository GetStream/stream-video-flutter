package io.getstream.video.flutter.stream_video_push_notification

import android.app.Activity
import android.app.Application
import androidx.test.core.app.ApplicationProvider
import io.getstream.video.flutter.stream_video_push_notification.telecom.TelecomIntegration
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry
import io.getstream.video.flutter.stream_video_push_notification.core.RingingComponents
import io.mockk.CapturingSlot
import io.mockk.every
import io.mockk.mockk
import io.mockk.slot
import io.mockk.verify
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
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

    private lateinit var telecom: TelecomIntegration

    @Before
    fun attachPlugin() {
        RingingComponents.reset()
        telecom = mockTelecom()
        dart = FakeDartSide(context)
    }

    @After
    fun detachPlugin() {
        RingingComponents.reset()
    }

    @Test
    fun `isMuted answers the mute state Telecom reports for the call`() {
        every { telecom.isMuted(CALL_ID) } returns true
        assertEquals(true, dart.invoke("isMuted", mapOf("id" to CALL_ID)))

        every { telecom.isMuted(CALL_ID) } returns false
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
        verify { firstBinding.removeRequestPermissionsResultListener(listener.captured) }
        verify { secondBinding.removeRequestPermissionsResultListener(listener.captured) }
    }

    @Test
    fun `Telecom is released only when the last engine detaches`() {
        val second = FakeDartSide(context)

        second.detach()
        verify(exactly = 0) { telecom.releaseIfIdle() }

        dart.detach()
        verify(exactly = 1) { telecom.releaseIfIdle() }
    }

    private fun activityBinding(
        activity: Activity,
        listener: CapturingSlot<PluginRegistry.RequestPermissionsResultListener>,
    ): ActivityPluginBinding = mockk(relaxed = true) {
        every { this@mockk.activity } returns activity
        every { addRequestPermissionsResultListener(capture(listener)) } returns Unit
    }

    private companion object {
        const val CALL_ID = "call-uuid"
    }
}
