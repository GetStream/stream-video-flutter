import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/stream_video.dart';

/// Signature for a function that creates a [Stream] of push tokens.
typedef TokenStreamProvider = Stream<String> Function();

final class StreamVideoPushProvider {
  /// Creates a new push provider.
  const StreamVideoPushProvider({
    required this.name,
    required this.type,
    required this.isVoIP,
    required TokenStreamProvider tokenStreamProvider,
  }) : _tokenStreamProvider = tokenStreamProvider;

  /// Creates a new push provider for Firebase.
  const StreamVideoPushProvider.firebase({
    required this.name,
    TokenStreamProvider tokenStreamProvider = _firebaseTokenStreamProvider,
  })  : isVoIP = false,
        _tokenStreamProvider = tokenStreamProvider,
        type = CreateDeviceRequestPushProviderEnum.firebase;

  static Stream<String> _firebaseTokenStreamProvider() async* {
    final initialToken = await StreamTokenProvider.getFirebaseToken();
    if (initialToken != null) yield initialToken;

    yield* StreamTokenProvider.onFirebaseTokenRefresh;
  }

  /// Creates a new push provider for APN.
  const StreamVideoPushProvider.apn({
    required this.name,
    TokenStreamProvider tokenStreamProvider = _apnTokenStreamProvider,
  })  : isVoIP = true,
        _tokenStreamProvider = tokenStreamProvider,
        type = CreateDeviceRequestPushProviderEnum.apn;

  static Stream<String> _apnTokenStreamProvider() async* {
    final initialToken = await StreamTokenProvider.getAPNsToken();
    if (initialToken != null) yield initialToken;

    yield* StreamTokenProvider.onAPNsTokenRefresh;
  }

  /// The name of the push provider.
  final String name;

  /// True if the push provider is for VoIP.
  final bool isVoIP;

  /// The push provider type.
  final CreateDeviceRequestPushProviderEnum type;

  /// Emits the current push token for the device and emits a new token
  /// whenever the token is refreshed.
  Stream<String> get onTokenRefresh => _tokenStreamProvider();

  final TokenStreamProvider _tokenStreamProvider;
}

@internal
final class StreamTokenProvider {
  static Future<String?> getAPNsToken() async {
    if (!CurrentPlatform.isIos) return null;

    final token = await FlutterCallkitIncoming.getDevicePushTokenVoIP();
    if (token is! String || token.isEmpty) return null;

    return token;
  }

  static Stream<String> get onAPNsTokenRefresh {
    if (!CurrentPlatform.isIos) return const Stream.empty();

    return FlutterCallkitIncoming.onEvent.whereType().where((it) {
      return it.event == Event.actionDidUpdateDevicePushTokenVoip;
    }).map((data) => data['deviceTokenVoIP']);
  }

  static Future<String?> getFirebaseToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null || token.isEmpty) return null;

    return token;
  }

  static Stream<String> get onFirebaseTokenRefresh =>
      FirebaseMessaging.instance.onTokenRefresh;
}
