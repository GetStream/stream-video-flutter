import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_video/stream_video.dart';

import '../call/call.dart';
import '../stream_video.dart';
import 'call_notification_wrapper.dart';

abstract class PushNotificationManager {
  Future<void> onUserLoggedIn();
  Future<bool> handlePushNotification(Map<String, dynamic> payload);
  Future<Call?> consumeIncomingCall();
}

class StreamPushNotificationManager implements PushNotificationManager {
  StreamPushNotificationManager._create({
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

  Future<bool> handlePushNotification(Map<String, dynamic> payload) async {
    if (_isValid(payload)) {
      final cid = payload['call_cid'] as String;
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

  bool _isValid(Map<String, dynamic> payload) {
    return _isFromStreamServer(payload) && _isValidIncomingCall(payload);
  }

  bool _isFromStreamServer(Map<String, dynamic> payload) {
    return payload['sender'] == 'stream.video';
  }

  bool _isValidIncomingCall(Map<String, dynamic> payload) {
    return payload['type'] == 'call_incoming' &&
        ((payload['call_cid'] as String?)?.isNotEmpty ?? false);
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

  static Future<StreamPushNotificationManager> create(
    StreamVideo client, {
    SharedPreferences? sharedPreferences,
    CallNotificationWrapper? callNotification,
  }) async {
    return StreamPushNotificationManager._create(
      client: client,
      sharedPreferences:
          sharedPreferences ?? await SharedPreferences.getInstance(),
      callNotification: callNotification ?? const CallNotificationWrapper(),
    );
  }
}
