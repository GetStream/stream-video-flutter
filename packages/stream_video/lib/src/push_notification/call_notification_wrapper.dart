import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

class CallNotificationWrapper {
  const CallNotificationWrapper();

  Future<void> showCallNotification({
    required String callId,
    required String callers,
    required bool isVideoCall,
    required void Function(String callId) onCallAccepted,
    required void Function(String callId) onCallRejected,
    String? avatarUrl,
  }) async {
    final callKitParams = CallKitParams(
      id: callId,
      nameCaller: callers,
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
    // TODO: Cancel the listener after an event is fired.
    FlutterCallkitIncoming.onEvent.listen((event) {
      if (event?.event == Event.ACTION_CALL_ACCEPT) {
        onCallAccepted(callId);
      } else if (event?.event == Event.ACTION_CALL_DECLINE) {
        onCallRejected(callId);
      }
    });
  }
}
