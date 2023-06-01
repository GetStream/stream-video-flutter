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
import android.graphics.Bitmap
import android.os.Build
import android.view.View
import android.widget.RemoteViews
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import com.squareup.picasso.OkHttp3Downloader
import com.squareup.picasso.Picasso
import io.getstream.log.StreamLog
import io.getstream.log.taggedLogger
import io.getstream.video.flutter.background.stream_video_flutter_background.R
import io.getstream.video.flutter.background.stream_video_flutter_background.service.notification.image.CircleTransform
import io.getstream.video.flutter.background.stream_video_flutter_background.service.notification.image.CustomTarget
import io.getstream.video.flutter.background.stream_video_flutter_background.service.notification.image.DefaultTarget
import io.getstream.video.flutter.background.stream_video_flutter_background.service.utils.applicationName
import io.getstream.video.flutter.background.stream_video_flutter_background.service.utils.notificationManager
import kotlinx.coroutines.CoroutineScope
import okhttp3.Headers
import okhttp3.OkHttpClient

private const val TAG = "StreamNtfBuilder"

internal class StreamNotificationBuilderImpl(
    private val context: Context,
    private val scope: CoroutineScope,
    private val getNotificationId: () -> Int,
    private val onUpdate: (IdentifiedNotification) -> Unit,
) : StreamNotificationBuilder {

    private val logger by taggedLogger(TAG)

    private val actionBuilder: NotificationActionBuilder by lazy {
        NotificationActionBuilderImpl(
            context
        )
    }

    private val defaultTarget = DefaultTarget(getNotificationId, onUpdate)

    private val customTarget = CustomTarget(getNotificationId, onUpdate)

    init {
        initNotificationChannel()
    }

    private fun initNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationChannel = getDefaultNotificationChannel(context)
            context.notificationManager.createNotificationChannel(notificationChannel())
        }
    }

    override fun build(payload: NotificationPayload): IdentifiedNotification {
        val notificationId = getNotificationId()
        val builder = getNotificationBuilder(
            payload = payload,
            intent = Intent("${context.packageName}.${IdentifiedNotification.ACTION_CALL_SUFFIX}")
        )

        return IdentifiedNotification(notificationId, builder.build())
    }

    private fun getNotificationBuilder(
        payload: NotificationPayload,
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
            if (payload.options?.useCustomLayout == true) {
                enrichCustom(payload, contentIntent)
            } else {
                enrichDefault(payload, contentIntent)
            }
        }
    }

    private fun NotificationCompat.Builder.enrichDefault(
        payload: NotificationPayload,
        contentIntent: PendingIntent?,
    ) {
        val contentTitle = payload.options?.content?.title ?: context.applicationName
        val contentText = payload.options?.content?.text
        val groupKey = payload.callCid

        setGroup(groupKey)
        setContentIntent(contentIntent)
        setCategory(NotificationCompat.CATEGORY_CALL)
        setDefaults(NotificationCompat.DEFAULT_ALL)
        setAutoCancel(false)
        setSmallIcon(R.drawable.stream_baseline_call_stream_24dp)
        setContentTitle(contentTitle)
        if (!contentText.isNullOrEmpty()) {
            setContentText(contentText)
        }
        priority = NotificationCompat.PRIORITY_MAX

        addAction(actionBuilder.createCancelAction(getNotificationId(), payload.callCid))

        val avatarUrl = payload.options?.avatar?.url
        if (!avatarUrl.isNullOrEmpty()) {
            logger.i { "[loadAvatar] avatarUrl: $avatarUrl" }
            val headers = payload.options.avatar.httpHeaders
            context.getPicassoInstance(headers)
                .load(avatarUrl)
                .transform(CircleTransform())
                .into(defaultTarget(builder = this))
        }

    }

    private fun NotificationCompat.Builder.enrichCustom(
        payload: NotificationPayload,
        contentIntent: PendingIntent?,
    ) {
        setGroup(payload.callCid)
        setContentIntent(contentIntent)
        setCategory(NotificationCompat.CATEGORY_CALL)
        setDefaults(NotificationCompat.DEFAULT_ALL)
        setAutoCancel(false)
        setSmallIcon(R.drawable.stream_baseline_call_stream_24dp)

        priority = NotificationCompat.PRIORITY_MAX

        val notificationLargeLayout = NotificationLayout(
            context, R.layout.stream_notification_large,
        ).setPayload(payload)

        val notificationSmallLayout = NotificationLayout(
            context, when (useSmallExLayout()) {
                true -> R.layout.stream_notification_small_ex
                else -> R.layout.stream_notification_small
            }
        ).setPayload(payload)

        setStyle(NotificationCompat.DecoratedCustomViewStyle())
        setCustomContentView(notificationSmallLayout)
        setCustomBigContentView(notificationLargeLayout)
        setCustomHeadsUpContentView(notificationSmallLayout)

        val avatarUrl = payload.options?.avatar?.url
        if (!avatarUrl.isNullOrEmpty()) {
            logger.i { "[loadAvatar] avatarUrl: $avatarUrl" }
            val headers = payload.options.avatar.httpHeaders
            context.getPicassoInstance(headers)
                .load(avatarUrl)
                .transform(CircleTransform())
                .into(
                    customTarget(
                        builder = this,
                        notificationLargeLayout = notificationLargeLayout,
                        notificationSmallLayout = notificationSmallLayout
                    )
                )
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

    private fun NotificationLayout.setPayload(payload: NotificationPayload): NotificationLayout {
        val contentTitle = payload.options?.content?.title ?: context.applicationName
        val contentText = payload.options?.content?.text
        setContentTitle(contentTitle)
        setContentText(contentText)

        val cancelAction = actionBuilder.createCancelAction(getNotificationId(), payload.callCid)
        cancelAction.actionIntent

        setCancelButton(cancelAction.title)
        setOnClickPendingIntent(
            R.id.cancelLayout,
            cancelAction.actionIntent
        )

        val avatarUrl = payload.options?.avatar?.url
        if (!avatarUrl.isNullOrEmpty()) {
            val headers = payload.options.avatar.httpHeaders
            context.getPicassoInstance(headers).load(avatarUrl)
                .transform(CircleTransform())
                .into(customTarget)
        }
        return this
    }

}

private fun useSmallExLayout(): Boolean {
    val isCustomSmallExNotification = false
    return Build.MANUFACTURER.equals(
        "Samsung",
        ignoreCase = true
    ) && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S || isCustomSmallExNotification
}

private fun Context.getPicassoInstance(headers: Map<String, String>): Picasso {
    StreamLog.d(TAG) { "[interceptRequest] headers: $headers" }
    val client = OkHttpClient.Builder()
        .addInterceptor { chain ->
            StreamLog.v(TAG) { "[interceptRequest] request: ${chain.request()}" }
            val newRequest = chain.request()
                .newBuilder()
                .headers(Headers.of(headers))
                .build()
            chain.proceed(newRequest)
        }
        .build()
    return Picasso.Builder(this)
        .downloader(OkHttp3Downloader(client))
        .build()
}

class NotificationLayout(
    private val context: Context,
    layoutId: Int,
) : RemoteViews(context.packageName, layoutId) {

    fun setContentTitle(contentTitle: CharSequence?) {
        setTextViewText(R.id.contentTitle, contentTitle)
    }

    fun setContentText(contentText: CharSequence?) {
        setTextViewText(R.id.contentText, contentText)
    }

    fun setCancelButton(text: CharSequence?) {
        setTextViewText(R.id.cancelText, text)
    }

    fun setAvatar(bitmap: Bitmap) {
        setImageViewBitmap(R.id.avatar, bitmap)
        setViewVisibility(R.id.avatar, View.VISIBLE)
    }

}