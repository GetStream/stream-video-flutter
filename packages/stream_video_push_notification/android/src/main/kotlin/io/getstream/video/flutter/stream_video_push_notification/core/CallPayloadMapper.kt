package io.getstream.video.flutter.stream_video_push_notification.core

import android.os.Bundle
import io.getstream.video.flutter.stream_video_push_notification.IncomingCallConstants

/**
 * Converts a [RingingCall] to and from every format it travels in: the argument map of a
 * method-channel call, the Bundle of a broadcast or notification intent, the body of a ringing
 * event, and an entry of the stored active-calls list.
 *
 * A value a format leaves out gets the [RingingCall] default.
 */
@Suppress("UNCHECKED_CAST")
internal object CallPayloadMapper {

    private val defaults = RingingCall()

    // region method channel

    /**
     * Reads the call parameters Dart sends. Android-specific values are read from the `android`
     * map when there is one and from the top level otherwise.
     */
    fun fromArgs(args: Map<String, Any?>): RingingCall {
        val android = args["android"] as? Map<String, Any?> ?: args
        val missed = android["missedCallNotification"] as? Map<String, Any?>
        val incoming = android["incomingCallNotification"] as? Map<String, Any?>

        val textAccept = if (incoming != null) {
            incoming["textAccept"] as? String ?: defaults.textAccept
        } else {
            args["textAccept"] as? String ?: defaults.textAccept
        }
        val textDecline = if (incoming != null) {
            incoming["textDecline"] as? String ?: defaults.textDecline
        } else {
            args["textDecline"] as? String ?: defaults.textDecline
        }

        return RingingCall(
            id = args["id"] as? String ?: defaults.id,
            callerName = args["callerName"] as? String ?: defaults.callerName,
            handle = args["handle"] as? String ?: defaults.handle,
            type = args["type"] as? Int ?: defaults.type,
            duration = (args["duration"] as? Number)?.toLong() ?: defaults.duration,
            extra = args["extra"] as? Map<String, Any?> ?: defaults.extra,
            headers = args["headers"] as? Map<String, Any?> ?: defaults.headers,
            avatar = android["avatar"] as? String ?: defaults.avatar,
            defaultAvatar = android["defaultAvatar"] as? String ?: defaults.defaultAvatar,
            ringtonePath = android["ringtonePath"] as? String ?: defaults.ringtonePath,
            textAccept = textAccept,
            textDecline = textDecline,
            showCallHandle = incoming?.get("showCallHandle") as? Boolean
                ?: defaults.showCallHandle,
            fullScreenShowLogo = incoming?.get("fullScreenShowLogo") as? Boolean
                ?: defaults.fullScreenShowLogo,
            fullScreenLogoUrl = incoming?.get("fullScreenLogoUrl") as? String
                ?: defaults.fullScreenLogoUrl,
            fullScreenBackgroundColor = incoming?.get("fullScreenBackgroundColor") as? String
                ?: defaults.fullScreenBackgroundColor,
            fullScreenBackgroundUrl = incoming?.get("fullScreenBackgroundUrl") as? String
                ?: defaults.fullScreenBackgroundUrl,
            fullScreenTextColor = incoming?.get("fullScreenTextColor") as? String
                ?: defaults.fullScreenTextColor,
            showFullScreenOnLockScreen = android["showFullScreenOnLockScreen"] as? Boolean
                ?: defaults.showFullScreenOnLockScreen,
            incomingCallNotificationChannelName =
                android["incomingCallNotificationChannelName"] as? String,
            missedCallNotificationChannelName =
                android["missedCallNotificationChannelName"] as? String,
            missedNotificationId = missed?.get("id") as? Int,
            showMissedCallNotification = missed?.get("showNotification") as? Boolean
                ?: defaults.showMissedCallNotification,
            missedNotificationCount = missed?.get("count") as? Int
                ?: defaults.missedNotificationCount,
            missedNotificationSubtitle = missed?.get("subtitle") as? String,
            missedNotificationCallbackText = missed?.get("callbackText") as? String,
            showCallbackButton = missed?.get("showCallbackButton") as? Boolean
                ?: defaults.showCallbackButton,
            isImportant = android["isImportant"] as? Boolean ?: defaults.isImportant,
            isBot = android["isBot"] as? Boolean ?: defaults.isBot,
        )
    }

