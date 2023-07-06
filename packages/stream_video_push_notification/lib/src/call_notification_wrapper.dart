import 'dart:async';
import 'package:flutter_callkit_incoming/entities/entities.dart';
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
      nameCaller: streamCallCid.value,
      avatar: avatarUrl,
      handle: callers,
      type: isVideoCall ? 1 : 0,
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Missed call',
        callbackText: 'Call back',
      ),
      duration: 30000,
      android: AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0955fa',
        backgroundUrl: avatarUrl,
        actionColor: '#4CAF50',
        incomingCallNotificationChannelName: "Incoming Call",
      ),
      ios: const IOSParams(
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
      extra: {
        'incomingCallCid': streamCallCid.value,
      },
    );
    await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
    _streamSubscription = FlutterCallkitIncoming.onEvent.listen((event) {
      if (event?.event == Event.actionCallAccept) {
        onCallAccepted(streamCallCid);
        _streamSubscription?.cancel();
      } else if (event?.event == Event.actionCallDecline) {
        onCallRejected(streamCallCid);
        _streamSubscription?.cancel();
      }
    });
  }
}
