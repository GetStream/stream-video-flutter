import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../call/call.dart';
import '../models/call_configuration.dart';
import '../stream_video.dart';
import 'call_notification_wrapper.dart';

class PushNotificationManager {
  PushNotificationManager({
    required StreamVideo client,
    required SharedPreferences sharedPreferences,
    CallNotificationWrapper callNotification = const CallNotificationWrapper(),
  })  : _client = client,
        _callNotification = callNotification,
        _sharedPreferences = sharedPreferences;

  final StreamVideo _client;
  final CallNotificationWrapper _callNotification;
  final SharedPreferences _sharedPreferences;

  Future<void> onUserLoggedIn() async {
    print('JcLog: [onUserLoggedIn]');
    if (_isFirebaseInitialized()) {
      FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        await _registerFirebaseToken(token);
      });
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _registerFirebaseToken(token);
      } else {
        print('JcLog: Firebase Token was null');
      }
    }
  }

  Future<void> _registerFirebaseToken(String token) async {
    print('JcLog: New Firebase Token: $token');
    await _client.createDevice(token: token);
  }

  Future<bool> handlePushNotification(
    RemoteMessage remoteMessage,
    void Function(Call call) onCallAccepted,
  ) async {
    if (_isValid(remoteMessage)) {
      final cid = remoteMessage.data['call_cid'] as String;
      final type = cid.substring(0, cid.indexOf(':'));
      final id = cid.substring(cid.indexOf(':') + 1);
      // final call = await _client.getOrCreateCall(type: type, id: id);
      await _callNotification.showCallNotification(
        callId: cid,
        callers: 'Jc, Isa',
        //call.users.values.map((e) => e.name).join(', '),
        isVideoCall: true,
        avatarUrl: '',
        //call.users.values.firstOrNull?.imageUrl,
        onCallAccepted: (cid) async {
          print('JcLog: Storing incomingCallCid: $cid');
          await _sharedPreferences.setString('incomingCallCid', cid);

          onCallAccepted(
            Call(
              callConfiguration: const CallConfiguration(
                type: 'type',
                id: 'id',
                participantIds: ['jc', 'isa'],
              ),
            ),
          );
        },
        onCallRejected: _rejectCall,
      );
      return true;
    }
    return false;
  }

  Future<Call> _acceptCall(String cid) {
    return _client.acceptCall(
      type: cid.substring(0, cid.indexOf(':')),
      id: cid.substring(cid.indexOf(':') + 1),
    );
  }

  Future<void> _rejectCall(String cid) async {
    await _client.rejectCall(callCid: cid);
  }

  bool _isValid(RemoteMessage remoteMessage) {
    return _isFromStreamServer(remoteMessage) &&
        _isValidIncomingCall(remoteMessage);
  }

  bool _isFromStreamServer(RemoteMessage remoteMessage) {
    return remoteMessage.data['sender'] == 'stream.video';
  }

  bool _isValidIncomingCall(RemoteMessage remoteMessage) {
    return remoteMessage.data['type'] == 'call_incoming' &&
        ((remoteMessage.data['call_cid'] as String?)?.isNotEmpty ?? false);
  }

  bool _isFirebaseInitialized() {
    return Firebase.apps.isNotEmpty;
  }

  Future<Call?> consumeIncomingCall() async {
    // We need to wait for a second to be sure sharedPreferences has been updated
    await Future.delayed(const Duration(milliseconds: 1000));
    await _sharedPreferences.reload();
    final infomingCallCid = _sharedPreferences.getString('incomingCallCid');
    await _sharedPreferences.remove('incomingCallCid');
    print('JcLog: incomingCallCid from sharedPreferences: $infomingCallCid');
    if (infomingCallCid != null) {
      // return _client.acceptCall(
      //   type: infomingCallCid.substring(0, infomingCallCid.indexOf(':')),
      //   id: infomingCallCid.substring(infomingCallCid.indexOf(':') + 1),
      // );
      return Future.value(
        Call(
          callConfiguration: const CallConfiguration(
            type: 'type',
            id: 'id',
            participantIds: ['jc', 'isa'],
          ),
        ),
      );
    }
    return Future.value(null);
  }
}
