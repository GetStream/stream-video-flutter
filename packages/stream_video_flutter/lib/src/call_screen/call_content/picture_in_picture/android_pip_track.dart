import '../../../../stream_video_flutter.dart';

/// The participant and video track that [AndroidPipOverlay] shows by default:
/// the first of [sortedParticipants], with its screen share when [priority]
/// allows it or its camera is off, and its camera otherwise.
///
/// Returns null when there are no participants.
({CallParticipantState participant, SfuTrackTypeVideo trackType})?
resolveAndroidPipTrack(
  List<CallParticipantState> sortedParticipants,
  PipTrackPriority? priority,
) {
  final participant = sortedParticipants.firstOrNull;
  if (participant == null) return null;

  final hasScreenShare =
      participant.isScreenShareEnabled && participant.screenShareTrack != null;

  // Show screen share if:
  // 1. prioritise is true and screen share is available, OR
  // 2. video is disabled but screen share is available (fallback)
  final shouldShowScreenShare =
      hasScreenShare &&
      (priority != PipTrackPriority.camera || !participant.isVideoEnabled);

  return (
    participant: participant,
    trackType: shouldShowScreenShare
        ? SfuTrackType.screenShare
        : SfuTrackType.video,
  );
}
