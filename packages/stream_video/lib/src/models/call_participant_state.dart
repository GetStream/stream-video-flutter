import 'package:stream_video/src/models/user_info.dart';

/// Represents call participant state.
class CallParticipantState {
  /// Creates a new instance of [CallParticipantState].
  const CallParticipantState({
    required this.user,
    required this.self,
    required this.audioAvailable,
    required this.videoAvailable,
  });

  /// Represents user info.
  final UserInfo user;

  /// Whether this is the local participant.
  final bool self;

  /// Whether the audio is available.
  final bool audioAvailable;

  /// Whether the video is available.
  final bool videoAvailable;
}
