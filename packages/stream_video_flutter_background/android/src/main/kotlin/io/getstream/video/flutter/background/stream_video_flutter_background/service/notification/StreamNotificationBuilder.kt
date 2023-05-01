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

import android.app.Notification

/**
 * Handler responsible for showing and dismissing notification.
 */
interface StreamNotificationBuilder {

    /**
     * Shows a notification for the given [NotificationPayload].
     */
    fun build(payload: NotificationPayload): IdentifiedNotification
}

data class IdentifiedNotification(val id: Int, val notification: Notification) {
    companion object {
        const val ACTION_CALL_SUFFIX = "intent.action.STREAM_CALL"
    }
}
