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

package io.getstream.video.flutter.background.stream_video_flutter_background.service.notification

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import io.getstream.log.taggedLogger
import io.getstream.video.flutter.background.stream_video_flutter_background.R
import io.getstream.video.flutter.background.stream_video_flutter_background.service.utils.applicationName
import io.getstream.video.flutter.background.stream_video_flutter_background.service.utils.notificationManager
import kotlinx.coroutines.CoroutineScope

internal class StreamNotificationBuilderImpl(
    private val context: Context,
    private val scope: CoroutineScope,
    private val getNotificationId: () -> Int
) : StreamNotificationBuilder {

    private val logger by taggedLogger("Call:NtfBuilder")

    private val actionBuilder: NotificationActionBuilder by lazy {
        NotificationActionBuilderImpl(
            context
        )
    }

    init {
        initNotificationChannel()
    }

    private fun initNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationChannel = getDefaultNotificationChannel(context)
            context.notificationManager.createNotificationChannel(notificationChannel())
        }
    }

    override fun build(options: NotificationOptions): IdentifiedNotification {
        val notificationId = getNotificationId()
        val notification = getNotificationBuilder(
            contentTitle = options.contentTitle ?: context.applicationName,
            contentText = options.contentText,
            groupKey = options.callCid,
            intent = Intent("${context.packageName}.${IdentifiedNotification.ACTION_CALL_SUFFIX}")
        ).apply {
            buildNotificationActions(notificationId, options.callCid).forEach {
                addAction(it)
            }
        }.build()
        return IdentifiedNotification(notificationId, notification)
    }

    private fun buildNotificationActions(
        notificationId: Int,
        callCid: StreamCallCid,
    ): Array<NotificationCompat.Action> {
        return arrayOf(
            actionBuilder.createCancelAction(notificationId, callCid)
        )
    }

    private fun getNotificationBuilder(
        contentTitle: String,
        contentText: String?,
        groupKey: String,
        intent: Intent,
    ): NotificationCompat.Builder {
        val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
        val contentIntent = PendingIntent.getActivity(
            context,
            0,
            intent,
            flags,
        )

        return NotificationCompat.Builder(context, getNotificationChannelId()).apply {
            setDefaults(NotificationCompat.DEFAULT_ALL)
            setAutoCancel(false)
            setSmallIcon(R.drawable.baseline_call_stream_24dp)
            setContentTitle(contentTitle)
            if (!contentText.isNullOrEmpty()) {
                setContentText(contentText)
            }
            priority = NotificationCompat.PRIORITY_MAX
            setCategory(NotificationCompat.CATEGORY_CALL)
            setContentIntent(contentIntent)
            setGroup(groupKey)
        }

    }

    private fun getNotificationChannelId(): String {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            getDefaultNotificationChannel(context)().id
        } else {
            ""
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun getDefaultNotificationChannel(context: Context): (() -> NotificationChannel) {
        return {
            NotificationChannel(
                context.getString(R.string.stream_call_notification_channel_id),
                context.getString(R.string.stream_call_notification_channel_name),
                NotificationManager.IMPORTANCE_DEFAULT,
            )
        }
    }
}
