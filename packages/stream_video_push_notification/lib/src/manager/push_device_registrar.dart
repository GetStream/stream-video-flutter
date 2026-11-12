import 'dart:async';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_video/stream_video.dart';

import '../stream_video_push_provider.dart';
import 'push_token_source.dart';

/// Registers this device's push tokens with the Stream backend and removes
/// them again, remembering what it registered so a token is sent once.
///
/// The push provider is picked per platform from the two the app configured;
/// its token stream drives registration. On iOS the APNs token is registered
/// as well when the app asked for it, for missed-call pushes. Everything
/// here waits for the shared preferences it caches tokens in, so it can be
/// called straight after construction.
@internal
class PushDeviceRegistrar {
  PushDeviceRegistrar({
    required this._client,
    required this._iosPushProvider,
    required this._androidPushProvider,
    required this._registerApnDeviceToken,
    required this._currentDeviceToken,
    this._apnsTokenSource = const ApnsTokenSource(),
    Future<SharedPreferences>? preferences,
  }) : _preferencesOverride = preferences;

  /// Preferences key of the last APNs token registered.
  static const userDeviceTokenKey = 'io.getstream.userDeviceToken';

  /// Preferences key of the last provider token registered (VoIP on iOS,
  /// Firebase on Android).
  static const userDeviceTokenVoIPKey = 'io.getstream.userDeviceTokenVoIP';

  final CoordinatorClient _client;
  final StreamVideoPushProvider _iosPushProvider;
  final StreamVideoPushProvider _androidPushProvider;
  final bool _registerApnDeviceToken;

  /// The token [unregisterDevice] deletes first: the one the platform's
  /// provider registered the device with.
  final Future<String?> Function() _currentDeviceToken;
  final PushTokenSource _apnsTokenSource;
  final Future<SharedPreferences>? _preferencesOverride;

  /// Loaded on first use, so building a registrar touches no platform
  /// channel.
  late final Future<SharedPreferences> _preferences =
      _preferencesOverride ?? SharedPreferences.getInstance();

  final _logger = taggedLogger(tag: 'SV:PNRegistrar');

  StreamSubscription<String>? _tokenSubscription;

  /// How many times the device was unregistered. A registration that started
  /// before an unregister neither registers nor remembers its token.
  int _unregistrations = 0;

  /// Whether the APNs token is registered next to the provider's token.
  bool get _registersApnsToken =>
      CurrentPlatform.isIos && _registerApnDeviceToken;

  /// Starts registering the device: the APNs token once, when asked for, and
  /// the provider's token now and on every refresh.
  void registerDevice() {
    final pushProvider = switch (CurrentPlatform.type) {
      PlatformType.ios => _iosPushProvider,
      PlatformType.android => _androidPushProvider,
      _ => null,
    };

    if (pushProvider == null) {
      _logger.w(() => 'Cannot register device: unsupported platform');
      return;
    }

    if (_registersApnsToken) {
      final unregistrations = _unregistrations;
      _apnsTokenSource.token().then(
        (token) {
          if (token != null) {
            _register(
              token,
              pushProvider,
              isVoIP: false,
              unregistrations: unregistrations,
            );
          }
        },
        onError: (Object error) {
          _logger.e(() => 'Reading the APNs token failed: $error');
        },
      );
    }

    if (_tokenSubscription != null) return;
    late final StreamSubscription<String> subscription;
    subscription = pushProvider.onTokenRefresh.listen(
      (token) => _register(
        token,
        pushProvider,
        isVoIP: true,
        unregistrations: _unregistrations,
      ),
      onError: (Object error) {
        _logger.e(() => 'Reading the push token failed: $error');
      },
      // A stream that ended, after an error too, is subscribed to again by
      // the next registration.
      onDone: () {
        if (identical(_tokenSubscription, subscription)) {
          _tokenSubscription = null;
        }
      },
    );
    _tokenSubscription = subscription;
  }

  /// Registers [token] with [pushProvider] unless it is the token registered
  /// last, and remembers it on success. Does nothing once the device was
  /// unregistered after [unregistrations] was read.
  Future<void> _register(
    String token,
    StreamVideoPushProvider pushProvider, {
    required bool isVoIP,
    required int unregistrations,
  }) async {
    final tokenKey = isVoIP ? userDeviceTokenVoIPKey : userDeviceTokenKey;

    final preferences = await _preferences;
    final storedToken = preferences.getString(tokenKey);
    if (storedToken == token || unregistrations != _unregistrations) return;

    final result = await _client.createDevice(
      id: token,
      voipToken: isVoIP,
      pushProvider: pushProvider.type,
      pushProviderName: pushProvider.name,
    );
    if (unregistrations != _unregistrations) return;
    if (result is Success) {
      await preferences.setString(tokenKey, token);
    } else {
      _logger.w(() => 'Registering the push token failed: $result');
    }
  }

  /// Stops registering, deletes the device's tokens from the backend and
  /// forgets them.
  Future<void> unregisterDevice() async {
    _stopTokenRefreshes();
    _unregistrations++;

    String? token;
    try {
      token = await _currentDeviceToken();
    } catch (error) {
      _logger.w(() => 'Reading the push token to delete failed: $error');
    }

    final preferences = await _preferences;

    // The current provider token and the one stored on a successful
    // registration, which is all that is left when the current one cannot be
    // read.
    final providerTokens = {
      ?token,
      ?preferences.getString(userDeviceTokenVoIPKey),
    };
    for (final providerToken in providerTokens) {
      await _client.deleteDevice(id: providerToken);
    }

    // The APN token stored on a successful registration, which also covers
    // tokens registered before `registerApnDeviceToken` was disabled, plus
    // the current one if APN registration is enabled.
    final apnTokens = {
      ?preferences.getString(userDeviceTokenKey),
      if (_registersApnsToken) ?await _currentApnsToken(),
    };
    for (final apnToken in apnTokens) {
      await _client.deleteDevice(id: apnToken);
    }

    await removeStoredTokens();
  }

  /// The current APNs token, or null when it cannot be read.
  Future<String?> _currentApnsToken() async {
    try {
      return await _apnsTokenSource.token();
    } catch (error) {
      _logger.w(() => 'Reading the APNs token to delete failed: $error');
      return null;
    }
  }

  /// Forgets the tokens registered so far, so the next registration sends
  /// them again.
  Future<void> removeStoredTokens() async {
    final preferences = await _preferences;
    await preferences.remove(userDeviceTokenKey);
    await preferences.remove(userDeviceTokenVoIPKey);
  }

  /// Stops listening for token refreshes.
  Future<void> dispose() async {
    _stopTokenRefreshes();
  }

  /// Cancels the token subscription without waiting for the cancel to
  /// complete.
  void _stopTokenRefreshes() {
    final subscription = _tokenSubscription;
    _tokenSubscription = null;
    unawaited(
      subscription?.cancel().onError<Object>(
        (error, _) =>
            _logger.w(() => 'Stopping the token refreshes failed: $error'),
      ),
    );
  }
}
