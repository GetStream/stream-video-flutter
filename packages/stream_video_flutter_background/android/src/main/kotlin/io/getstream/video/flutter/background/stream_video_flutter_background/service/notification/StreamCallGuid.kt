package io.getstream.video.flutter.background.stream_video_flutter_background.service.notification

import java.io.Serializable

typealias StreamCallCid = String

public data class StreamCallGuid(
    val type: String,
    val id: String,
    val cid: String
) : Serializable