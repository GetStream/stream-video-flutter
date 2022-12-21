import 'package:stream_video/src/models/closed_caption.dart';
import 'package:stream_video/src/participant/local.dart';
import 'package:stream_video/src/participant/participant.dart';
import 'package:stream_video/src/participant/remote.dart';
import 'package:stream_video/src/publication/local.dart';
import 'package:stream_video/src/publication/remote.dart';
import 'package:stream_video/src/publication/track_publication.dart';
import 'package:stream_video/src/sfu-client/sfu_client.dart';
import 'package:stream_video/src/track/track.dart';
import 'package:stream_video/src/types/other.dart';

/// Base type for all StreamCallEvent events.
mixin StreamCallEvent {}

/// Base type for all [Call] events.
mixin CallEvent implements StreamCallEvent {}

/// Base type for all [Participant] events.
mixin ParticipantEvent implements StreamCallEvent {}

/// Base type for all [Track] events.
mixin TrackEvent implements StreamCallEvent {}

/// Base type for all [CoordinatorClient] events.
mixin CoordinatorEvent implements StreamCallEvent {}

/// Base type for all [SfuClient] events.
mixin SfuEvent implements StreamCallEvent {}

/// Model class for connection state updates.
class ConnectionStateUpdatedEvent with SfuEvent, CoordinatorEvent, CallEvent {
  /// Creates a new instance of [ConnectionStateUpdatedEvent].
  const ConnectionStateUpdatedEvent({
    required this.newState,
    required this.oldState,
    required this.didConnected,
  });

  /// The new connection state.
  final ConnectionState newState;

  /// The old connection state.
  final ConnectionState oldState;

  /// Whether the connection state changed to [ConnectionState.connected].
  final bool didConnected;
}

/// When a new [RemoteParticipant] joins *after* the current participant has connected
/// It will not fire for participants that are already in the call
/// Emitted by [Call].
class ParticipantJoinedEvent with CallEvent {
  final RemoteParticipant participant;

  const ParticipantJoinedEvent({
    required this.participant,
  });

  @override
  String toString() => '${runtimeType}(participant: ${participant})';
}

class ClosedCaptionEvent with CallEvent {
  final ClosedCaption closedCaption;

  const ClosedCaptionEvent({
    required this.closedCaption,
  });

  @override
  String toString() => '${runtimeType}(closedCaption: ${closedCaption})';
}

/// When a [RemoteParticipant] leaves the call.
/// Emitted by [Call].
class ParticipantLeftEvent with CallEvent {
  final RemoteParticipant participant;

  const ParticipantLeftEvent({
    required this.participant,
  });

  @override
  String toString() => '${runtimeType}(participant: ${participant})';
}

/// When a [RemoteParticipant] or [LocalParticipant] becomes the loudest speaker
/// in the call.
class DominantSpeakerChangedEvent with CallEvent {
  final Participant speaker;

  const DominantSpeakerChangedEvent({
    required this.speaker,
  });

  @override
  String toString() => '${runtimeType}(speaker: ${speaker})';
}

/// When a new [Track] is published to [Call] *after* the current participant has
/// joined. It will not fire for tracks that are already published.
/// Emitted by [Call] and [RemoteParticipant].
class TrackPublishedEvent with CallEvent, ParticipantEvent {
  final RemoteParticipant participant;
  final RemoteTrackPublication publication;

  const TrackPublishedEvent({
    required this.participant,
    required this.publication,
  });

  @override
  String toString() => '${runtimeType}'
      '(participant: ${participant}, publication: ${publication})';
}

/// The participant has unpublished one of their [Track].
/// Emitted by [Call] and [RemoteParticipant].
class TrackUnpublishedEvent with CallEvent, ParticipantEvent {
  final RemoteParticipant participant;
  final RemoteTrackPublication publication;

  const TrackUnpublishedEvent({
    required this.participant,
    required this.publication,
  });

  @override
  String toString() => '${runtimeType}'
      '(participant: ${participant}, publication: ${publication})';
}

/// When the local participant publishes a new [Track] to the Call.
/// Emitted by [Call] and [LocalParticipant].
class LocalTrackPublishedEvent with CallEvent, ParticipantEvent {
  final LocalParticipant participant;
  final LocalTrackPublication publication;

  const LocalTrackPublishedEvent({
    required this.participant,
    required this.publication,
  });

  @override
  String toString() => '${runtimeType}'
      '(participant: ${participant}, publication: ${publication})';
}

