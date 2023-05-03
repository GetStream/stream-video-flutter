import 'dart:async';

import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:stream_video/stream_video.dart';
import 'package:uuid/uuid.dart';

StreamSubscription<CallEvent?>? _streamSubscription;

class CallNotificationWrapper {
  const CallNotificationWrapper();

  Future<void> showCallNotification({
    required StreamCallCid streamCallCid,
    required String callers,
    required bool isVideoCall,
    required void Function(StreamCallCid streamCallCid) onCallAccepted,
    required void Function(StreamCallCid streamCallCid) onCallRejected,
    String? avatarUrl,
  }) async {
    var uuid = const Uuid();
    final callKitParams = CallKitParams(
      id: uuid.v4(),
      nameCaller: 'Demo Call',
      avatar: avatarUrl,
      type: isVideoCall ? 1 : 0,
      textAccept: 'Accept',
      textDecline: 'Decline',
      textMissedCall: 'Missed call',
      duration: 30000,
      android: AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        isShowCallback: false,
        isShowMissedCallNotification: false,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0955fa',
        backgroundUrl: avatarUrl,
        actionColor: '#4CAF50',
        incomingCallNotificationChannelName: "Incoming Call",
      ),
      ios: IOSParams(
        iconName: 'CallKitLogo',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
    _streamSubscription = FlutterCallkitIncoming.onEvent.listen((event) {
      if (event?.event == Event.ACTION_CALL_ACCEPT) {
        onCallAccepted(streamCallCid);
        _streamSubscription?.cancel();
      } else if (event?.event == Event.ACTION_CALL_DECLINE) {
        onCallRejected(streamCallCid);
        _streamSubscription?.cancel();
      }
    });
  }
}
