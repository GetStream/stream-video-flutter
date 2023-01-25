import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../errors/video_error.dart';

@immutable
abstract class DropReason extends Equatable {
  const DropReason();

  factory DropReason.timeout(Duration timeLimit) {
    return DropReasonTimeout(timeLimit);
  }

  factory DropReason.failure(VideoError error) {
    return DropReasonFailure(error);
  }

  factory DropReason.rejected({
    required String byUserId,
  }) {
    return DropReasonRejected(byUserId: byUserId);
  }

  factory DropReason.cancelled({
    required String byUserId,
  }) {
    return DropReasonCancelled(byUserId: byUserId);
  }

  factory DropReason.ended() {
    return DropReasonEnded();
  }

  @override
  List<Object?> get props => [];
}

class DropReasonTimeout extends DropReason {
  const DropReasonTimeout(this.timeLimit);

  final Duration timeLimit;

  @override
  List<Object?> get props => [timeLimit];

  @override
  String toString() {
    return 'Timeout{timeLimit: $timeLimit}';
  }
}

class DropReasonFailure extends DropReason {
  const DropReasonFailure(this.error);

  final VideoError error;

  @override
  List<Object?> get props => [error];

  @override
  String toString() {
    return 'Failure{error: $error}';
  }
}

class DropReasonRejected extends DropReason {
  const DropReasonRejected({
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

class DropReasonCancelled extends DropReason {
  const DropReasonCancelled({
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

class DropReasonEnded extends DropReason {
  factory DropReasonEnded() {
    return _instance;
  }
  const DropReasonEnded._internal();
  static const DropReasonEnded _instance = DropReasonEnded._internal();
  @override
  String toString() {
    return 'Ended';
  }
}
