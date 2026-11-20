import '../webrtc/e2ee/call_encryption_key.dart';
import 'audio_configuration_policy.dart';
import 'call_client_publish_options.dart';
import 'moderation_blur_config.dart';
import 'participants_throttle.dart';

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

  /// The number of reconnects for sessions in which ICE never connected at
  /// which the call concludes that the network cannot carry WebRTC. The
  /// reconnect that reaches it leaves the call with
  /// `DisconnectReasonUnsupportedNetwork` instead of reconnecting, so 2
  /// rejoins once and leaves on the next failure.
  ///
  /// ICE connecting on any peer connection starts the count again. Values
  /// below 1 count as 1.
  int get maxIceFailuresWithoutConnect;

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
  ///
  /// 0 or less keeps each caption until newer ones push it out.
  int get closedCaptionsVisibilityDurationMs;

  /// The maximum number of closed caption lines that can be visible
  /// simultaneously on screen.
  int get closedCaptionsVisibleCaptions;

  /// Configuration for how the SDK handles call moderation events.
  /// Defaults to [VideoModerationConfig.disabled].
  VideoModerationConfig get videoModerationConfig;

  /// Per-call audio configuration override. When non-null, the per-call
  /// native peer-connection factory is built with this policy instead of
  /// the client-level default: `StreamVideoOptions.ringingAudioConfigurationPolicy`
  /// for a ringing call, `StreamVideoOptions.audioConfigurationPolicy`
  /// otherwise.
  AudioConfigurationPolicy? get audioConfigurationPolicy;

  /// How long `Call.participantsStream` holds participant updates back, as a
  /// function of the participant count.
  ///
  /// A large call emits participant updates far faster than a screen can
  /// usefully repaint, so the default returns a longer interval the more
  /// participants there are. Return a shorter one to trade CPU for latency, or
  /// set this to `null` to emit every change.
  ///
  /// This does not affect `CallState.callParticipants`, which is always up to
  /// date. It is read once, the first time `Call.participantsStream` is used;
  /// changing it through `updateCallPreferences` after that has no effect for
  /// that call.
  ParticipantsThrottleIntervalResolver?
  get participantsThrottleIntervalResolver;

  /// Supplies the shared key for this call when no `EncryptionManager` has been
  /// attached to it by hand.
  ///
  /// Mostly for the ringing flow, which is where the SDK, not the app, decides
  /// when the join happens. Answering a call from a notification, or after the
  /// process was killed, leaves nowhere to attach a manager and nobody to ask
  /// for a key — so pass it in with the preferences the accept already carries:
  ///
  /// ```dart
  /// streamVideo.ringing.observeCoreRingingEvents(
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
    this.maxIceFailuresWithoutConnect = 2,
    this.reactionAutoDismissTime = const Duration(seconds: 5),
    this.callStatsReportingInterval = const Duration(seconds: 2),
    this.dropIfAloneInRingingFlow = true,
    this.clientPublishOptions,
    this.closedCaptionsVisibilityDurationMs = 2700,
    this.closedCaptionsVisibleCaptions = 2,
    this.videoModerationConfig = const VideoModerationConfig.disabled(),
    this.audioConfigurationPolicy,
    this.participantsThrottleIntervalResolver =
        defaultParticipantsThrottleInterval,
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

  /// The number of reconnects for sessions in which ICE never connected at
  /// which the call leaves with `DisconnectReasonUnsupportedNetwork`. See
  /// [CallPreferences.maxIceFailuresWithoutConnect].
  ///
  /// Defaults to 2.
  @override
  final int maxIceFailuresWithoutConnect;

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
  /// 0 or less keeps each caption until newer ones push it out.
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
  /// the client-level default: `StreamVideoOptions.ringingAudioConfigurationPolicy`
  /// for a ringing call, `StreamVideoOptions.audioConfigurationPolicy`
  /// otherwise.
  ///
  /// Defaults to null (falls back to the client-level default).
  @override
  final AudioConfigurationPolicy? audioConfigurationPolicy;

  /// How long `Call.participantsStream` holds participant updates back, as a
  /// function of the participant count. See
  /// [CallPreferences.participantsThrottleIntervalResolver].
  ///
  /// Defaults to [defaultParticipantsThrottleInterval].
  @override
  final ParticipantsThrottleIntervalResolver?
  participantsThrottleIntervalResolver;

  /// Supplies the shared key for this call when no manager was attached by
  /// hand. See [CallPreferences.encryptionKeyResolver].
  @override
  final CallEncryptionKeyResolver? encryptionKeyResolver;
}

/// Single-field changes to any [CallPreferences].
extension CallPreferencesAudioPolicy on CallPreferences {
  /// These preferences with [policy] as the audio configuration policy and
  /// every other value unchanged. Pass null to fall back to the client-level
  /// default: `StreamVideoOptions.ringingAudioConfigurationPolicy` for a
  /// ringing call, `StreamVideoOptions.audioConfigurationPolicy` otherwise.
  ///
  /// Works for any [CallPreferences] implementation. Changing the policy
  /// repeatedly does not nest copies, and setting it back to the original
  /// policy returns the original preferences.
  ///
  /// To apply it to a call before joining, prefer
  /// `Call.setAudioConfigurationPolicy`, which also checks the call's status.
  CallPreferences withAudioConfigurationPolicy(
    AudioConfigurationPolicy? policy,
  ) {
    final self = this;
    final base = self is _AudioPolicyCallPreferences ? self.base : self;
    if (policy == base.audioConfigurationPolicy) return base;

    return _AudioPolicyCallPreferences(
      base: base,
      audioConfigurationPolicy: policy,
    );
  }
}

/// [base] with its audio configuration policy replaced by
/// [audioConfigurationPolicy]; see
/// [CallPreferencesAudioPolicy.withAudioConfigurationPolicy].
///
/// It `implements` [CallPreferences], so adding a member to the interface
/// fails to compile until it is forwarded here too.
class _AudioPolicyCallPreferences implements CallPreferences {
  const _AudioPolicyCallPreferences({
    required this.base,
    required this.audioConfigurationPolicy,
  });

  final CallPreferences base;

  @override
  final AudioConfigurationPolicy? audioConfigurationPolicy;

  @override
  Duration get connectTimeout => base.connectTimeout;

  @override
  Duration get reconnectTimeout => base.reconnectTimeout;

  @override
  Duration get networkAvailabilityTimeout => base.networkAvailabilityTimeout;

  @override
  int get maxIceFailuresWithoutConnect => base.maxIceFailuresWithoutConnect;

  @override
  Duration get reactionAutoDismissTime => base.reactionAutoDismissTime;

  @override
  Duration get callStatsReportingInterval => base.callStatsReportingInterval;

  @override
  bool get dropIfAloneInRingingFlow => base.dropIfAloneInRingingFlow;

  @override
  ClientPublishOptions? get clientPublishOptions => base.clientPublishOptions;

  @override
  int get closedCaptionsVisibilityDurationMs =>
      base.closedCaptionsVisibilityDurationMs;

  @override
  int get closedCaptionsVisibleCaptions => base.closedCaptionsVisibleCaptions;

  @override
  VideoModerationConfig get videoModerationConfig => base.videoModerationConfig;

  @override
  ParticipantsThrottleIntervalResolver?
  get participantsThrottleIntervalResolver =>
      base.participantsThrottleIntervalResolver;

  @override
  CallEncryptionKeyResolver? get encryptionKeyResolver =>
      base.encryptionKeyResolver;

  @override
  String toString() =>
      'CallPreferences(audioConfigurationPolicy: $audioConfigurationPolicy, '
      'base: $base)';
}
