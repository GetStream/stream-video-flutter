// 📦 Package imports:
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// Whether [preferences] select the HiFi audio policy.
bool isHiFiAudioPolicy(CallPreferences preferences) =>
    preferences.audioConfigurationPolicy is HiFiAudioPolicy;

/// [preferences] with the audio policy set to HiFi, or cleared back to the
/// client default when [enabled] is false. Every other preference is kept.
CallPreferences withHiFiAudioPolicy(
  CallPreferences preferences, {
  required bool enabled,
}) {
  return DefaultCallPreferences(
    connectTimeout: preferences.connectTimeout,
    reconnectTimeout: preferences.reconnectTimeout,
    networkAvailabilityTimeout: preferences.networkAvailabilityTimeout,
    reactionAutoDismissTime: preferences.reactionAutoDismissTime,
    callStatsReportingInterval: preferences.callStatsReportingInterval,
    dropIfAloneInRingingFlow: preferences.dropIfAloneInRingingFlow,
    clientPublishOptions: preferences.clientPublishOptions,
    closedCaptionsVisibilityDurationMs:
        preferences.closedCaptionsVisibilityDurationMs,
    closedCaptionsVisibleCaptions: preferences.closedCaptionsVisibleCaptions,
    videoModerationConfig: preferences.videoModerationConfig,
    audioConfigurationPolicy: enabled
        ? const AudioConfigurationPolicy.hiFi()
        : null,
    participantsThrottleIntervalResolver:
        preferences.participantsThrottleIntervalResolver,
    encryptionKeyResolver: preferences.encryptionKeyResolver,
  );
}

/// [audio] with HiFi audio allowed. Every other audio setting is kept, since
/// the update replaces the call's audio settings as a whole.
StreamAudioSettings withHiFiAudioEnabled(StreamAudioSettings audio) {
  return StreamAudioSettings(
    accessRequestEnabled: audio.accessRequestEnabled,
    opusDtxEnabled: audio.opusDtxEnabled,
    redundantCodingEnabled: audio.redundantCodingEnabled,
    defaultDevice: audio.defaultDevice,
    micDefaultOn: audio.micDefaultOn,
    speakerDefaultOn: audio.speakerDefaultOn,
    noiseCancellation: audio.noiseCancellation,
    hifiAudioEnabled: true,
  );
}