    // endregion

    // region Bundle

    /**
     * The Bundle an intent carries for [call]. The missed-call notification id is left out when
     * the call has none. [RingingCall.isAccepted] is not carried.
     */
    fun toBundle(call: RingingCall): Bundle = Bundle().apply {
        putString(IncomingCallConstants.EXTRA_CALL_ID, call.id)
        putString(IncomingCallConstants.EXTRA_CALL_NAME_CALLER, call.callerName)
        putString(IncomingCallConstants.EXTRA_CALL_HANDLE, call.handle)
        putString(IncomingCallConstants.EXTRA_CALL_AVATAR, call.avatar)
        putString(IncomingCallConstants.EXTRA_CALL_DEFAULT_AVATAR, call.defaultAvatar)
        putInt(IncomingCallConstants.EXTRA_CALL_TYPE, call.type)
        putLong(IncomingCallConstants.EXTRA_CALL_DURATION, call.duration)
        putString(IncomingCallConstants.EXTRA_CALL_TEXT_ACCEPT, call.textAccept)
        putString(IncomingCallConstants.EXTRA_CALL_TEXT_DECLINE, call.textDecline)

        call.missedNotificationId?.let {
            putInt(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_ID, it)
        }
        putBoolean(
            IncomingCallConstants.EXTRA_CALL_MISSED_CALL_SHOW,
            call.showMissedCallNotification,
        )
        putInt(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_COUNT, call.missedNotificationCount)
        putString(
            IncomingCallConstants.EXTRA_CALL_MISSED_CALL_SUBTITLE,
            call.missedNotificationSubtitle,
        )
        putBoolean(
            IncomingCallConstants.EXTRA_CALL_MISSED_CALL_CALLBACK_SHOW,
            call.showCallbackButton,
        )
        putString(
            IncomingCallConstants.EXTRA_CALL_MISSED_CALL_CALLBACK_TEXT,
            call.missedNotificationCallbackText,
        )

        putSerializable(IncomingCallConstants.EXTRA_CALL_EXTRA, HashMap(call.extra))
        putSerializable(IncomingCallConstants.EXTRA_CALL_HEADERS, HashMap(call.headers))

        putBoolean(IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_SHOW_LOGO, call.fullScreenShowLogo)
        putString(IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_LOGO_URL, call.fullScreenLogoUrl)
        putBoolean(IncomingCallConstants.EXTRA_CALL_SHOW_CALL_HANDLE, call.showCallHandle)
        putString(IncomingCallConstants.EXTRA_CALL_RINGTONE_PATH, call.ringtonePath)
        putString(
            IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_BACKGROUND_COLOR,
            call.fullScreenBackgroundColor,
        )
        putString(
            IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_BACKGROUND_URL,
            call.fullScreenBackgroundUrl,
        )
        putString(
            IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_TEXT_COLOR,
            call.fullScreenTextColor,
        )
        putString(IncomingCallConstants.EXTRA_CALL_ACTION_FROM, call.from)
        putString(
            IncomingCallConstants.EXTRA_CALL_INCOMING_CALL_NOTIFICATION_CHANNEL_NAME,
            call.incomingCallNotificationChannelName,
        )
        putString(
            IncomingCallConstants.EXTRA_CALL_MISSED_CALL_NOTIFICATION_CHANNEL_NAME,
            call.missedCallNotificationChannelName,
        )
        putBoolean(
            IncomingCallConstants.EXTRA_CALL_IS_SHOW_FULL_LOCKED_SCREEN,
            call.showFullScreenOnLockScreen,
        )
        putBoolean(IncomingCallConstants.EXTRA_CALL_IS_IMPORTANT, call.isImportant)
        putBoolean(IncomingCallConstants.EXTRA_CALL_IS_BOT, call.isBot)
    }

