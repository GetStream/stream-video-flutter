import '../webrtc/e2ee/call_encryption_key.dart';
import 'audio_configuration_policy.dart';
import 'call_client_publish_options.dart';
import 'moderation_blur_config.dart';

abstract class CallPreferences {
  /// The maximum duration to wait when establishing a connection to the call.
  ///
  /// If the connection is not established within this timeout, the connection
  /// attempt will be cancelled.
  Duration get connectTimeout;

  /// The maximum duration to wait when reconnecting to the call.
  ///
  /// If the connection is not established within this timeout, the reconnection
  /// attempt will be cancelled. And the user will disconnect from the call.
  Duration get reconnectTimeout;

  /// The maximum duration to wait for network availability before timing out.
  ///
  /// If the network is not available within this timeout, the call will be
  /// considered disconnected
  Duration get networkAvailabilityTimeout;

  /// The duration after which call reactions (like emoji reactions)
  /// automatically disappear from the UI.
  Duration get reactionAutoDismissTime;

  /// The interval at which call statistics are reported and updated.
  ///
  /// This controls how frequently metrics like bandwidth, latency, and
  /// quality statistics are collected and reported.
  Duration get callStatsReportingInterval;

  /// Whether to automatically drop the call if the user is alone
  /// in the ringing flow.
  ///
  /// When true, if all participants leave the call initiated by ringing,
  /// the call will be automatically ended.
  bool get dropIfAloneInRingingFlow;

  /// Configuration options for client-side publishing settings.
  ///
  /// Manually setting preferred codec can cause call stability/compatibility issues.
  /// Use with caution.
  ClientPublishOptions? get clientPublishOptions;

  /// The duration in milliseconds that closed captions remain visible
  /// on screen before being automatically hidden.
  int get closedCaptionsVisibilityDurationMs;

  /// The maximum number of closed caption lines that can be visible
  /// simultaneously on screen.
  int get closedCaptionsVisibleCaptions;

  /// Configuration for how the SDK handles call moderation events.
  /// Defaults to [VideoModerationConfig.disabled].
  VideoModerationConfig get videoModerationConfig;

  /// Per-call audio configuration override. When non-null, the per-call
  /// native peer-connection factory is built with this policy instead of
  /// the client-level default `StreamVideoOptions.audioConfigurationPolicy`.
  AudioConfigurationPolicy? get audioConfigurationPolicy;

  /// Supplies the shared key for this call when no `EncryptionManager` has been
  /// attached to it by hand.
  ///
  /// Mostly for the ringing flow, which is where the SDK, not the app, decides
  /// when the join happens. Answering a call from a notification, or after the
  /// process was killed, leaves nowhere to attach a manager and nobody to ask
  /// for a key — so pass it in with the preferences the accept already carries:
  ///
  /// ```dart
  /// streamVideo.observeCoreRingingEvents(
  ///   acceptCallPreferences: DefaultCallPreferences(
  ///     encryptionKeyResolver: myResolver,
  ///   ),
  /// );
  /// ```
  ///
  /// Set it on `StreamVideoOptions.defaultCallPreferences` to cover every call
  /// instead, or on a single `makeCall`. A manager attached with
  /// `setE2EEManager` always wins, and the resolver is not called at all.
  CallEncryptionKeyResolver? get encryptionKeyResolver;
}

class DefaultCallPreferences implements CallPreferences {
  DefaultCallPreferences({
    this.connectTimeout = const Duration(seconds: 60),
    this.reconnectTimeout = Duration.zero,
    this.networkAvailabilityTimeout = const Duration(minutes: 5),
    this.reactionAutoDismissTime = const Duration(seconds: 5),
    this.callStatsReportingInterval = const Duration(seconds: 2),
    this.dropIfAloneInRingingFlow = true,
    this.clientPublishOptions,
    this.closedCaptionsVisibilityDurationMs = 2700,
    this.closedCaptionsVisibleCaptions = 2,
    this.videoModerationConfig = const VideoModerationConfig.disabled(),
    this.audioConfigurationPolicy,
    this.encryptionKeyResolver,
  });

  /// The maximum duration to wait when establishing a connection to the call.
  ///
  /// If the connection is not established within this timeout, the connection
  /// attempt will be cancelled.
  ///
  /// Defaults to 60 seconds.
  @override
  final Duration connectTimeout;

  /// The maximum amount of time to wait when attempting to reconnect to the call.
  ///
  /// If reconnection is not successful within this period, the attempt will be aborted
  /// and the user will be disconnected from the call.
  ///
  /// Defaults to 0 seconds, which means reconnection attempts will continue indefinitely.
  @override
  final Duration reconnectTimeout;

  /// The maximum duration to wait for network availability before timing out.
  ///
  /// If the network is not available within this timeout, the call will be
  /// considered disconnected.
  ///
  /// Defaults to 5 minutes.
  @override
  final Duration networkAvailabilityTimeout;

  /// The duration after which call reactions (like emoji reactions)
  /// automatically disappear from the UI.
  ///
  /// Defaults to 5 seconds.
  @override
  final Duration reactionAutoDismissTime;

  /// The interval at which call statistics are reported and updated.
  ///
  /// This controls how frequently metrics like bandwidth, latency, and
  /// quality statistics are collected and reported.
  ///
  /// Defaults to 2 seconds.
  @override
  final Duration callStatsReportingInterval;

  /// Whether to automatically drop the call if the user is alone
  /// in the ringing flow.
  ///
  /// When true, if all participants leave the call initiated by ringing,
  /// the call will be automatically ended.
  ///
  /// Defaults to true.
  @override
  final bool dropIfAloneInRingingFlow;

  /// Configuration options for client-side publishing settings.
  ///
  /// Manually setting preferred codec can cause call stability/compatibility issues.
  /// Use with caution.
  @override
  final ClientPublishOptions? clientPublishOptions;

  /// The duration in milliseconds that closed captions remain visible
  /// on screen before being automatically hidden.
  ///
  /// Defaults to 2700ms (2.7 seconds).
  @override
  final int closedCaptionsVisibilityDurationMs;

  /// The maximum number of closed caption lines that can be visible
  /// simultaneously on screen.
  ///
  /// Defaults to 2 lines.
  @override
  final int closedCaptionsVisibleCaptions;

  /// Configuration for how the SDK handles call moderation events.
  ///
  /// Defaults to [VideoModerationConfig.disabled].
  @override
  final VideoModerationConfig videoModerationConfig;

  /// Per-call audio configuration override. When non-null, the per-call
  /// native peer-connection factory is built with this policy instead of
  /// the client-level default `StreamVideoOptions.audioConfigurationPolicy`.
  ///
  /// Defaults to null (falls back to `StreamVideoOptions.audioConfigurationPolicy`).
  @override
  final AudioConfigurationPolicy? audioConfigurationPolicy;

  /// Supplies the shared key for this call when no manager was attached by
  /// hand. See [CallPreferences.encryptionKeyResolver].
  @override
  final CallEncryptionKeyResolver? encryptionKeyResolver;
}