/// The local participant has unpublished one of their [Track].
/// Emitted by [Call] and [LocalParticipant].
class LocalTrackUnpublishedEvent with CallEvent, ParticipantEvent {
  final LocalParticipant participant;
  final LocalTrackPublication publication;

  const LocalTrackUnpublishedEvent({
    required this.participant,
    required this.publication,
  });

  @override
  String toString() => '${runtimeType}'
      '(participant: ${participant}, publication: ${publication})';
}

/// [LocalParticipant] has subscribed to a new track published by a
/// [RemoteParticipant].
/// Emitted by [Call] and [RemoteParticipant].
class TrackSubscribedEvent with CallEvent, ParticipantEvent {
  final RemoteParticipant participant;
  final RemoteTrackPublication publication;
  final Track track;

  const TrackSubscribedEvent({
    required this.participant,
    required this.publication,
    required this.track,
  });

  @override
  String toString() => '${runtimeType}'
      '(participant: ${participant}, publication: ${publication}, '
      'track: ${track})';
}

/// An error has occured during track subscription.
/// Emitted by [Call] and [RemoteParticipant].
class TrackSubscriptionExceptionEvent with CallEvent, ParticipantEvent {
  final RemoteParticipant participant;
  final String? sid;
  final TrackSubscribeFailReason reason;

  const TrackSubscriptionExceptionEvent({
    required this.participant,
    this.sid,
    required this.reason,
  });
}

/// The [LocalParticipant] has unsubscribed from a track published by a
/// [RemoteParticipant]. This event is fired when the track was unpublished.
/// Emitted by [Call] and [RemoteParticipant].
class TrackUnsubscribedEvent with CallEvent, ParticipantEvent {
  final RemoteParticipant participant;
  final RemoteTrackPublication publication;
  final Track track;

  const TrackUnsubscribedEvent({
    required this.participant,
    required this.publication,
    required this.track,
  });

  @override
  String toString() => '${runtimeType}'
      '(participant: ${participant}, publication: ${publication}, '
      'track: ${track})';
}

/// A Participant has muted one of the track.
/// Emitted by [RemoteParticipant] and [LocalParticipant].
class TrackMutedEvent with CallEvent, ParticipantEvent {
  final Participant participant;
  final TrackPublication publication;

  const TrackMutedEvent({
    required this.participant,
    required this.publication,
  });

  @override
  String toString() => '${runtimeType}'
      '(participant: ${participant}, publication: ${publication})';

  @Deprecated('Use publication instead')
  TrackPublication get track => publication;
}

/// This participant has unmuted one of their tracks
/// Emitted by [RemoteParticipant] and [LocalParticipant].
class TrackUnmutedEvent with CallEvent, ParticipantEvent {
  final Participant participant;
  final TrackPublication publication;

  const TrackUnmutedEvent({
    required this.participant,
    required this.publication,
  });

  @override
  String toString() => '${runtimeType}'
      '(participant: ${participant}, publication: ${publication})';

  @Deprecated('Use publication instead')
  TrackPublication get track => publication;
}

/// Participant metadata is a simple way for app-specific state to be pushed to
/// all users. When CallService.UpdateParticipantMetadata is called to change a
/// [Participant]'s state, *all* [Participant]s in the Call will fire this event.
/// Emitted by [Call] and [Participant].
class ParticipantInfoUpdatedEvent with CallEvent, ParticipantEvent {
  final Participant participant;

  const ParticipantInfoUpdatedEvent({
    required this.participant,
  });

  @override
  String toString() => '${runtimeType}(participant: ${participant})';
}

/// [Participant]'s [ConnectionQuality] has updated.
/// Emitted by [Call] and [Participant].
class ParticipantConnectionQualityUpdatedEvent
    with CallEvent, ParticipantEvent {
  final Participant participant;
  final ConnectionQuality connectionQuality;

  const ParticipantConnectionQualityUpdatedEvent({
    required this.participant,
    required this.connectionQuality,
  });

  @override
  String toString() => '${runtimeType}'
      '(participant: ${participant}, connectionQuality: ${connectionQuality})';
}

/// The participant's isSpeaking property has changed
/// Emitted by [Participant].
class SpeakingChangedEvent with ParticipantEvent {
  final Participant participant;
  final bool speaking;

  const SpeakingChangedEvent({
    required this.participant,
    required this.speaking,
  });

  @override
  String toString() => '${runtimeType}'
      '(participant: ${participant}, speaking: ${speaking})';
}
