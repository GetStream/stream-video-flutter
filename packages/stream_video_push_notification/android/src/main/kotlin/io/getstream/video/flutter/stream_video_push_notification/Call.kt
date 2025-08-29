package io.getstream.video.flutter.stream_video_push_notification

import android.os.Bundle
import com.fasterxml.jackson.annotation.JsonProperty

@Suppress("UNCHECKED_CAST")
data class Data(val args: Map<String, Any?>) {

    constructor() : this(emptyMap())

    @JsonProperty("id")
    var id: String = (args["id"] as? String) ?: ""

    @JsonProperty("uuid")
    var uuid: String = (args["id"] as? String) ?: ""

    @JsonProperty("callerName")
    var callerName: String = (args["callerName"] as? String) ?: ""

    @JsonProperty("handle")
    var handle: String = (args["handle"] as? String) ?: ""

    @JsonProperty("type")
    var type: Int = (args["type"] as? Int) ?: 0

    @JsonProperty("duration")
    var duration: Long =
        (args["duration"] as? Long) ?: ((args["duration"] as? Int)?.toLong() ?: 30000L)

    @JsonProperty("textAccept")
    var textAccept: String = (args["textAccept"] as? String) ?: ""

    @JsonProperty("textDecline")
    var textDecline: String = (args["textDecline"] as? String) ?: ""

    @JsonProperty("extra")
    var extra: HashMap<String, Any?> =
        (args["extra"] ?: HashMap<String, Any?>()) as HashMap<String, Any?>

    @JsonProperty("headers")
    var headers: HashMap<String, Any?> =
        (args["headers"] ?: HashMap<String, Any?>()) as HashMap<String, Any?>

    @JsonProperty("avatar")
    var avatar: String = ""

    @JsonProperty("defaultAvatar")
    var defaultAvatar: String = ""

    @JsonProperty("from")
    var from: String = ""

    @JsonProperty("fullScreenShowLogo")
    var fullScreenShowLogo: Boolean = false

    @JsonProperty("fullScreenLogoUrl")
    var fullScreenLogoUrl: String = ""

    @JsonProperty("showCallHandle")
    var showCallHandle: Boolean = false

    @JsonProperty("ringtonePath")
    var ringtonePath: String

    @JsonProperty("fullScreenBackgroundColor")
    var fullScreenBackgroundColor: String = "#0955fa"

    @JsonProperty("fullScreenBackgroundUrl")
    var fullScreenBackgroundUrl: String = ""

    @JsonProperty("fullScreenTextColor")
    var fullScreenTextColor: String = "#FFFFFF"

    @JsonProperty("incomingCallNotificationChannelName")
    var incomingCallNotificationChannelName: String? = null

    @JsonProperty("missedCallNotificationChannelName")
    var missedCallNotificationChannelName: String? = null

    @JsonProperty("missedNotificationId")
    var missedNotificationId: Int? = null

    @JsonProperty("isShowMissedCallNotification")
    var isShowMissedCallNotification: Boolean = true

    @JsonProperty("missedNotificationCount")
    var missedNotificationCount: Int = 1

    @JsonProperty("missedNotificationSubtitle")
    var missedNotificationSubtitle: String? = null

    @JsonProperty("missedNotificationCallbackText")
    var missedNotificationCallbackText: String? = null

    @JsonProperty("showCallbackButton")
    var showCallbackButton: Boolean = true

    @JsonProperty("isAccepted")
    var isAccepted: Boolean = false

    @JsonProperty("isOnHold")
    var isOnHold: Boolean = (args["isOnHold"] as? Boolean) ?: false

    @JsonProperty("audioRoute")
    var audioRoute: Int = (args["audioRoute"] as? Int) ?: 1

    @JsonProperty("isMuted")
    var isMuted: Boolean = (args["isMuted"] as? Boolean) ?: false

    @JsonProperty("showFullScreenOnLockScreen")
    var showFullScreenOnLockScreen: Boolean = true

    @JsonProperty("isImportant")
    var isImportant: Boolean = false

    @JsonProperty("isBot")
    var isBot: Boolean = false

