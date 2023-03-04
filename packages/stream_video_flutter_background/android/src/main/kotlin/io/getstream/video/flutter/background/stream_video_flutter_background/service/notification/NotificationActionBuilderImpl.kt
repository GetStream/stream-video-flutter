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

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import io.getstream.video.flutter.background.stream_video_flutter_background.R

internal class NotificationActionBuilderImpl(
    private val context: Context
) : NotificationActionBuilder {

    override fun createAcceptAction(
        notificationId: Int,
        callCid: StreamCallCid
    ): NotificationCompat.Action {
        return NotificationCompat.Action.Builder(
            android.R.drawable.ic_menu_call,
            context.getString(R.string.stream_call_notification_action_accept),
            createAcceptPendingIntent(notificationId, callCid),
        ).build()
    }

    override fun createRejectAction(
        notificationId: Int,
        callCid: StreamCallCid
    ): NotificationCompat.Action {
        return NotificationCompat.Action.Builder(
            android.R.drawable.ic_delete,
            context.getString(R.string.stream_call_notification_action_reject),
            createRejectPendingIntent(notificationId, callCid),
        ).build()
    }

    override fun createCancelAction(
        notificationId: Int,
        callCid: StreamCallCid
    ): NotificationCompat.Action {
        return NotificationCompat.Action.Builder(
            android.R.drawable.ic_delete,
            context.getString(R.string.stream_call_notification_action_cancel),
            createCancelPendingIntent(notificationId, callCid),
        ).build()
    }

    private fun createAcceptPendingIntent(
        notificationId: Int,
        callCid: StreamCallCid
    ): PendingIntent = PendingIntent.getBroadcast(
        context,
        notificationId,
        Intent().setNotificationAction(context.packageName, NotificationAction.Accept(callCid)),
        IMMUTABLE_PENDING_INTENT_FLAGS,
    )

    private fun createRejectPendingIntent(
        notificationId: Int,
        callCid: StreamCallCid
    ): PendingIntent = PendingIntent.getBroadcast(
        context,
        notificationId,
        Intent().setNotificationAction(context.packageName, NotificationAction.Reject(callCid)),
        IMMUTABLE_PENDING_INTENT_FLAGS,
    )

    private fun createCancelPendingIntent(
        notificationId: Int,
        callCid: StreamCallCid
    ): PendingIntent = PendingIntent.getBroadcast(
        context,
        notificationId,
        Intent().setNotificationAction(context.packageName, NotificationAction.Cancel(callCid)),
        IMMUTABLE_PENDING_INTENT_FLAGS,
    )

    private companion object {
        private val IMMUTABLE_PENDING_INTENT_FLAGS =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            } else {
                PendingIntent.FLAG_UPDATE_CURRENT
            }
    }
}
