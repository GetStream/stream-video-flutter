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
import io.getstream.video.flutter.background.stream_video_flutter_background.service.notification.StreamNotificationBuilder
import io.getstream.video.flutter.background.stream_video_flutter_background.service.notification.StreamNotificationBuilderImpl
import io.getstream.video.flutter.background.stream_video_flutter_background.R
import io.getstream.video.flutter.background.stream_video_flutter_background.service.notification.StreamCallCid
import io.getstream.video.flutter.background.stream_video_flutter_background.service.utils.notificationManager
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch

public open class StreamCallService : Service() {

    private val logger by taggedLogger("Call:StreamService")

    private val scope = CoroutineScope(Dispatchers.Default)

    private val notificationManager: NotificationManager by lazy { application.notificationManager }


    private val notificationBuilder: StreamNotificationBuilder by lazy {
        createNotificationBuilder(application)
    }

    protected open fun createNotificationBuilder(context: Context): StreamNotificationBuilder =
        StreamNotificationBuilderImpl(context, scope) {
            R.id.stream_call_notification
        }

    override fun onCreate() {
        super.onCreate()


        logger.i { "[onCreate] no args" }
        startForeground(callCid = "")
        scope.launch {

        }
        isRunning = true
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {


        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        logger.i { "[onDestroy] no args" }
        scope.cancel()
        isRunning = false
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun startForeground(callCid: StreamCallCid) {
        logger.v { "[startForeground] callCid: $callCid" }
        val (notificationId, notification) = notificationBuilder.build(callCid)
        startForeground(notificationId, notification)
    }

    private fun destroySelf() {
        logger.i { "[destroySelf] no args" }
        stopSelf()
    }

    private fun updateNotification(callCid: StreamCallCid) {
        logger.v { "[updateNotification] callCid: $callCid" }
        val (notificationId, notification) = notificationBuilder.build(callCid)
        notificationManager.notify(notificationId, notification)
    }

    companion object {
        var isRunning = false
    }
}


