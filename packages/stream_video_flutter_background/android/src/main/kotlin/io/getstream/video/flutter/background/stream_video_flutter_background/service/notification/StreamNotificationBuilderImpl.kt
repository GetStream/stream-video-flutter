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
import android.graphics.drawable.Drawable
import android.os.Build
import android.view.View
import android.widget.RemoteViews
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import com.squareup.picasso.OkHttp3Downloader
import com.squareup.picasso.Picasso
import com.squareup.picasso.Target
import io.getstream.log.taggedLogger
import io.getstream.video.flutter.background.stream_video_flutter_background.R
import io.getstream.video.flutter.background.stream_video_flutter_background.service.notification.image.CircleTransform
import io.getstream.video.flutter.background.stream_video_flutter_background.service.utils.applicationName
import io.getstream.video.flutter.background.stream_video_flutter_background.service.utils.notificationManager
import kotlinx.coroutines.CoroutineScope
import okhttp3.Headers
import okhttp3.OkHttpClient

internal class StreamNotificationBuilderImpl(
    private val context: Context,
    private val scope: CoroutineScope,
    private val getNotificationId: () -> Int,
    private val onUpdate: (IdentifiedNotification) -> Unit,
) : StreamNotificationBuilder {

    private val logger by taggedLogger("StreamNtfBuilder")

    private val actionBuilder: NotificationActionBuilder by lazy {
        NotificationActionBuilderImpl(
            context
        )
    }

    private val defaultPicassoTarget = DefaultPicassoTarget(getNotificationId, onUpdate)

    private val customPicassoTarget = CustomPicassoTarget(getNotificationId, onUpdate)

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

    private fun buildNotificationActions(
        notificationId: Int,
        callCid: StreamCallCid,
    ): Array<NotificationCompat.Action> {
        return arrayOf(
            actionBuilder.createCancelAction(notificationId, callCid)
        )
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
            enrichCustom(payload, contentIntent)
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
        setSmallIcon(R.drawable.baseline_call_stream_24dp)
        setContentTitle(contentTitle)
        if (!contentText.isNullOrEmpty()) {
            setContentText(contentText)
        }
        priority = NotificationCompat.PRIORITY_MAX

        val notificationId = getNotificationId()
        buildNotificationActions(notificationId, payload.callCid).forEach {
            addAction(it)
        }

        val avatarUrl = payload.options?.avatar?.url
        if (!avatarUrl.isNullOrEmpty()) {
            logger.i { "[loadAvatar] avatarUrl: $avatarUrl" }
            val headers = payload.options.avatar.httpHeaders
            context.getPicassoInstance(headers)
                .load(avatarUrl)
                .transform(CircleTransform())
                .into(defaultPicassoTarget(builder = this))
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
        setSmallIcon(R.drawable.baseline_call_stream_24dp)

        priority = NotificationCompat.PRIORITY_MAX

        val isCustomSmallExNotification = false

        val notificationLargeLayout = RemoteViews(context.packageName, R.layout.layout_custom_notification)

        initNotificationViews(notificationLargeLayout, payload)

        val notificationSmallLayout: RemoteViews
        if ((Build.MANUFACTURER.equals(
                "Samsung",
                ignoreCase = true
            ) && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) || isCustomSmallExNotification
        ) {
            notificationSmallLayout = RemoteViews(context.packageName, R.layout.layout_custom_small_ex_notification)
            initNotificationViews(notificationSmallLayout, payload)
        } else {
            notificationSmallLayout = RemoteViews(context.packageName, R.layout.layout_custom_small_notification)
            initNotificationViews(notificationSmallLayout, payload)
        }
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
                    customPicassoTarget(
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

    private fun initNotificationViews(remoteViews: RemoteViews, payload: NotificationPayload) {
        val contentTitle = payload.options?.content?.title ?: context.applicationName
        val contentText = payload.options?.content?.text
        remoteViews.setTextViewText(R.id.tvNameCaller, contentTitle)
        remoteViews.setTextViewText(R.id.tvNumber, contentText)
//        remoteViews.setOnClickPendingIntent(
//            R.id.llDecline,
//            getDeclinePendingIntent(notificationId, data)
//        )

        remoteViews.setTextViewText(
            R.id.tvDecline,
            context.getString(R.string.text_decline)
        )
//        remoteViews.setOnClickPendingIntent(
//            R.id.llAccept,
//            getAcceptPendingIntent(notificationId, data)
//        )

        remoteViews.setTextViewText(
            R.id.tvAccept,
            context.getString(R.string.text_accept)
        )
        val avatarUrl = payload.options?.avatar?.url
        if (!avatarUrl.isNullOrEmpty()) {
            val headers = payload.options.avatar.httpHeaders
            context.getPicassoInstance(headers).load(avatarUrl)
                .transform(CircleTransform())
                .into(customPicassoTarget)
        }
    }

    private fun Context.getPicassoInstance(headers: Map<String, String>): Picasso {
        logger.d { "[interceptRequest] headers: $headers" }
        val client = OkHttpClient.Builder()
            .addInterceptor { chain ->
                logger.v { "[interceptRequest] request: ${chain.request()}" }
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
}

private class DefaultPicassoTarget(
    private val getNotificationId: () -> Int,
    private val onUpdate: (IdentifiedNotification) -> Unit,
) : Target, Function1<NotificationCompat.Builder, DefaultPicassoTarget> {

    private val logger by taggedLogger("StreamPicassoTarget")

    private var builder: NotificationCompat.Builder? = null
    override fun onBitmapLoaded(bitmap: Bitmap?, from: Picasso.LoadedFrom?) {
        logger.v { "[onBitmapLoaded] bitmap.byteCount: ${bitmap?.byteCount}" }
        val builder = builder ?: return
        val icon = bitmap ?: return
        builder.setLargeIcon(icon)
        val notification = IdentifiedNotification(getNotificationId(), builder.build())
        logger.v { "[onBitmapLoaded] notification: $notification" }
        onUpdate(notification)
    }

    override fun onBitmapFailed(e: Exception?, errorDrawable: Drawable?) {
        logger.e { "[onBitmapFailed] error: $e" }
    }

    override fun onPrepareLoad(placeHolderDrawable: Drawable?) {
        logger.d { "[onPrepareLoad] placeHolderDrawable: $placeHolderDrawable" }
    }

    override fun invoke(builder: NotificationCompat.Builder): DefaultPicassoTarget {
        this.builder = builder
        return this
    }
}

private class CustomPicassoTarget(
    private val getNotificationId: () -> Int,
    private val onUpdate: (IdentifiedNotification) -> Unit,
) : Target, Function3<NotificationCompat.Builder, RemoteViews, RemoteViews, CustomPicassoTarget> {

    private val logger by taggedLogger("StreamPicassoTarget")

    private var builder: NotificationCompat.Builder? = null
    private var notificationSmallLayout: RemoteViews? = null
    private var notificationLargeLayout: RemoteViews? = null

    override fun onBitmapLoaded(bitmap: Bitmap?, from: Picasso.LoadedFrom?) {
        logger.v { "[onBitmapLoaded] bitmap.byteCount: ${bitmap?.byteCount}" }
        val builder = builder ?: return
        val icon = bitmap ?: return
        notificationLargeLayout?.setImageViewBitmap(R.id.ivAvatar, icon)
        notificationLargeLayout?.setViewVisibility(R.id.ivAvatar, View.VISIBLE)
        notificationSmallLayout?.setImageViewBitmap(R.id.ivAvatar, icon)
        notificationSmallLayout?.setViewVisibility(R.id.ivAvatar, View.VISIBLE)

        val notification = IdentifiedNotification(getNotificationId(), builder.build())
        logger.v { "[onBitmapLoaded] notification: $notification" }
        onUpdate(notification)
    }

    override fun onBitmapFailed(e: Exception?, errorDrawable: Drawable?) {
        logger.e { "[onBitmapFailed] error: $e" }
    }

    override fun onPrepareLoad(placeHolderDrawable: Drawable?) {
        logger.d { "[onPrepareLoad] placeHolderDrawable: $placeHolderDrawable" }
    }

    override fun invoke(
        builder: NotificationCompat.Builder,
        notificationLargeLayout: RemoteViews,
        notificationSmallLayout: RemoteViews,
    ): CustomPicassoTarget {
        this.builder = builder
        this.notificationLargeLayout = notificationLargeLayout
        this.notificationSmallLayout = notificationSmallLayout
        return this
    }
}
