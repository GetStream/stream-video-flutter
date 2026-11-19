package io.getstream.video.flutter.stream_video_push_notification

import android.content.Context
import android.content.res.Resources
import com.fasterxml.jackson.databind.ObjectMapper
import java.lang.ref.WeakReference


class Utils {

    companion object {

        private var mapper: ObjectMapper? = null


        fun getGsonInstance(): ObjectMapper {
            if (mapper == null) {
                mapper = ObjectMapper()
            }
            return mapper!!
        }

        @JvmStatic
        fun dpToPx(dp: Float): Float {
            return dp * Resources.getSystem().displayMetrics.density
        }

        @JvmStatic
        fun getScreenWidth(): Int {
            return Resources.getSystem().displayMetrics.widthPixels
        }

        fun getNavigationBarHeight(context: Context): Int {
            val resources = context.resources
            val id = resources.getIdentifier(
                    "navigation_bar_height", "dimen", "android"
            )
            return if (id > 0) {
                resources.getDimensionPixelSize(id)
            } else 0
        }

        fun getStatusBarHeight(context: Context): Int {
            val resources = context.resources
            val id: Int =
                    resources.getIdentifier("status_bar_height", "dimen", "android")
            return if (id > 0) {
                resources.getDimensionPixelSize(id)
            } else 0
        }

        fun <T, C : MutableCollection<WeakReference<T>>> C.reapCollection(): C {
            this.removeAll {
                it.get() == null
            }
            return this
        }

        fun isTablet(context: Context): Boolean {
            return context.resources.getBoolean(R.bool.isTablet)
        }
    }
}
