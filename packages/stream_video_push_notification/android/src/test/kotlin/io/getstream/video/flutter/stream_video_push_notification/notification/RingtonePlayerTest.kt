package io.getstream.video.flutter.stream_video_push_notification.notification

import android.app.Application
import android.content.Intent
import android.os.Bundle
import androidx.test.core.app.ApplicationProvider
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.Shadows.shadowOf

/** Pins the screen-off receiver the ringtone registers while it plays. */
@RunWith(RobolectricTestRunner::class)
class RingtonePlayerTest {

    private val context: Application get() = ApplicationProvider.getApplicationContext()

    private fun screenOffReceivers() = shadowOf(context).registeredReceivers.count {
        it.intentFilter.hasAction(Intent.ACTION_SCREEN_OFF)
    }

    @Test
    fun `playing twice registers the screen-off receiver once and a stop removes it`() {
        val player = RingtonePlayer(context)

        player.play(Bundle())
        player.play(Bundle())
        assertEquals(1, screenOffReceivers())

        player.stop()
        assertEquals(0, screenOffReceivers())
    }

    @Test
    fun `stopping without playing does nothing`() {
        RingtonePlayer(context).stop()

        assertEquals(0, screenOffReceivers())
    }
}
