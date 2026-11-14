package io.getstream.video.flutter.stream_video_push_notification

import android.app.Application
import androidx.test.core.app.ApplicationProvider
import io.getstream.video.flutter.stream_video_push_notification.telecom.TelecomIntegration
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry
import io.getstream.video.flutter.stream_video_push_notification.channel.PushMethodCallHandler
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
    fun `the permission listener is removed with the activity and answers only its own code`() {
        val listener = slot<PluginRegistry.RequestPermissionsResultListener>()
        val activityBinding = mockk<ActivityPluginBinding>(relaxed = true) {
            every { activity } returns mockk(relaxed = true)
            every { addRequestPermissionsResultListener(capture(listener)) } returns Unit
        }

        dart.plugin.onAttachedToActivity(activityBinding)
        assertEquals(activityBinding.activity, handlerActivity())
        assertEquals(
            false,
            listener.captured.onRequestPermissionsResult(1234, arrayOf(), intArrayOf()),
        )

        dart.plugin.onDetachedFromActivityForConfigChanges()
        dart.plugin.onReattachedToActivityForConfigChanges(activityBinding)
        dart.plugin.onDetachedFromActivity()

        assertEquals(null, handlerActivity())
        verify(exactly = 2) { activityBinding.addRequestPermissionsResultListener(any()) }
        verify(exactly = 2) {
            activityBinding.removeRequestPermissionsResultListener(listener.captured)
        }
    }

    /** The activity the plugin handed to its method channel handler. */
    private fun handlerActivity(): Any? {
        val handler = StreamVideoPushNotificationPlugin::class.java.getDeclaredField("handler")
            .apply { isAccessible = true }
            .get(dart.plugin) as PushMethodCallHandler
        return handler.activity
    }

    private companion object {
        const val CALL_ID = "call-uuid"
    }
}
