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

sealed class NotificationAction {
    internal abstract val type: String
    internal abstract val callCid: StreamCallCid

    internal data class Accept(override val callCid: StreamCallCid) : NotificationAction() {
        override val type: String = TYPE
        companion object {
            const val TYPE = "accept"
            const val SUFFIX = "intent.action.STREAM_ACCEPT"
        }
    }

    internal data class Reject(override val callCid: StreamCallCid) : NotificationAction() {
        override val type: String = TYPE
        companion object {
            const val TYPE = "reject"
            const val SUFFIX = "intent.action.STREAM_REJECT"
        }
    }

    internal data class Cancel(override val callCid: StreamCallCid) : NotificationAction() {
        override val type: String = TYPE
        companion object {
            const val TYPE = "cancel"
            const val SUFFIX = "intent.action.STREAM_CANCEL"
        }
    }
}