    init {
        var android: Map<String, Any?>? = args["android"] as? HashMap<String, Any?>?
        android = android ?: args
        avatar = android["avatar"] as? String ?: ""
        defaultAvatar = android["defaultAvatar"] as? String ?: ""
        ringtonePath = android["ringtonePath"] as? String ?: ""
        incomingCallNotificationChannelName =
            android["incomingCallNotificationChannelName"] as? String
        missedCallNotificationChannelName = android["missedCallNotificationChannelName"] as? String
        showFullScreenOnLockScreen = android["showFullScreenOnLockScreen"] as? Boolean ?: true
        isImportant = android["isImportant"] as? Boolean ?: false
        isBot = android["isBot"] as? Boolean ?: false

        val missedNotification: Map<String, Any?>? =
            android["missedCallNotification"] as? Map<String, Any?>?

        if (missedNotification != null) {
            missedNotificationId = missedNotification["id"] as? Int?
            missedNotificationSubtitle = missedNotification["subtitle"] as? String?
            missedNotificationCount = missedNotification["count"] as? Int? ?: 1
            missedNotificationCallbackText = missedNotification["callbackText"] as? String?
            showCallbackButton = missedNotification["showCallbackButton"] as? Boolean ?: true
            isShowMissedCallNotification =
                missedNotification["showNotification"] as? Boolean ?: true
        } 

        val incomingNotification: Map<String, Any?>? =
            android["incomingCallNotification"] as? Map<String, Any?>?

        if (incomingNotification != null) {
            fullScreenShowLogo = incomingNotification["fullScreenShowLogo"] as? Boolean ?: false
            fullScreenLogoUrl = incomingNotification["fullScreenLogoUrl"] as? String? ?: ""
            fullScreenBackgroundColor = incomingNotification["fullScreenBackgroundColor"] as? String ?: "#0955fa"
            fullScreenBackgroundUrl = incomingNotification["fullScreenBackgroundUrl"] as? String ?: ""
            fullScreenTextColor = incomingNotification["fullScreenTextColor"] as? String ?: "#ffffff"
            textAccept = incomingNotification["textAccept"] as? String ?: ""
            textDecline = incomingNotification["textDecline"] as? String ?: ""
            showCallHandle = incomingNotification["showCallHandle"] as? Boolean ?: false
        }
    }

    override fun hashCode(): Int {
        return id.hashCode()
    }

    override fun equals(other: Any?): Boolean {
        if (other == null) return false
        val e: Data = other as Data
        return this.id == e.id
    }


    fun toBundle(): Bundle {
        val bundle = Bundle()
        bundle.putString(IncomingCallConstants.EXTRA_CALL_ID, id)
        bundle.putString(IncomingCallConstants.EXTRA_CALL_NAME_CALLER, callerName)
        bundle.putString(IncomingCallConstants.EXTRA_CALL_HANDLE, handle)
        bundle.putString(IncomingCallConstants.EXTRA_CALL_AVATAR, avatar)
        bundle.putString(IncomingCallConstants.EXTRA_CALL_DEFAULT_AVATAR, defaultAvatar)
        bundle.putInt(IncomingCallConstants.EXTRA_CALL_TYPE, type)
        bundle.putLong(IncomingCallConstants.EXTRA_CALL_DURATION, duration)
        bundle.putString(IncomingCallConstants.EXTRA_CALL_TEXT_ACCEPT, textAccept)
        bundle.putString(IncomingCallConstants.EXTRA_CALL_TEXT_DECLINE, textDecline)

        missedNotificationId?.let {
            bundle.putInt(
                IncomingCallConstants.EXTRA_CALL_MISSED_CALL_ID,
                it
            )
        }
        bundle.putBoolean(
            IncomingCallConstants.EXTRA_CALL_MISSED_CALL_SHOW,
            isShowMissedCallNotification
        )
        bundle.putInt(
            IncomingCallConstants.EXTRA_CALL_MISSED_CALL_COUNT,
            missedNotificationCount
        )
        bundle.putString(
            IncomingCallConstants.EXTRA_CALL_MISSED_CALL_SUBTITLE,
            missedNotificationSubtitle
        )
        bundle.putBoolean(
            IncomingCallConstants.EXTRA_CALL_MISSED_CALL_CALLBACK_SHOW,
            showCallbackButton
        )
        bundle.putString(
            IncomingCallConstants.EXTRA_CALL_MISSED_CALL_CALLBACK_TEXT,
            missedNotificationCallbackText
        )

        bundle.putSerializable(IncomingCallConstants.EXTRA_CALL_EXTRA, extra)
        bundle.putSerializable(IncomingCallConstants.EXTRA_CALL_HEADERS, headers)

        bundle.putBoolean(
            IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_SHOW_LOGO,
            fullScreenShowLogo
        )
        bundle.putString(
            IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_LOGO_URL,
            fullScreenLogoUrl
        )
        bundle.putBoolean(
            IncomingCallConstants.EXTRA_CALL_SHOW_CALL_HANDLE,
            showCallHandle
        )
        bundle.putString(IncomingCallConstants.EXTRA_CALL_RINGTONE_PATH, ringtonePath)
        bundle.putString(
            IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_BACKGROUND_COLOR,
            fullScreenBackgroundColor
        )
        bundle.putString(
            IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_BACKGROUND_URL,
            fullScreenBackgroundUrl
        )
        bundle.putString(IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_TEXT_COLOR, fullScreenTextColor)
        bundle.putString(IncomingCallConstants.EXTRA_CALL_ACTION_FROM, from)
        bundle.putString(
            IncomingCallConstants.EXTRA_CALL_INCOMING_CALL_NOTIFICATION_CHANNEL_NAME,
            incomingCallNotificationChannelName
        )
        bundle.putString(
            IncomingCallConstants.EXTRA_CALL_MISSED_CALL_NOTIFICATION_CHANNEL_NAME,
            missedCallNotificationChannelName
        )
        bundle.putBoolean(
            IncomingCallConstants.EXTRA_CALL_IS_SHOW_FULL_LOCKED_SCREEN,
            showFullScreenOnLockScreen
        )
        bundle.putBoolean(
            IncomingCallConstants.EXTRA_CALL_IS_IMPORTANT,
            isImportant,
        )
        bundle.putBoolean(
            IncomingCallConstants.EXTRA_CALL_IS_BOT,
            isBot,
        )
        return bundle
    }

