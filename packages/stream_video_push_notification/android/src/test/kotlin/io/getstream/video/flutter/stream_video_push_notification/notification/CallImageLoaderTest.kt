package io.getstream.video.flutter.stream_video_push_notification.notification

import android.os.Bundle
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallConstants
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner

/** Pins how an image path and the call's headers become a request. */
@RunWith(RobolectricTestRunner::class)
class CallImageLoaderTest {

    @Test
    fun `an http or https URL is used as it is, in any case`() {
        assertEquals("https://x.io/a.png", CallImageLoader.resolve("https://x.io/a.png"))
        assertEquals("HTTP://x.io/a.png", CallImageLoader.resolve("HTTP://x.io/a.png"))
    }

    @Test
    fun `any other path is a Flutter asset`() {
        assertEquals(
            "file:///android_asset/flutter_assets/assets/a.png",
            CallImageLoader.resolve("assets/a.png"),
        )
    }

    @Test
    fun `a null or empty path loads nothing`() {
        assertNull(CallImageLoader.resolve(null))
        assertNull(CallImageLoader.resolve(""))
    }

    @Test
    fun `the avatar falls back to the default avatar only when empty`() {
        assertEquals("https://x.io/a.png", CallImageLoader.avatarUrl("https://x.io/a.png", "d.png"))
        assertEquals(
            "file:///android_asset/flutter_assets/d.png",
            CallImageLoader.avatarUrl("", "d.png"),
        )
        assertNull(CallImageLoader.avatarUrl("", ""))
        assertNull(CallImageLoader.avatarUrl(null, null))
    }

    @Test
    fun `headers keep their values as strings and drop nulls`() {
        val data = Bundle().apply {
            putSerializable(
                IncomingCallConstants.EXTRA_CALL_HEADERS,
                hashMapOf<String, Any?>("Authorization" to "token", "X-Retry" to 3, "X-None" to null),
            )
        }

        assertEquals(
            mapOf("Authorization" to "token", "X-Retry" to "3"),
            CallImageLoader.headers(data),
        )
    }

    @Test
    fun `a call without headers sends none`() {
        assertEquals(emptyMap<String, String>(), CallImageLoader.headers(Bundle()))
    }
}
