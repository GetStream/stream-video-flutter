import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../errors/video_error.dart';

@immutable
abstract class DisconnectReason extends Equatable {
  const DisconnectReason();

  factory DisconnectReason.timeout(Duration timeLimit) {
    return DisconnectReasonTimeout(timeLimit);
  }

  factory DisconnectReason.failure(VideoError error) {
    return DisconnectReasonFailure(error);
  }

  factory DisconnectReason.rejected({
    required String byUserId,
  }) {
    return DisconnectReasonRejected(byUserId: byUserId);
  }

  factory DisconnectReason.cancelled({
    required String byUserId,
  }) {
    return DisconnectReasonCancelled(byUserId: byUserId);
  }

  factory DisconnectReason.manuallyClosed() {
    return DisconnectReasonManuallyClosed();
  }

  factory DisconnectReason.ended() {
    return DisconnectReasonEnded();
  }

  @override
  List<Object?> get props => [];
}

class DisconnectReasonTimeout extends DisconnectReason {
  const DisconnectReasonTimeout(this.timeLimit);

  final Duration timeLimit;

  @override
  List<Object?> get props => [timeLimit];

  @override
  String toString() {
    return 'Timeout{timeLimit: $timeLimit}';
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
