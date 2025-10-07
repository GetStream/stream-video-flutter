package io.getstream.video.flutter.stream_video_push_notification

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Color
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.text.TextUtils
import android.text.format.DateFormat
import android.view.View
import android.widget.RemoteViews
import android.util.Log
import androidx.appcompat.app.AlertDialog
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.app.Person
import java.util.Date


class IncomingCallNotificationManager(
    private val context: Context,
    private val incomingCallSoundPlayerManager: IncomingCallSoundPlayerManager?
) {

    companion object {
        const val PERMISSION_NOTIFICATION_REQUEST_CODE = 6969

        const val EXTRA_TIME_START_CALL = "EXTRA_TIME_START_CALL"

        const val NOTIFICATION_CHANNEL_ID_INCOMING = "io.getstream.video_incoming_call_channel_id"
        const val NOTIFICATION_CHANNEL_ID_MISSED = "io.getstream.video_missed_call_channel_id"
        const val MISSED_GROUP_KEY = "io.getstream.video.flutter.missed_calls"
    }

    private var dataNotificationPermission: Map<String, Any> = HashMap()

    private var notificationBuilder: NotificationCompat.Builder? = null
    private var notificationViews: RemoteViews? = null
    private var notificationSmallViews: RemoteViews? = null

    private var notificationMissingBuilder: NotificationCompat.Builder? = null
    private var notificationMissingViews: RemoteViews? = null
    private var notificationMissingSmallViews: RemoteViews? = null

    private var targetInComingAvatarDefault: SafeTarget? = null
    private var targetInComingAvatarCustom: SafeTarget? = null

    private var targetMissingAvatarDefault: SafeTarget? = null
    private var targetMissingAvatarCustom: SafeTarget? = null

    @SuppressLint("MissingPermission")
    private fun createInComingAvatarTargetCustom(
        notificationId: Int,
        isCallStyle: Boolean = false
    ): SafeTarget {
        return object : SafeTarget(notificationId, onLoaded = { bitmap ->
            notificationViews?.setImageViewBitmap(R.id.ivAvatar, bitmap)
            notificationViews?.setViewVisibility(R.id.ivAvatar, View.VISIBLE)
            notificationSmallViews?.setImageViewBitmap(R.id.ivAvatar, bitmap)
            notificationSmallViews?.setViewVisibility(R.id.ivAvatar, View.VISIBLE)
            if (isCallStyle) notificationBuilder?.setLargeIcon(bitmap)
            notificationBuilder?.let { getNotificationManager().notify(notificationId, it.build()) }
        }) {}
    }

    @SuppressLint("MissingPermission")
    private fun createMissingAvatarTargetCustom(
        notificationId: Int,
        builder: NotificationCompat.Builder,
        bigViews: RemoteViews?,
        smallViews: RemoteViews?
    ): SafeTarget {
        return object : SafeTarget(notificationId, onLoaded = { bitmap ->
            bigViews?.setImageViewBitmap(R.id.ivAvatar, bitmap)
            bigViews?.setViewVisibility(R.id.ivAvatar, View.VISIBLE)
            smallViews?.setImageViewBitmap(R.id.ivAvatar, bitmap)
            smallViews?.setViewVisibility(R.id.ivAvatar, View.VISIBLE)
            getNotificationManager().notify(notificationId, builder.build())
        }) {}
    }

    @SuppressLint("MissingPermission")
    fun getIncomingNotification(data: Bundle): IncomingCallNotification? {
        data.putLong(EXTRA_TIME_START_CALL, System.currentTimeMillis())

        val notificationId =
            data.getString(IncomingCallConstants.EXTRA_CALL_ID, "stream_video_call").hashCode()

        ensureNotificationChannelsCreated(data)

        notificationBuilder = NotificationCompat.Builder(context, NOTIFICATION_CHANNEL_ID_INCOMING)
        notificationBuilder?.setChannelId(NOTIFICATION_CHANNEL_ID_INCOMING)
        notificationBuilder?.setDefaults(NotificationCompat.DEFAULT_VIBRATE)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            notificationBuilder?.setCategory(NotificationCompat.CATEGORY_CALL)
            notificationBuilder?.priority = NotificationCompat.PRIORITY_MAX
        }

        notificationBuilder?.setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
        notificationBuilder?.setOngoing(true)
        notificationBuilder?.setAutoCancel(false)
        notificationBuilder?.setWhen(System.currentTimeMillis())
        notificationBuilder?.setTimeoutAfter(
            data.getLong(
                IncomingCallConstants.EXTRA_CALL_DURATION, 0L
            )
        )
        notificationBuilder?.setOnlyAlertOnce(true)
        notificationBuilder?.setSound(null)
        notificationBuilder?.setFullScreenIntent(
            getActivityPendingIntent(notificationId, data), true
        )
        notificationBuilder?.setContentIntent(getActivityPendingIntent(notificationId, data))

        val typeCall = data.getInt(IncomingCallConstants.EXTRA_CALL_TYPE, -1)
        var smallIcon = context.applicationInfo.icon

        if (typeCall > 0) {
            smallIcon = R.drawable.ic_video
        } else {
            if (smallIcon >= 0) {
                smallIcon = R.drawable.ic_accept
            }
        }

        notificationBuilder?.setSmallIcon(smallIcon)
        notificationBuilder?.setChannelId(NOTIFICATION_CHANNEL_ID_INCOMING)
        notificationBuilder?.priority = NotificationCompat.PRIORITY_MAX

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            val caller = data.getString(IncomingCallConstants.EXTRA_CALL_NAME_CALLER, "")
            val person = Person.Builder().setName(caller).setImportant(
                data.getBoolean(IncomingCallConstants.EXTRA_CALL_IS_IMPORTANT, true)
            ).setBot(data.getBoolean(IncomingCallConstants.EXTRA_CALL_IS_BOT, false)).build()

            notificationBuilder?.setStyle(
                NotificationCompat.CallStyle.forIncomingCall(
                    person,
                    getDeclinePendingIntent(notificationId, data),
                    getAcceptPendingIntent(notificationId, data),
                ).setIsVideo(typeCall > 0)
            )

            val showCallHandle =
                data.getBoolean(IncomingCallConstants.EXTRA_CALL_SHOW_CALL_HANDLE, false)
            if (showCallHandle) {
                notificationBuilder?.setContentText(
                    data.getString(
                        IncomingCallConstants.EXTRA_CALL_HANDLE, ""
                    )
                )
            }

            var defaultAvatar = data.getString(
                IncomingCallConstants.EXTRA_CALL_DEFAULT_AVATAR, ""
            )
            var avatarUrl = data.getString(IncomingCallConstants.EXTRA_CALL_AVATAR, "")

            if(avatarUrl.isNullOrEmpty() && !defaultAvatar.isNullOrEmpty()) {
                avatarUrl = defaultAvatar
            }

            if (!avatarUrl.isNullOrEmpty()) {
                if (!avatarUrl.startsWith("http://", true) && !avatarUrl.startsWith(
                        "https://",
                        true
                    )
                ) {
                    avatarUrl =
                        String.format("file:///android_asset/flutter_assets/%s", avatarUrl)
                }
                val headers =
                    data.getSerializable(IncomingCallConstants.EXTRA_CALL_HEADERS) as HashMap<String, Any?>
                if (targetInComingAvatarCustom == null) targetInComingAvatarCustom =
                    createInComingAvatarTargetCustom(notificationId, true)

                ImageLoaderProvider.loadImage(
                    context,
                    avatarUrl,
                    headers,
                    targetInComingAvatarCustom
                )

            }
        } else {
            notificationViews =
                RemoteViews(context.packageName, R.layout.layout_custom_notification)
            initInComingNotificationViews(notificationId, notificationViews!!, data)

            if ((Build.MANUFACTURER.equals(
                    "Samsung", ignoreCase = true
                ) && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S)
            ) {
                notificationSmallViews = RemoteViews(
                    context.packageName, R.layout.layout_custom_small_ex_notification
                )
                initInComingNotificationViews(notificationId, notificationSmallViews!!, data)
            } else {
                notificationSmallViews =
                    RemoteViews(context.packageName, R.layout.layout_custom_small_notification)
                initInComingNotificationViews(notificationId, notificationSmallViews!!, data)
            }

            notificationBuilder?.setStyle(NotificationCompat.DecoratedCustomViewStyle())
            notificationBuilder?.setCustomContentView(notificationSmallViews)
            notificationBuilder?.setCustomBigContentView(notificationViews)
            notificationBuilder?.setCustomHeadsUpContentView(notificationSmallViews)
        }

        notificationBuilder?.setOngoing(true)
        val notification = notificationBuilder?.build()

        return notification?.let { IncomingCallNotification(notificationId, it) }
    }

    private fun initInComingNotificationViews(
        notificationId: Int, remoteViews: RemoteViews, data: Bundle
    ) {
        remoteViews.setTextViewText(
            R.id.tvCallerName, data.getString(IncomingCallConstants.EXTRA_CALL_NAME_CALLER, "")
        )
        val showCallHandle = data.getBoolean(IncomingCallConstants.EXTRA_CALL_SHOW_CALL_HANDLE, false)
        if (showCallHandle) {
            remoteViews.setTextViewText(
                R.id.tvNumber, data.getString(IncomingCallConstants.EXTRA_CALL_HANDLE, "")
            )
        }
        remoteViews.setOnClickPendingIntent(
            R.id.llDecline, getDeclinePendingIntent(notificationId, data)
        )
        val textDecline = data.getString(IncomingCallConstants.EXTRA_CALL_TEXT_DECLINE, "")
        remoteViews.setTextViewText(
            R.id.tvDecline,
            if (TextUtils.isEmpty(textDecline)) context.getString(R.string.text_decline) else textDecline
        )
        remoteViews.setOnClickPendingIntent(
            R.id.llAccept, getAcceptPendingIntent(notificationId, data)
        )
        val textAccept = data.getString(IncomingCallConstants.EXTRA_CALL_TEXT_ACCEPT, "")
        remoteViews.setTextViewText(
            R.id.tvAccept,
            if (TextUtils.isEmpty(textAccept)) context.getString(R.string.text_accept) else textAccept
        )

        var defaultAvatar = data.getString(
            IncomingCallConstants.EXTRA_CALL_DEFAULT_AVATAR, ""
        )
        var avatarUrl = data.getString(IncomingCallConstants.EXTRA_CALL_AVATAR, "")
         
        if(avatarUrl.isNullOrEmpty() && !defaultAvatar.isNullOrEmpty()) {
            avatarUrl = defaultAvatar
        }

        if (!avatarUrl.isNullOrEmpty()) {
            if (!avatarUrl.startsWith("http://", true) && !avatarUrl.startsWith("https://", true)) {
                avatarUrl = String.format("file:///android_asset/flutter_assets/%s", avatarUrl)
            }
            val headers =
                data.getSerializable(IncomingCallConstants.EXTRA_CALL_HEADERS) as HashMap<String, Any?>

            if (targetInComingAvatarCustom == null) targetInComingAvatarCustom =
                createInComingAvatarTargetCustom(notificationId, false)
            ImageLoaderProvider.loadImage(context, avatarUrl, headers, targetInComingAvatarCustom)
        }
    }

    private fun getSystemFormattedTime(context: Context): String {
        val currentTimeMillis = System.currentTimeMillis()
        val date = Date(currentTimeMillis)

        val timeFormatter = DateFormat.getTimeFormat(context)
        return timeFormatter.format(date)
    }

    @SuppressLint("MissingPermission")
    fun showMissCallNotification(data: Bundle) {
        val isMissedCallShow =
            data.getBoolean(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_SHOW, true)
        if (!isMissedCallShow) return

        // Use explicit integer ID if provided; otherwise derive a stable hash from call ID
        val hasExplicitMissedId = data.containsKey(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_ID)
        val missedNotificationId = if (hasExplicitMissedId) {
            data.getInt(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_ID).hashCode()
        } else {
            val fallbackId = data.getString(
                IncomingCallConstants.EXTRA_CALL_ID,
                "stream_video_call"
            )
            ("missing_$fallbackId").hashCode()
        }

        ensureNotificationChannelsCreated(data);

        val missedCallSound: Uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
        val typeCall = data.getInt(IncomingCallConstants.EXTRA_CALL_TYPE, -1)

        var smallIcon = context.applicationInfo.icon
        if (typeCall > 0) {
            smallIcon = R.drawable.ic_video_missed
        } else {
            if (smallIcon >= 0) {
                smallIcon = R.drawable.ic_call_missed
            }
        }

        val builder = NotificationCompat.Builder(context, NOTIFICATION_CHANNEL_ID_MISSED)
        builder.setChannelId(NOTIFICATION_CHANNEL_ID_MISSED)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                builder.setCategory(Notification.CATEGORY_MISSED_CALL)
            }
        }

        builder.setWhen(System.currentTimeMillis())

        val textMissedCall = data.getString(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_SUBTITLE, "")
        builder.setSubText(
            if (TextUtils.isEmpty(textMissedCall)) context.getString(
                R.string.text_missed_call
            ) else textMissedCall
        )

        builder.setSmallIcon(smallIcon)
        builder.setOnlyAlertOnce(true)

        notificationMissingViews =
            RemoteViews(context.packageName, R.layout.layout_custom_miss_notification)
        notificationMissingSmallViews =
            RemoteViews(context.packageName, R.layout.layout_custom_miss_small_notification)
            
        notificationMissingViews?.setTextViewText(
            R.id.tvCallerName, data.getString(IncomingCallConstants.EXTRA_CALL_NAME_CALLER, "")
        )
        notificationMissingSmallViews?.setTextViewText(
            R.id.tvCallerName, data.getString(IncomingCallConstants.EXTRA_CALL_NAME_CALLER, "")
        )
        
        notificationMissingSmallViews?.setTextViewText(
            R.id.tvTime, getSystemFormattedTime(context)
        )
        val showCallHandle =
            data.getBoolean(IncomingCallConstants.EXTRA_CALL_SHOW_CALL_HANDLE, false)
        if (showCallHandle) {
            notificationMissingViews?.setTextViewText(
                R.id.tvNumber, data.getString(IncomingCallConstants.EXTRA_CALL_HANDLE, "")
            )
            notificationMissingSmallViews?.setTextViewText(
                R.id.tvNumber, data.getString(IncomingCallConstants.EXTRA_CALL_HANDLE, "")
            )
        }

        notificationMissingViews?.setOnClickPendingIntent(
            R.id.llCallback, getCallbackPendingIntent(missedNotificationId, data)
        )

        val showCallbackButton = data.getBoolean(
            IncomingCallConstants.EXTRA_CALL_MISSED_CALL_CALLBACK_SHOW, true
        )
        notificationMissingViews?.setViewVisibility(
            R.id.llCallback, if (showCallbackButton) View.VISIBLE else View.GONE
        )
        val textCallback =
            data.getString(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_CALLBACK_TEXT, "")
        notificationMissingViews?.setTextViewText(
            R.id.tvCallback,
            if (TextUtils.isEmpty(textCallback)) context.getString(R.string.text_call_back) else textCallback
        )

        var defaultAvatar = data.getString(
            IncomingCallConstants.EXTRA_CALL_DEFAULT_AVATAR, ""
        )
        var avatarUrl = data.getString(IncomingCallConstants.EXTRA_CALL_AVATAR, "")

        if(avatarUrl.isNullOrEmpty() && !defaultAvatar.isNullOrEmpty()) {
            avatarUrl = defaultAvatar
        }

        if (!avatarUrl.isNullOrEmpty()) {
            if (!avatarUrl.startsWith("http://", true) && !avatarUrl.startsWith(
                    "https://",
                    true
                )
            ) {
                avatarUrl = String.format("file:///android_asset/flutter_assets/%s", avatarUrl)
            }
            val headers =
                data.getSerializable(IncomingCallConstants.EXTRA_CALL_HEADERS) as HashMap<String, Any?>

            targetMissingAvatarCustom =
                createMissingAvatarTargetCustom(
                    missedNotificationId,
                    builder,
                    notificationMissingViews,
                    notificationMissingSmallViews
                )
            ImageLoaderProvider.loadImage(
                context,
                avatarUrl,
                headers,
                targetMissingAvatarCustom
            )
        }

        // Ensure collapsed (system) view also shows content when the custom view isn't used
        val callerName = data.getString(IncomingCallConstants.EXTRA_CALL_NAME_CALLER, "")
        builder.setContentTitle(callerName)
        builder.setContentText(
            if (TextUtils.isEmpty(textMissedCall)) context.getString(R.string.text_missed_call) else textMissedCall
        )
        builder.setStyle(NotificationCompat.DecoratedCustomViewStyle())
        builder.setCustomContentView(notificationMissingSmallViews)
        builder.setCustomBigContentView(notificationMissingViews)
        builder.setGroup(MISSED_GROUP_KEY)

        builder.priority = NotificationCompat.PRIORITY_HIGH

        builder.setSound(missedCallSound)
        builder.setContentIntent(
            getAppPendingIntent(
                missedNotificationId, data
            )
        )
       
        val notification = builder.build()
        if (notification != null) {
            getNotificationManager().notify(missedNotificationId, notification)
        }
    }

    fun clearIncomingNotification(data: Bundle, isAccepted: Boolean) {
        incomingCallSoundPlayerManager?.stop()

        context.sendBroadcast(IncomingCallActivity.getIntentEnded(context, isAccepted))

        val notificationId =
            data.getString(IncomingCallConstants.EXTRA_CALL_ID, "stream_video_call").hashCode()

        getNotificationManager().cancel(notificationId)
        targetInComingAvatarDefault?.let {
            targetInComingAvatarDefault?.isCancelled = true
            targetInComingAvatarDefault = null
        }
        targetInComingAvatarCustom?.let {
            targetInComingAvatarCustom?.isCancelled = true
            targetInComingAvatarCustom = null
        }
    }

    fun clearMissCallNotification(data: Bundle) {
        // Support both int and string ID styles
        val hasExplicitMissedId = data.containsKey(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_ID)
        val missedNotificationId = if (hasExplicitMissedId) {
            data.getInt(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_ID)
        } else {
            val missingId = data.getString(
                IncomingCallConstants.EXTRA_CALL_MISSED_CALL_ID,
                data.getString(IncomingCallConstants.EXTRA_CALL_ID, "stream_video_call")
            )
            ("missing_$missingId").hashCode()
        }

        getNotificationManager().cancel(missedNotificationId)

        targetMissingAvatarDefault?.let {
            targetMissingAvatarDefault?.isCancelled = true
            targetMissingAvatarDefault = null
        }
        targetMissingAvatarCustom?.let {
            targetMissingAvatarCustom?.isCancelled = true
            targetMissingAvatarCustom = null
        }
    }

    private fun incomingChannelEnabled(): Boolean = getNotificationManager().run {
        if (!areNotificationsEnabled()) return false

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = getNotificationChannel(NOTIFICATION_CHANNEL_ID_INCOMING)
            return channel != null && channel.importance > NotificationManagerCompat.IMPORTANCE_NONE
        }

        return true
    }

    fun ensureNotificationChannelsCreated(data: Bundle) {
        val incomingCallChannelName = data.getString(
            IncomingCallConstants.EXTRA_CALL_INCOMING_CALL_NOTIFICATION_CHANNEL_NAME, "Incoming Call"
        )
        val missedCallChannelName = data.getString(
            IncomingCallConstants.EXTRA_CALL_MISSED_CALL_NOTIFICATION_CHANNEL_NAME, "Missed Call"
        )

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            getNotificationManager().apply {
                var channelCall = getNotificationChannel(NOTIFICATION_CHANNEL_ID_INCOMING)
                if (channelCall != null) {
                    channelCall.setSound(null, null)
                } else {
                    channelCall = NotificationChannel(
                        NOTIFICATION_CHANNEL_ID_INCOMING,
                        incomingCallChannelName,
                        NotificationManager.IMPORTANCE_HIGH
                    ).apply {
                        description = ""
                        vibrationPattern = longArrayOf(0, 1000, 500, 1000, 500)
                        lightColor = Color.RED
                        enableLights(true)
                        enableVibration(true)
                        setSound(null, null)
                    }
                }

                channelCall.lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                channelCall.importance = NotificationManager.IMPORTANCE_HIGH

                createNotificationChannel(channelCall)

                var channelMissedCall = getNotificationChannel(NOTIFICATION_CHANNEL_ID_MISSED)
                if (channelMissedCall == null) {
                    channelMissedCall = NotificationChannel(
                        NOTIFICATION_CHANNEL_ID_MISSED,
                        missedCallChannelName,
                        NotificationManager.IMPORTANCE_HIGH
                    ).apply {
                        description = ""
                        vibrationPattern = longArrayOf(0, 1000)
                        lightColor = Color.RED
                        enableLights(true)
                        enableVibration(true)
                    }
                }

                channelMissedCall.importance = NotificationManager.IMPORTANCE_HIGH
                createNotificationChannel(channelMissedCall)
            }
        }
    }

    private fun getAcceptPendingIntent(id: Int, data: Bundle): PendingIntent {
        val intentTransparent = TransparentActivity.getIntent(
            context, IncomingCallConstants.ACTION_CALL_ACCEPT, data
        )
        return PendingIntent.getActivity(context, id, intentTransparent, getFlagPendingIntent())
    }

    private fun getDeclinePendingIntent(id: Int, data: Bundle): PendingIntent {
        val declineIntent = IncomingCallBroadcastReceiver.getIntentDecline(context, data)
        return PendingIntent.getBroadcast(context, id, declineIntent, getFlagPendingIntent())
    }

    private fun getTimeOutPendingIntent(id: Int, data: Bundle): PendingIntent {
        val timeOutIntent = IncomingCallBroadcastReceiver.getIntentTimeout(context, data)
        return PendingIntent.getBroadcast(context, id, timeOutIntent, getFlagPendingIntent())
    }

    private fun getCallbackPendingIntent(id: Int, data: Bundle): PendingIntent {
        val intentTransparent = TransparentActivity.getIntent(
            context, IncomingCallConstants.ACTION_CALL_CALLBACK, data
        )
        return PendingIntent.getActivity(context, id, intentTransparent, getFlagPendingIntent())
    }

    private fun getActivityPendingIntent(id: Int, data: Bundle): PendingIntent {
        val intent = IncomingCallActivity.getIntent(context, data)
        return PendingIntent.getActivity(context, id, intent, getFlagPendingIntent())
    }

    private fun getAppPendingIntent(id: Int, data: Bundle): PendingIntent {
        val intent: Intent? = AppUtils.getAppIntent(context, data = data)
        return PendingIntent.getActivity(context, id, intent, getFlagPendingIntent())
    }


    private fun getHangupPendingIntent(notificationId: Int, data: Bundle): PendingIntent {
        val endedIntent = IncomingCallBroadcastReceiver.getIntentEnded(context, data)
        return PendingIntent.getBroadcast(
            context, notificationId, endedIntent, getFlagPendingIntent()
        )
    }

    private fun getFlagPendingIntent(): Int {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
    }

    private fun getNotificationManager(): NotificationManagerCompat {
        return NotificationManagerCompat.from(context)
    }

    @SuppressLint("MissingPermission")
    fun showIncomingNotification(data: Bundle) {
        val incomingCallNotification = getIncomingNotification(data)
        if (incomingChannelEnabled()) {
            incomingCallSoundPlayerManager?.play(data)
        }
        incomingCallNotification?.let {
            getNotificationManager().notify(
                it.id, incomingCallNotification.notification
            )
        }
    }

    fun requestNotificationPermission(activity: Activity?, map: Map<String, Any>) {
        this.dataNotificationPermission = map
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            activity?.let {
                if (ActivityCompat.checkSelfPermission(
                        it, Manifest.permission.POST_NOTIFICATIONS
                    ) != PackageManager.PERMISSION_GRANTED
                ) {
                    ActivityCompat.requestPermissions(
                        it,
                        arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                        PERMISSION_NOTIFICATION_REQUEST_CODE
                    )
                }
            }
        }
    }

    fun requestFullIntentPermission(activity: Activity?) {
        val canUseFullScreenIntent = getNotificationManager().canUseFullScreenIntent()
        if (!canUseFullScreenIntent && Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            val intent = Intent(Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT).apply {
                data = Uri.fromParts("package", activity?.packageName, null)
            }
            activity?.startActivity(intent)
        }
    }

    fun canUseFullScreenIntent(): Boolean {
        val canUseFullScreenIntent = getNotificationManager().canUseFullScreenIntent()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            return canUseFullScreenIntent
        }
        return true
    }


    fun onRequestPermissionsResult(activity: Activity?, requestCode: Int, grantResults: IntArray) {
        when (requestCode) {
            PERMISSION_NOTIFICATION_REQUEST_CODE -> {
                if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    // allow
                } else {
                    //deny
                    activity?.let {
                        if (ActivityCompat.shouldShowRequestPermissionRationale(
                                it, Manifest.permission.POST_NOTIFICATIONS
                            )
                        ) {
                            //showDialogPermissionRationale()
                            if (this.dataNotificationPermission["title"] != null && this.dataNotificationPermission["rationaleMessagePermission"] != null) {
                                showDialogMessage(
                                    it,
                                    this.dataNotificationPermission["title"] as String,
                                    this.dataNotificationPermission["rationaleMessagePermission"] as String
                                ) { dialog, _ ->
                                    dialog?.dismiss()
                                    requestNotificationPermission(
                                        activity, this.dataNotificationPermission
                                    )
                                }
                            } else {
                                requestNotificationPermission(
                                    activity, this.dataNotificationPermission
                                )
                            }
                        } else {
                            //Open Setting
                            if (this.dataNotificationPermission["title"] != null && this.dataNotificationPermission["postNotificationMessageRequired"] != null) {
                                showDialogMessage(
                                    it,
                                    this.dataNotificationPermission["title"] as String,
                                    this.dataNotificationPermission["postNotificationMessageRequired"] as String
                                ) { dialog, _ ->
                                    dialog?.dismiss()
                                    val intent = Intent(
                                        Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                                        Uri.fromParts("package", it.packageName, null)
                                    )
                                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                    it.startActivity(intent)
                                }
                            } else {
                                showDialogMessage(
                                    it,
                                    it.resources.getString(R.string.text_title_post_notification),
                                    it.resources.getString(R.string.text_post_notification_message_required)
                                ) { dialog, _ ->
                                    dialog?.dismiss()
                                    val intent = Intent(
                                        Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                                        Uri.fromParts("package", it.packageName, null)
                                    )
                                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                    it.startActivity(intent)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private fun showDialogMessage(
        activity: Activity?,
        title: String,
        message: String,
        okListener: DialogInterface.OnClickListener
    ) {
        activity?.let {
            AlertDialog.Builder(it, R.style.DialogTheme).setTitle(title).setMessage(message)
                .setPositiveButton(android.R.string.ok, okListener)
                .setNegativeButton(android.R.string.cancel, null).create().show()
        }
    }

    fun destroy() {

        incomingCallSoundPlayerManager?.destroy()
    }

}

data class IncomingCallNotification(val id: Int, val notification: Notification)


