import 'package:stream_video/stream_video.dart';

import 'manager/push_token_source.dart';

/// Signature for a function that creates a [Stream] of push tokens.
typedef TokenStreamProvider = Stream<String> Function();

/// A push provider configured in the Stream dashboard, and the device tokens
/// to register with it.
final class StreamVideoPushProvider {
  /// Creates a new push provider.
  const StreamVideoPushProvider({
    required this.name,
    required this.type,
    required this.isVoIP,
    required this._tokenStreamProvider,
  });

  /// Creates a new push provider for APN.
  ///
  /// Registers the device's PushKit VoIP token by default.
  const StreamVideoPushProvider.apn({
    required this.name,
    this._tokenStreamProvider = _voIPTokens,
  }) : isVoIP = true,
       type = PushProvider.apn;

  /// Creates a new push provider for Firebase.
  ///
  /// Registers the device's Firebase Cloud Messaging token by default.
  const StreamVideoPushProvider.firebase({
    required this.name,
    this._tokenStreamProvider = _fcmTokens,
  }) : isVoIP = false,
       type = PushProvider.firebase;

  static Stream<String> _voIPTokens() => const VoIPTokenSource().tokens;

  static Stream<String> _fcmTokens() => const FcmTokenSource().tokens;

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
