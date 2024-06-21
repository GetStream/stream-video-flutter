part of 'stream_video_push_notification.dart';

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
        type = PushProvider.firebase;

  static Stream<String> _firebaseTokenStreamProvider() async* {
    final initialToken = await StreamTokenProvider.getFirebaseToken();
    if (initialToken != null) yield initialToken;

    yield* StreamTokenProvider.onFirebaseTokenRefresh;
  }

  /// Creates a new push provider for APN.
  const StreamVideoPushProvider.apn({
    required this.name,
    TokenStreamProvider tokenStreamProvider = _voIPTokenStreamProvider,
  })  : isVoIP = true,
        _tokenStreamProvider = tokenStreamProvider,
        type = PushProvider.apn;

  static Stream<String> _voIPTokenStreamProvider() async* {
    final initialToken = await StreamTokenProvider.getVoIPToken();
    if (initialToken != null) yield initialToken;

    yield* StreamTokenProvider.onVoIPTokenRefresh;
  }

  /// The name of the push provider.
  final String name;

  /// True if the push provider is for VoIP.
  final bool isVoIP;

  /// The push provider type.
  final PushProvider type;

  /// Emits the current push token for the device and emits a new token
  /// whenever the token is refreshed.
  Stream<String> get onTokenRefresh => _tokenStreamProvider();

  final TokenStreamProvider _tokenStreamProvider;
}

/// Provides push tokens for the device.
final class StreamTokenProvider {
  /// Gets the current push token for the device.
  static Future<String?> getVoIPToken() async {
    if (!CurrentPlatform.isIos) return null;

    final token = await FlutterCallkitIncoming.getDevicePushTokenVoIP();
    if (token is! String || token.isEmpty) return null;

    return token;
  }

  /// Emits a new push token whenever the token is refreshed.
  static Stream<String> get onVoIPTokenRefresh {
    if (!CurrentPlatform.isIos) return const Stream.empty();

    return StreamCallKit().onEvent.where((it) {
      return it.event == Event.actionDidUpdateDevicePushTokenVoip;
    }).map((event) => event.body['deviceTokenVoIP']);
  }

  static Future<String?> getAPNToken() async {
    if (!CurrentPlatform.isIos) return null;

    final token = await FirebaseMessaging.instance.getAPNSToken();
    if (token is! String || token.isEmpty) return null;

    return token;
  }

  /// Gets the current push token for the device.
  static Future<String?> getFirebaseToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null || token.isEmpty) return null;

    return token;
  }

  /// Emits a new push token whenever the token is refreshed.
  static Stream<String> get onFirebaseTokenRefresh =>
      FirebaseMessaging.instance.onTokenRefresh;
}