    /** Reads a Bundle written by [toBundle]. A missing key or null string gives the default. */
    @Suppress("DEPRECATION")
    fun fromBundle(bundle: Bundle): RingingCall = RingingCall(
        id = bundle.getString(IncomingCallConstants.EXTRA_CALL_ID, defaults.id),
        callerName = bundle.getString(
            IncomingCallConstants.EXTRA_CALL_NAME_CALLER,
            defaults.callerName,
        ),
        handle = bundle.getString(IncomingCallConstants.EXTRA_CALL_HANDLE, defaults.handle),
        type = bundle.getInt(IncomingCallConstants.EXTRA_CALL_TYPE, defaults.type),
        duration = bundle.getLong(IncomingCallConstants.EXTRA_CALL_DURATION, defaults.duration),
        extra = bundle.getSerializable(IncomingCallConstants.EXTRA_CALL_EXTRA)
            as? Map<String, Any?> ?: defaults.extra,
        headers = bundle.getSerializable(IncomingCallConstants.EXTRA_CALL_HEADERS)
            as? Map<String, Any?> ?: defaults.headers,
        avatar = bundle.getString(IncomingCallConstants.EXTRA_CALL_AVATAR, defaults.avatar),
        defaultAvatar = bundle.getString(
            IncomingCallConstants.EXTRA_CALL_DEFAULT_AVATAR,
            defaults.defaultAvatar,
        ),
        ringtonePath = bundle.getString(
            IncomingCallConstants.EXTRA_CALL_RINGTONE_PATH,
            defaults.ringtonePath,
        ),
        from = bundle.getString(IncomingCallConstants.EXTRA_CALL_ACTION_FROM, defaults.from),
        textAccept = bundle.getString(
            IncomingCallConstants.EXTRA_CALL_TEXT_ACCEPT,
            defaults.textAccept,
        ),
        textDecline = bundle.getString(
            IncomingCallConstants.EXTRA_CALL_TEXT_DECLINE,
            defaults.textDecline,
        ),
        showCallHandle = bundle.getBoolean(
            IncomingCallConstants.EXTRA_CALL_SHOW_CALL_HANDLE,
            defaults.showCallHandle,
        ),
        fullScreenShowLogo = bundle.getBoolean(
            IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_SHOW_LOGO,
            defaults.fullScreenShowLogo,
        ),
        fullScreenLogoUrl = bundle.getString(
            IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_LOGO_URL,
            defaults.fullScreenLogoUrl,
        ),
        fullScreenBackgroundColor = bundle.getString(
            IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_BACKGROUND_COLOR,
            defaults.fullScreenBackgroundColor,
        ),
        fullScreenBackgroundUrl = bundle.getString(
            IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_BACKGROUND_URL,
            defaults.fullScreenBackgroundUrl,
        ),
        fullScreenTextColor = bundle.getString(
            IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_TEXT_COLOR,
            defaults.fullScreenTextColor,
        ),
        showFullScreenOnLockScreen = bundle.getBoolean(
            IncomingCallConstants.EXTRA_CALL_IS_SHOW_FULL_LOCKED_SCREEN,
            defaults.showFullScreenOnLockScreen,
        ),
        incomingCallNotificationChannelName = bundle.getString(
            IncomingCallConstants.EXTRA_CALL_INCOMING_CALL_NOTIFICATION_CHANNEL_NAME,
        ),
        missedCallNotificationChannelName = bundle.getString(
            IncomingCallConstants.EXTRA_CALL_MISSED_CALL_NOTIFICATION_CHANNEL_NAME,
        ),
        missedNotificationId = if (
            bundle.containsKey(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_ID)
        ) {
            bundle.getInt(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_ID)
        } else {
            defaults.missedNotificationId
        },
        showMissedCallNotification = bundle.getBoolean(
            IncomingCallConstants.EXTRA_CALL_MISSED_CALL_SHOW,
            defaults.showMissedCallNotification,
        ),
        missedNotificationCount = bundle.getInt(
            IncomingCallConstants.EXTRA_CALL_MISSED_CALL_COUNT,
            defaults.missedNotificationCount,
        ),
        missedNotificationSubtitle = bundle.getString(
            IncomingCallConstants.EXTRA_CALL_MISSED_CALL_SUBTITLE,
        ),
        missedNotificationCallbackText = bundle.getString(
            IncomingCallConstants.EXTRA_CALL_MISSED_CALL_CALLBACK_TEXT,
        ),
        showCallbackButton = bundle.getBoolean(
            IncomingCallConstants.EXTRA_CALL_MISSED_CALL_CALLBACK_SHOW,
            defaults.showCallbackButton,
        ),
        isImportant = bundle.getBoolean(
            IncomingCallConstants.EXTRA_CALL_IS_IMPORTANT,
            defaults.isImportant,
        ),
        isBot = bundle.getBoolean(IncomingCallConstants.EXTRA_CALL_IS_BOT, defaults.isBot),
    )

