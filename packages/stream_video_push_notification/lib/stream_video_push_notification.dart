library stream_video_push_notification;

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_video/stream_video.dart';

import 'src/call_notification_wrapper.dart';
import 'src/stream_video_push_notification_event_channel.dart';
import 'src/stream_video_push_notification_method_channel.dart';

class StreamVideoPushNotificationManager implements PushNotificationManager {
  StreamVideoPushNotificationManager._create({
    required CoordinatorClient client,
    required SharedPreferences sharedPreferences,
    required CallNotificationWrapper callNotification,
    required StreamVideoPushNotificationMethodChannel methodChannel,
    required StreamVideoPushNotificationEventChannel eventChannel,
  })  : _client = client,
        _callNotification = callNotification,
        _sharedPreferences = sharedPreferences,
        _methodChannel = methodChannel,
        _eventChannel = eventChannel {
    _eventChannel.onEvent.listen((event) {
      if (event.type == NativeEventType.ACTION_INCOMING_CALL) {
        _showCall(event.content['call_cid']);
      }
    });
  }

  final _logger = taggedLogger(tag: 'SV:PNManager');
  final CoordinatorClient _client;
  final CallNotificationWrapper _callNotification;
  final SharedPreferences _sharedPreferences;
  final StreamVideoPushNotificationMethodChannel _methodChannel;
  final StreamVideoPushNotificationEventChannel _eventChannel;

  @override
  Future<void> onUserLoggedIn() async {
    if (Platform.isAndroid) {
      _registerAndroidDevice();
    } else if (Platform.isIOS) {
      _registerIOSDevice();
    }
  }

  Future<void> _registerAndroidDevice() async {
    if (_isFirebaseInitialized()) {
      FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        _logger.d(() => '[registerAndroidDevice] refreshedToken: $token');
        await _registerFirebaseToken(token);
      });
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        _logger.d(() => '[registerAndroidDevice] token: $token');
        await _registerFirebaseToken(token);
      } else {
        _logger.w(() => '[registerAndroidDevice] Firebase Token was null');
      }
    }
  }

  Future<void> _registerIOSDevice() async {
    final token = await _methodChannel.getDevicePushTokenVoIP();
    _logger.d(() => '[registerIOSDevice] token: $token');
    if (token != null) {
      await _client.createDevice(
        id: token,
        voipToken: true,
        pushProvider: CreateDeviceRequestPushProviderEnum.apn,
        pushProviderName: 'flutter-apn-video',
      );
    }
  }

  Future<void> _registerFirebaseToken(String token) async {
    await _client.createDevice(
      id: token,
      pushProvider: CreateDeviceRequestPushProviderEnum.firebase,
      pushProviderName: 'firebase',
    );
  }

  Future<bool> _showCall(String cid) async {
    final streamCallCid = StreamCallCid(cid: cid);
    final call = await _from(streamCallCid);
    if (call != null) {
      await _callNotification.showCallNotification(
        streamCallCid: streamCallCid,
        callers: call.metadata.users.values.map((e) => e.name).join(', '),
        isVideoCall: true,
        avatarUrl: call.metadata.users.values.firstOrNull?.image,
        onCallAccepted: _acceptCall,
        onCallRejected: _rejectCall,
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> handlePushNotification(Map<String, dynamic> payload) async {
    if (_isValid(payload)) {
      return await _showCall(payload['call_cid'] as String);
    }
    return false;
  }

  Future<void> _acceptCall(StreamCallCid streamCallCid) async {
    await _sharedPreferences.setString('incomingCallCid', streamCallCid.value);
    await _client.acceptCall(cid: streamCallCid);
  }

  Future<void> _rejectCall(StreamCallCid streamCallCid) async {
    await _client.rejectCall(cid: streamCallCid);
  }

  bool _isValid(Map<String, dynamic> payload) {
    return _isFromStreamServer(payload) && _isValidIncomingCall(payload);
  }

  bool _isFromStreamServer(Map<String, dynamic> payload) {
    return payload['sender'] == 'stream.video';
  }

  bool _isValidIncomingCall(Map<String, dynamic> payload) {
    return payload['type'] == 'call.ring' &&
        ((payload['call_cid'] as String?)?.isNotEmpty ?? false);
  }

  bool _isFirebaseInitialized() {
    return Firebase.apps.isNotEmpty;
  }

  Future<CallCreatedData?> _from(StreamCallCid streamCallCid) async {
    SharedPrefsHelper prefs = SharedPrefsHelper(init: false);
    await prefs.initPrefs();
    var user = prefs.getSavedUser();

    await StreamVideo.instance.connectUserWithProvider(
      user,
      tokenProvider: TokenProvider.dynamic(
        (userId) {
          return TokenService()
              .loadToken(apiKey: StreamVideo.instance.apiKey, userId: userId);
        },
      ),
      saveUser: false,
    );
    var callData = (await _client.getOrCreateCall(callCid: streamCallCid))
        .getDataOrNull()
        ?.data;

    // TODO(Deven): Explore why this does not work
    // await StreamVideo.instance.disconnectUser();
    // await StreamVideo.reset(disconnectUser: true);

    return callData;
  }

  @override
  Future<CallCreatedData?> consumeIncomingCall() async {
    var incomingCid = '';

    var calls = await FlutterCallkitIncoming.activeCalls();

    if (Platform.isIOS) {
      if (calls is List && calls.isNotEmpty) {
        incomingCid = calls[0]['extra']['incomingCallCid'];
      }
    } else if (Platform.isAndroid) {
      // TODO(Deven): Use the same approach from iOS for incoming Android calls
      // We need to wait for a second to be sure sharedPreferences has been updated
      await _sharedPreferences.reload();
      incomingCid = _sharedPreferences.getString('incomingCallCid') ?? '';
      await _sharedPreferences.remove('incomingCallCid');
    }

    if (incomingCid != '') {
      return _from(StreamCallCid(cid: incomingCid));
    }
    return Future.value();
  }

  @override
  Future<void> endAllCalls() async {
    await FlutterCallkitIncoming.endAllCalls();
  }

  static PushNotificationManagerFactory factory({
    SharedPreferences? sharedPreferences,
    CallNotificationWrapper? callNotification,
    StreamVideoPushNotificationMethodChannel? methodChannel,
    StreamVideoPushNotificationEventChannel? eventChannel,
  }) {
    return (client) async {
      return StreamVideoPushNotificationManager._create(
        client: client,
        sharedPreferences:
            sharedPreferences ?? await SharedPreferences.getInstance(),
        callNotification: callNotification ?? const CallNotificationWrapper(),
        methodChannel:
            methodChannel ?? const StreamVideoPushNotificationMethodChannel(),
        eventChannel:
            eventChannel ?? const StreamVideoPushNotificationEventChannel(),
      );
    };
  }
}
