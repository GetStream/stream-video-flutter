package io.getstream.video.flutter.background.stream_video_flutter_background.service.notification

data class NotificationOptions(
    val callCid: String = "",
    val contentTitle: String? = null,
    val contentText: String? = null,
) {

    companion object {
        const val CALL_CID = "call_cid"
        const val CONTENT_TITLE = "content_title"
        const val CONTENT_TEXT = "content_text"
    }

}