    // endregion

    // region ringing event

    /**
     * The body of a ringing event for [call]. The handle is sent as `number`, a missing
     * missed-call notification id as 0 and a missing channel name as an empty string.
     */
    fun toEventBody(call: RingingCall, endedBySystem: Boolean = false): Map<String, Any?> {
        val missedCallNotification = mapOf(
            "id" to (call.missedNotificationId ?: 0),
            "showNotification" to call.showMissedCallNotification,
            "count" to call.missedNotificationCount,
            "subtitle" to call.missedNotificationSubtitle,
            "callbackText" to call.missedNotificationCallbackText,
            "showCallbackButton" to call.showCallbackButton,
        )
        val incomingCallNotification = mapOf(
            "fullScreenShowLogo" to call.fullScreenShowLogo,
            "fullScreenLogoUrl" to call.fullScreenLogoUrl,
            "fullScreenBackgroundColor" to call.fullScreenBackgroundColor,
            "fullScreenBackgroundUrl" to call.fullScreenBackgroundUrl,
            "fullScreenTextColor" to call.fullScreenTextColor,
            "textAccept" to call.textAccept,
            "textDecline" to call.textDecline,
        )
        val android = mapOf(
            "ringtonePath" to call.ringtonePath,
            "defaultAvatar" to call.defaultAvatar,
            "missedCallNotification" to missedCallNotification,
            "incomingCallNotification" to incomingCallNotification,
            "incomingCallNotificationChannelName" to
                (call.incomingCallNotificationChannelName ?: ""),
            "missedCallNotificationChannelName" to
                (call.missedCallNotificationChannelName ?: ""),
            "isImportant" to call.isImportant,
            "isBot" to call.isBot,
        )
        return mapOf(
            "id" to call.id,
            "callerName" to call.callerName,
            "avatar" to call.avatar,
            "number" to call.handle,
            "type" to call.type,
            "duration" to call.duration,
            "endedBySystem" to endedBySystem,
            "extra" to HashMap(call.extra),
            "android" to android,
        )
    }

    // endregion

    // region stored active calls

    /** One entry of the stored active-calls list, which `activeCalls` also hands to Dart. */
    fun toStoredMap(call: RingingCall): Map<String, Any?> = linkedMapOf(
        "id" to call.id,
        "callerName" to call.callerName,
        "handle" to call.handle,
        "type" to call.type,
        "duration" to call.duration,
        "textAccept" to call.textAccept,
        "textDecline" to call.textDecline,
        "extra" to call.extra,
        "headers" to call.headers,
        "avatar" to call.avatar,
        "defaultAvatar" to call.defaultAvatar,
        "from" to call.from,
        "fullScreenShowLogo" to call.fullScreenShowLogo,
        "fullScreenLogoUrl" to call.fullScreenLogoUrl,
        "showCallHandle" to call.showCallHandle,
        "ringtonePath" to call.ringtonePath,
        "fullScreenBackgroundColor" to call.fullScreenBackgroundColor,
        "fullScreenBackgroundUrl" to call.fullScreenBackgroundUrl,
        "fullScreenTextColor" to call.fullScreenTextColor,
        "incomingCallNotificationChannelName" to call.incomingCallNotificationChannelName,
        "missedCallNotificationChannelName" to call.missedCallNotificationChannelName,
        "missedNotificationId" to call.missedNotificationId,
        "isShowMissedCallNotification" to call.showMissedCallNotification,
        "missedNotificationCount" to call.missedNotificationCount,
        "missedNotificationSubtitle" to call.missedNotificationSubtitle,
        "missedNotificationCallbackText" to call.missedNotificationCallbackText,
        "showCallbackButton" to call.showCallbackButton,
        "isAccepted" to call.isAccepted,
        "showFullScreenOnLockScreen" to call.showFullScreenOnLockScreen,
        "isImportant" to call.isImportant,
        "isBot" to call.isBot,
    )

