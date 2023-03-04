/*
 * Copyright (c) 2014-2022 Stream.io Inc. All rights reserved.
 *
 * Licensed under the Stream License;
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    https://github.com/GetStream/stream-video-android/blob/main/LICENSE
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package io.getstream.video.flutter.background.stream_video_flutter_background.service

import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.IBinder
import io.getstream.log.taggedLogger
import io.getstream.video.flutter.background.stream_video_flutter_background.R
import io.getstream.video.flutter.background.stream_video_flutter_background.service.notification.NotificationOptions
import io.getstream.video.flutter.background.stream_video_flutter_background.service.notification.StreamNotificationBuilder
import io.getstream.video.flutter.background.stream_video_flutter_background.service.notification.StreamNotificationBuilderImpl
import io.getstream.video.flutter.background.stream_video_flutter_background.service.utils.notificationManager
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.cancel

open class StreamCallService : Service() {

    private val logger by taggedLogger("StreamCallService")

    private val scope = CoroutineScope(Dispatchers.Default)

    private val notificationManager: NotificationManager by lazy { application.notificationManager }


    private val notificationBuilder: StreamNotificationBuilder by lazy {
        createNotificationBuilder(application)
    }

    private val options: NotificationOptions get() {
        val options = notificationOptions
        if (options.callCid.isEmpty()) {
            error("[StreamCallService.callCid] NotificationOptions.callCid must not be empty")
        }
        return options
    }

    protected open fun createNotificationBuilder(context: Context): StreamNotificationBuilder =
        StreamNotificationBuilderImpl(context, scope) {
            R.id.stream_call_notification
        }

    override fun onCreate() {
        super.onCreate()
        isRunning = true

        logger.i { "[onCreate] no args" }
        startForeground()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        logger.i { "[onStartCommand] startId: $startId, flags: $flags, action: ${intent?.action}, intent: $intent" }
        if (intent?.action == ACTION_UPDATE) {
            updateNotification()
        }
        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        stopForeground(true)
        logger.i { "[onDestroy] no args" }
        scope.cancel()
        isRunning = false
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun startForeground() {
        logger.v { "[startForeground] notificationOptions: $options" }
        val (notificationId, notification) = notificationBuilder.build(options)
        startForeground(notificationId, notification)
    }

    private fun updateNotification() {
        logger.v { "[updateNotification] notificationOptions: $options" }
        val (notificationId, notification) = notificationBuilder.build(options)
        notificationManager.notify(notificationId, notification)
    }

    companion object {
        var isRunning = false

        var notificationOptions = NotificationOptions()

        internal const val ACTION_UPDATE = "UPDATE"
    }
}