    companion object {

        fun fromBundle(bundle: Bundle): Data {
            val data = Data(emptyMap())
            data.id = bundle.getString(IncomingCallConstants.EXTRA_CALL_ID, "")
            data.callerName =
                bundle.getString(IncomingCallConstants.EXTRA_CALL_NAME_CALLER, "")
            data.handle =
                bundle.getString(IncomingCallConstants.EXTRA_CALL_HANDLE, "")
            data.avatar =
                bundle.getString(IncomingCallConstants.EXTRA_CALL_AVATAR, "")
            data.defaultAvatar =
                bundle.getString(IncomingCallConstants.EXTRA_CALL_DEFAULT_AVATAR, "")
            data.type = bundle.getInt(IncomingCallConstants.EXTRA_CALL_TYPE, 0)
            data.duration =
                bundle.getLong(IncomingCallConstants.EXTRA_CALL_DURATION, 30000L)
            data.textAccept =
                bundle.getString(IncomingCallConstants.EXTRA_CALL_TEXT_ACCEPT, "")
            data.textDecline =
                bundle.getString(IncomingCallConstants.EXTRA_CALL_TEXT_DECLINE, "")
            data.isImportant =
                bundle.getBoolean(IncomingCallConstants.EXTRA_CALL_IS_IMPORTANT, false)
            data.isBot =
                bundle.getBoolean(IncomingCallConstants.EXTRA_CALL_IS_BOT, false)

            data.missedNotificationId =
                bundle.getInt(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_ID)
            data.isShowMissedCallNotification =
                bundle.getBoolean(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_SHOW, true)
            data.missedNotificationCount =
                bundle.getInt(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_COUNT, 1)
            data.missedNotificationSubtitle =
                bundle.getString(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_SUBTITLE, "")
            data.showCallbackButton =
                bundle.getBoolean(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_CALLBACK_SHOW, false)
            data.missedNotificationCallbackText =
                bundle.getString(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_CALLBACK_TEXT, "")

            data.extra =
                bundle.getSerializable(IncomingCallConstants.EXTRA_CALL_EXTRA) as HashMap<String, Any?>
            data.headers =
                bundle.getSerializable(IncomingCallConstants.EXTRA_CALL_HEADERS) as HashMap<String, Any?>

            data.fullScreenShowLogo = bundle.getBoolean(
                IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_SHOW_LOGO,
                false
            )
            data.fullScreenLogoUrl =
                bundle.getString(IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_LOGO_URL, "")
            data.showCallHandle = bundle.getBoolean(
                IncomingCallConstants.EXTRA_CALL_SHOW_CALL_HANDLE,
                false
            )
            data.ringtonePath = bundle.getString(
                IncomingCallConstants.EXTRA_CALL_RINGTONE_PATH,
                ""
            )
            data.fullScreenBackgroundColor = bundle.getString(
                IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_BACKGROUND_COLOR,
                "#0955fa"
            )
            data.fullScreenBackgroundUrl =
                bundle.getString(IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_BACKGROUND_URL, "")

            data.fullScreenTextColor = bundle.getString(
                IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_TEXT_COLOR,
                "#FFFFFF"
            )
            data.from =
                bundle.getString(IncomingCallConstants.EXTRA_CALL_ACTION_FROM, "")

            data.incomingCallNotificationChannelName = bundle.getString(
                IncomingCallConstants.EXTRA_CALL_INCOMING_CALL_NOTIFICATION_CHANNEL_NAME
            )
            data.missedCallNotificationChannelName = bundle.getString(
                IncomingCallConstants.EXTRA_CALL_MISSED_CALL_NOTIFICATION_CHANNEL_NAME
            )
            data.showFullScreenOnLockScreen = bundle.getBoolean(
                IncomingCallConstants.EXTRA_CALL_IS_SHOW_FULL_LOCKED_SCREEN,
                true
            )
            return data
        }
    }

}
