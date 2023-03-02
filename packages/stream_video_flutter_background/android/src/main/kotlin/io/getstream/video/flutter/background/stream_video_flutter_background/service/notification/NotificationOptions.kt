package io.getstream.video.flutter.background.stream_video_flutter_background.service.notification

data class NotificationOptions(
    val appId: String = "",
    val callCid: String = "",
    val contentTitle: String = "",
    val contentText: String = ""
) {

    companion object {
        const val APP_ID = "app_id"
        const val CALL_CID = "call_cid"
        const val CONTENT_TITLE = "content_title"
        const val CONTENT_TEXT = "content_text"
    }

}
