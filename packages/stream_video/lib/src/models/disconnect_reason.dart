import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../errors/video_error.dart';

@immutable
abstract class DisconnectReason extends Equatable {
  const DisconnectReason();

  const factory DisconnectReason.timeout() = DisconnectReasonTimeout;

  const factory DisconnectReason.failure(
      VideoError error) = DisconnectReasonFailure;

  const factory DisconnectReason.rejected({
    required String byUserId,
  }) = DisconnectReasonRejected;

  const factory DisconnectReason.cancelled({
    required String byUserId,
  }) = DisconnectReasonCancelled;

  factory DisconnectReason.ended() {
    return DisconnectReasonEnded();
  }

  factory DisconnectReason.lastParticipantLeft() {
    return DisconnectReasonLastParticipantLeft();
  }

  @override
  List<Object?> get props => [];
}

class DisconnectReasonTimeout extends DisconnectReason {
  const DisconnectReasonTimeout();

  @override
  String toString() {
    return 'Timeout';
  }
}

class DisconnectReasonFailure extends DisconnectReason {
  const DisconnectReasonFailure(this.error);

  final VideoError error;

  @override
  List<Object?> get props => [error];

  @override
  String toString() {
    return 'Failure{error: $error}';
  }
}

class DisconnectReasonRejected extends DisconnectReason {
  const DisconnectReasonRejected({
    required this.byUserId,
  });

  final String byUserId;

  @override
  List<Object?> get props => [byUserId];

  @override
  String toString() {
    return 'Rejected{byUserId: $byUserId}';
  }
}

class DisconnectReasonCancelled extends DisconnectReason {
  const DisconnectReasonCancelled({
    required this.byUserId,
  });

  final String byUserId;

  @override
  List<Object?> get props => [byUserId];

  @override
  String toString() {
    return 'Cancelled{byUserId: $byUserId}';
  }
}

class DisconnectReasonEnded extends DisconnectReason {
  factory DisconnectReasonEnded() {
    return _instance;
  }

  const DisconnectReasonEnded._internal();

  static const DisconnectReasonEnded _instance =
  DisconnectReasonEnded._internal();

  @override
  String toString() {
    return 'Ended';
  }
}

class DisconnectReasonLastParticipantLeft extends DisconnectReason {
  factory DisconnectReasonLastParticipantLeft() {
    return _instance;
  }

  const DisconnectReasonLastParticipantLeft._internal();

  static const DisconnectReasonLastParticipantLeft _instance =
  DisconnectReasonLastParticipantLeft._internal();

  @override
  String toString() {
    return 'LastParticipantLeft';
  }
}

class DisconnectReasonManuallyClosed extends DisconnectReason {
  factory DisconnectReasonManuallyClosed() {
    return _instance;
  }

  const DisconnectReasonManuallyClosed._internal();

  static const DisconnectReasonManuallyClosed _instance =
  DisconnectReasonManuallyClosed._internal();

  @override
  String toString() {
    return 'ManuallyClosed';
  }
}
