import 'dart:async';

import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter_background/model/notification_options.dart';
import 'package:stream_video_flutter_background/stream_video_flutter_background.dart';

const _tag = 'SV:Foreground';
const _btnCancel = 'cancel';

class BackgroundService {
  BackgroundService() {
    streamLog.i(_tag, () => '<init> no args');
  }

  static void init({
    NotificationOptions? notificationOptions,
  }) {
    Call.onActiveCall = _onActiveCall;
  }

  static Future<void> _onActiveCall(Call? call) async {
    try {
      streamLog.d(_tag, () => '[onActiveCall] activeCall: $call');
      if (call != null) {
        final contentText = call.state.valueOrNull?.callParticipants
                .map((it) => it.name)
                .join(', ') ??
            '';
        final result = await StreamVideoFlutterBackground.startService(
          NotificationOptions(
            appId: 'abc321',
            callCid: call.callCid.value,
            contentTitle: 'Stream Example App',
            contentText: contentText,
          ),
        );
        streamLog.v(_tag, () => '[onActiveCall] result: $result');
        if (result) {
          StreamVideoFlutterBackground.setOnButtonClick((
            buttonType,
            callCid,
          ) async {
            if (call.callCid.value != callCid) {
              return;
            }
            if (buttonType == _btnCancel) {
              await call.apply(const CancelCall());
              await call.disconnect();
            }
          });
        }
      } else {
        StreamVideoFlutterBackground.setOnButtonClick(null);
        await StreamVideoFlutterBackground.stopService();
      }
    } catch (e, stk) {
      streamLog.e(_tag, () => '[onActiveCall] failed: $e, stk: $stk');
    }
  }
}
