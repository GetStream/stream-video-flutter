package io.getstream.video.flutter.background.stream_video_flutter_background.service.notification

data class NotificationPayload(
    val callCid: String = "",
    val options: NotificationOptions? = null,
) {
    companion object {
        private const val CALL_CID = "call_cid"
        private const val OPTIONS = "options"

        fun fromJson(json: Any?): NotificationPayload {
            if (json is Map<*, *>) {
                return NotificationPayload(
                    callCid = (json[CALL_CID] as? String) ?: error("no call_cid found"),
                    options = NotificationOptions.fromJson(json[OPTIONS])
                )
            }
            error("json must be an instance of Map, but was: $json")
        }
    }
}

data class NotificationOptions(
    val content: NotificationContent? = null,
    val avatar: NotificationAvatar? = null,
    val useCustomLayout: Boolean = false,
) {
    companion object {
        private const val CONTENT = "content"
        private const val AVATAR = "avatar"
        private const val USE_CUSTOM_LAYOUT = "use_custom_layout"

        fun fromJson(json: Any?): NotificationOptions? {
            if (json is Map<*, *>) {
                val content = NotificationContent.fromJson(json[CONTENT])
                val avatar = NotificationAvatar.fromJson(json[AVATAR])
                val rawUseCustomLayout = json[USE_CUSTOM_LAYOUT]
                if (rawUseCustomLayout is String) {
                    error("NotificationOptions.fromJson => use_custom_layout should be Boolean")
                }
                val useCustomLayout = (json[USE_CUSTOM_LAYOUT] as? Boolean) ?: false
                if (content != null || avatar != null) {
                    return NotificationOptions(
                        content = content,
                        avatar = avatar,
                        useCustomLayout = useCustomLayout,
                    )
                }
            }
            return null
        }
    }
}

data class NotificationContent(
    val title: String? = null,
    val text: String? = null,
) {
    companion object {
        private const val TITLE = "title"
        private const val TEXT = "text"

        fun fromJson(json: Any?): NotificationContent? {
            if (json is Map<*, *>) {
                val title = json[TITLE] as? String
                val text = json[TEXT] as? String
                if (title != null || text != null) {
                    return NotificationContent(title = title, text = text)
                }
            }
            return null
        }
    }
}

data class NotificationAvatar(
    val url: String? = null,
    val httpHeaders: Map<String, String> = emptyMap(),
) {
    companion object {
        const val URL = "url"
        const val HTTP_HEADERS = "http_headers"

        fun fromJson(json: Any?): NotificationAvatar? {
            if (json is Map<*, *>) {
                val url = json[URL] as? String
                val httpHeaders = json[HTTP_HEADERS] as? Map<String, String>
                if (url != null) {
                    return NotificationAvatar(
                        url = url,
                        httpHeaders = httpHeaders ?: emptyMap(),
                    )
                }
            }
            return null
        }
    }
}