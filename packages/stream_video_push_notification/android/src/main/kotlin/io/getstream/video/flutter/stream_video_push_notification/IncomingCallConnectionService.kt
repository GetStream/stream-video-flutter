package io.getstream.video.flutter.stream_video_push_notification

import android.os.Build
import android.telecom.ConnectionService
import androidx.annotation.RequiresApi

@RequiresApi(Build.VERSION_CODES.M)
class IncomingCallConnectionService: ConnectionService() {
    //not need overridesss
}