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

    @JsonProperty("isCustomSmallExNotification")
    var isCustomSmallExNotification: Boolean = false

    @JsonProperty("isShowLogo")
    var isShowLogo: Boolean = false

    @JsonProperty("logoUrl")
    var logoUrl: String

    @JsonProperty("isShowCallID")
    var isShowCallID: Boolean = false

    @JsonProperty("ringtonePath")
    var ringtonePath: String

    @JsonProperty("backgroundColor")
    var backgroundColor: String

    @JsonProperty("backgroundUrl")
    var backgroundUrl: String

    @JsonProperty("textColor")
    var textColor: String

    @JsonProperty("actionColor")
    var actionColor: String

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

    @JsonProperty("isShowCallback")
    var isShowCallback: Boolean = true

    @JsonProperty("isAccepted")
    var isAccepted: Boolean = false

    @JsonProperty("callingNotificationId")
    var callingNotificationId: String? = null

    @JsonProperty("isShowCallingNotification")
    var isShowCallingNotification: Boolean = true

    @JsonProperty("callingNotificationSubtitle")
    var callingNotificationSubtitle: String? = null

    @JsonProperty("callingNotificationCallbackText")
    var callingNotificationHangupText: String? = null

    @JsonProperty("isShowHangup")
    var isShowHangup: Boolean = true

    @JsonProperty("isOnHold")
    var isOnHold: Boolean = (args["isOnHold"] as? Boolean) ?: false

    @JsonProperty("audioRoute")
    var audioRoute: Int = (args["audioRoute"] as? Int) ?: 1

    @JsonProperty("isMuted")
    var isMuted: Boolean = (args["isMuted"] as? Boolean) ?: false

    @JsonProperty("isShowFullLockedScreen")
    var isShowFullLockedScreen: Boolean = true

    @JsonProperty("isImportant")
    var isImportant: Boolean = false

    @JsonProperty("isBot")
    var isBot: Boolean = false

    init {
        var android: Map<String, Any?>? = args["android"] as? HashMap<String, Any?>?
        android = android ?: args
        avatar = android["avatar"] as? String ?: ""
        defaultAvatar = android["defaultAvatar"] as? String ?: ""
        isCustomSmallExNotification = android["isCustomSmallExNotification"] as? Boolean ?: false
        isShowLogo = android["isShowLogo"] as? Boolean ?: false
        logoUrl = android["logoUrl"] as? String ?: ""
        isShowCallID = android["isShowCallID"] as? Boolean ?: false
        ringtonePath = android["ringtonePath"] as? String ?: ""
        backgroundColor = android["backgroundColor"] as? String ?: "#0955fa"
        backgroundUrl = android["backgroundUrl"] as? String ?: ""
        actionColor = android["actionColor"] as? String ?: "#4CAF50"
        textColor = android["textColor"] as? String ?: "#ffffff"
        incomingCallNotificationChannelName =
            android["incomingCallNotificationChannelName"] as? String
        missedCallNotificationChannelName = android["missedCallNotificationChannelName"] as? String
        isShowFullLockedScreen = android["isShowFullLockedScreen"] as? Boolean ?: true
        isImportant = android["isImportant"] as? Boolean ?: false
        isBot = android["isBot"] as? Boolean ?: false

        val missedNotification: Map<String, Any?>? =
            android["missedCallNotification"] as? Map<String, Any?>?

        if (missedNotification != null) {
            missedNotificationId = missedNotification["id"] as? Int?
            missedNotificationSubtitle = missedNotification["subtitle"] as? String?
            missedNotificationCount = missedNotification["count"] as? Int? ?: 1
            missedNotificationCallbackText = missedNotification["callbackText"] as? String?
            isShowCallback = missedNotification["isShowCallback"] as? Boolean ?: true
            isShowMissedCallNotification =
                missedNotification["showNotification"] as? Boolean ?: true
        } else {
            missedNotificationSubtitle = args["textMissedCall"] as? String ?: ""
            missedNotificationCallbackText = args["textCallback"] as? String ?: ""
            isShowCallback = android["isShowCallback"] as? Boolean ?: true
            isShowMissedCallNotification =
                android["isShowMissedCallNotification"] as? Boolean ?: true
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
            isShowCallback
        )
        bundle.putString(
            IncomingCallConstants.EXTRA_CALL_MISSED_CALL_CALLBACK_TEXT,
            missedNotificationCallbackText
        )

        bundle.putSerializable(IncomingCallConstants.EXTRA_CALL_EXTRA, extra)
        bundle.putSerializable(IncomingCallConstants.EXTRA_CALL_HEADERS, headers)

        bundle.putBoolean(
            IncomingCallConstants.EXTRA_CALL_IS_CUSTOM_SMALL_EX_NOTIFICATION,
            isCustomSmallExNotification
        )
        bundle.putBoolean(
            IncomingCallConstants.EXTRA_CALL_IS_SHOW_LOGO,
            isShowLogo
        )
        bundle.putString(
            IncomingCallConstants.EXTRA_CALL_LOGO_URL,
            logoUrl
        )
        bundle.putBoolean(
            IncomingCallConstants.EXTRA_CALL_IS_SHOW_CALL_ID,
            isShowCallID
        )
        bundle.putString(IncomingCallConstants.EXTRA_CALL_RINGTONE_PATH, ringtonePath)
        bundle.putString(
            IncomingCallConstants.EXTRA_CALL_BACKGROUND_COLOR,
            backgroundColor
        )
        bundle.putString(
            IncomingCallConstants.EXTRA_CALL_BACKGROUND_URL,
            backgroundUrl
        )
        bundle.putString(IncomingCallConstants.EXTRA_CALL_TEXT_COLOR, textColor)
        bundle.putString(IncomingCallConstants.EXTRA_CALL_ACTION_COLOR, actionColor)
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
            isShowFullLockedScreen
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
            data.isShowCallback =
                bundle.getBoolean(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_CALLBACK_SHOW, false)
            data.missedNotificationCallbackText =
                bundle.getString(IncomingCallConstants.EXTRA_CALL_MISSED_CALL_CALLBACK_TEXT, "")

            data.extra =
                bundle.getSerializable(IncomingCallConstants.EXTRA_CALL_EXTRA) as HashMap<String, Any?>
            data.headers =
                bundle.getSerializable(IncomingCallConstants.EXTRA_CALL_HEADERS) as HashMap<String, Any?>

            data.isCustomSmallExNotification = bundle.getBoolean(
                IncomingCallConstants.EXTRA_CALL_IS_CUSTOM_SMALL_EX_NOTIFICATION,
                false
            )
            data.isShowLogo = bundle.getBoolean(
                IncomingCallConstants.EXTRA_CALL_IS_SHOW_LOGO,
                false
            )
            data.logoUrl =
                bundle.getString(IncomingCallConstants.EXTRA_CALL_LOGO_URL, "")
            data.isShowCallID = bundle.getBoolean(
                IncomingCallConstants.EXTRA_CALL_IS_SHOW_CALL_ID,
                false
            )
            data.ringtonePath = bundle.getString(
                IncomingCallConstants.EXTRA_CALL_RINGTONE_PATH,
                ""
            )
            data.backgroundColor = bundle.getString(
                IncomingCallConstants.EXTRA_CALL_BACKGROUND_COLOR,
                "#0955fa"
            )
            data.backgroundUrl =
                bundle.getString(IncomingCallConstants.EXTRA_CALL_BACKGROUND_URL, "")
            data.actionColor = bundle.getString(
                IncomingCallConstants.EXTRA_CALL_ACTION_COLOR,
                "#4CAF50"
            )
            data.textColor = bundle.getString(
                IncomingCallConstants.EXTRA_CALL_TEXT_COLOR,
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
            data.isShowFullLockedScreen = bundle.getBoolean(
                IncomingCallConstants.EXTRA_CALL_IS_SHOW_FULL_LOCKED_SCREEN,
                true
            )
            return data
        }
    }

}
