import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_video/stream_video.dart';

import '../call/call.dart';
import '../stream_video.dart';
import 'call_notification_wrapper.dart';

class PushNotificationManager {
  PushNotificationManager._create({
    required StreamVideo client,
    required SharedPreferences sharedPreferences,
    CallNotificationWrapper callNotification = const CallNotificationWrapper(),
  })  : _client = client,
        _callNotification = callNotification,
        _sharedPreferences = sharedPreferences;

  final _logger = taggedLogger(tag: 'PNManager');
  final StreamVideo _client;
  final CallNotificationWrapper _callNotification;
  final SharedPreferences _sharedPreferences;

  Future<void> onUserLoggedIn() async {
    if (_isFirebaseInitialized()) {
      FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        await _registerFirebaseToken(token);
      });
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _registerFirebaseToken(token);
      } else {
        _logger.w(() => 'Firebase Token was null');
      }
    }
  }

  Future<void> _registerFirebaseToken(String token) async {
    _logger.d(() => 'New Firebase Token: $token');
    await _client.createDevice(token: token);
  }

  Future<bool> handlePushNotification(RemoteMessage remoteMessage) async {
    if (_isValid(remoteMessage)) {
      final cid = remoteMessage.data['call_cid'] as String;
      final type = cid.substring(0, cid.indexOf(':'));
      final id = cid.substring(cid.indexOf(':') + 1);
      final call = await _client.getOrCreateCall(type: type, id: id);
      await _callNotification.showCallNotification(
        callId: cid,
        callers: call.users.values.map((e) => e.name).join(', '),
        isVideoCall: true,
        avatarUrl: call.users.values.firstOrNull?.imageUrl,
        onCallAccepted: _acceptCall,
        onCallRejected: _rejectCall,
      );
      return true;
    }
    return false;
  }

  Future<void> _acceptCall(String cid) async {
    await _sharedPreferences.setString('incomingCallCid', cid);
    await _client.acceptCall(
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
    await _sharedPreferences.reload();
    final incomingCallCid = _sharedPreferences.getString('incomingCallCid');
    await _sharedPreferences.remove('incomingCallCid');
    if (incomingCallCid != null) {
      return _client.acceptCall(
        type: incomingCallCid.substring(0, incomingCallCid.indexOf(':')),
        id: incomingCallCid.substring(incomingCallCid.indexOf(':') + 1),
      );
    }
    return Future.value();
  }

  static Future<PushNotificationManager> create(
    StreamVideo client, {
    SharedPreferences? sharedPreferences,
    CallNotificationWrapper? callNotification,
  }) async {
    return PushNotificationManager._create(
      client: client,
      sharedPreferences:
          sharedPreferences ?? await SharedPreferences.getInstance(),
      callNotification: callNotification ?? const CallNotificationWrapper(),
    );
  }
}
