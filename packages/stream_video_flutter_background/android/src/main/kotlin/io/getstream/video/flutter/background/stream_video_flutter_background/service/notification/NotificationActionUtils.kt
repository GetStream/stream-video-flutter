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

import android.content.Intent

private const val KEY_CID = "cid"

internal fun Intent.extractNotificationAction(): NotificationAction {
    val callGuid = extractCallGuid()
    val action = action.orEmpty()
    return when {
        action.endsWith(NotificationAction.Accept.SUFFIX) -> NotificationAction.Accept(callGuid)
        action.endsWith(NotificationAction.Reject.SUFFIX) -> NotificationAction.Reject(callGuid)
        action.endsWith(NotificationAction.Cancel.SUFFIX) -> NotificationAction.Cancel(callGuid)
        else -> error("unexpected action: $action")
    }
}

internal fun Intent.setNotificationAction(
    packageName: String,
    action: NotificationAction,
): Intent {
    putExtra(KEY_CID, action.callCid)
    this.action = when (action) {
        is NotificationAction.Accept -> "$packageName.${NotificationAction.Accept.SUFFIX}"
        is NotificationAction.Reject -> "$packageName.${NotificationAction.Reject.SUFFIX}"
        is NotificationAction.Cancel -> "$packageName.${NotificationAction.Cancel.SUFFIX}"
    }
    return this
}

private fun Intent.extractCallGuid(): StreamCallCid = getStringExtra(KEY_CID) ?: error("no cid found")