    /** Reads an entry written by [toStoredMap]. Keys it does not know are ignored. */
    fun fromStoredMap(map: Map<String, Any?>): RingingCall = RingingCall(
        id = map["id"] as? String ?: defaults.id,
        callerName = map["callerName"] as? String ?: defaults.callerName,
        handle = map["handle"] as? String ?: defaults.handle,
        type = (map["type"] as? Number)?.toInt() ?: defaults.type,
        duration = (map["duration"] as? Number)?.toLong() ?: defaults.duration,
        textAccept = map["textAccept"] as? String ?: defaults.textAccept,
        textDecline = map["textDecline"] as? String ?: defaults.textDecline,
        extra = map["extra"] as? Map<String, Any?> ?: defaults.extra,
        headers = map["headers"] as? Map<String, Any?> ?: defaults.headers,
        avatar = map["avatar"] as? String ?: defaults.avatar,
        defaultAvatar = map["defaultAvatar"] as? String ?: defaults.defaultAvatar,
        from = map["from"] as? String ?: defaults.from,
        fullScreenShowLogo = map["fullScreenShowLogo"] as? Boolean
            ?: defaults.fullScreenShowLogo,
        fullScreenLogoUrl = map["fullScreenLogoUrl"] as? String ?: defaults.fullScreenLogoUrl,
        showCallHandle = map["showCallHandle"] as? Boolean ?: defaults.showCallHandle,
        ringtonePath = map["ringtonePath"] as? String ?: defaults.ringtonePath,
        fullScreenBackgroundColor = map["fullScreenBackgroundColor"] as? String
            ?: defaults.fullScreenBackgroundColor,
        fullScreenBackgroundUrl = map["fullScreenBackgroundUrl"] as? String
            ?: defaults.fullScreenBackgroundUrl,
        fullScreenTextColor = map["fullScreenTextColor"] as? String
            ?: defaults.fullScreenTextColor,
        incomingCallNotificationChannelName =
            map["incomingCallNotificationChannelName"] as? String,
        missedCallNotificationChannelName = map["missedCallNotificationChannelName"] as? String,
        missedNotificationId = (map["missedNotificationId"] as? Number)?.toInt(),
        showMissedCallNotification = map["isShowMissedCallNotification"] as? Boolean
            ?: defaults.showMissedCallNotification,
        missedNotificationCount = (map["missedNotificationCount"] as? Number)?.toInt()
            ?: defaults.missedNotificationCount,
        missedNotificationSubtitle = map["missedNotificationSubtitle"] as? String,
        missedNotificationCallbackText = map["missedNotificationCallbackText"] as? String,
        showCallbackButton = map["showCallbackButton"] as? Boolean
            ?: defaults.showCallbackButton,
        isAccepted = map["isAccepted"] as? Boolean ?: defaults.isAccepted,
        showFullScreenOnLockScreen = map["showFullScreenOnLockScreen"] as? Boolean
            ?: defaults.showFullScreenOnLockScreen,
        isImportant = map["isImportant"] as? Boolean ?: defaults.isImportant,
        isBot = map["isBot"] as? Boolean ?: defaults.isBot,
    )

    // endregion
}
