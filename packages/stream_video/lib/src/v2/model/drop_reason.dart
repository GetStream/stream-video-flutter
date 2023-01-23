import 'package:flutter/cupertino.dart';

import '../errors/video_error.dart';

@immutable
abstract class DropReason {
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
}

class DropReasonTimeout extends DropReason {
  const DropReasonTimeout(this.timeLimit);

  final Duration timeLimit;

  @override
  String toString() {
    return 'Timeout{timeLimit: $timeLimit}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropReasonTimeout &&
          runtimeType == other.runtimeType &&
          timeLimit == other.timeLimit;

  @override
  int get hashCode => timeLimit.hashCode;
}

class DropReasonFailure extends DropReason {
  const DropReasonFailure(this.error);

  final VideoError error;

  @override
  String toString() {
    return 'Failure{error: $error}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropReasonFailure &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;
}

class DropReasonRejected extends DropReason {
  const DropReasonRejected({
    required this.byUserId,
  });

  final String byUserId;

  @override
  String toString() {
    return 'Rejected{byUserId: $byUserId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropReasonRejected &&
          runtimeType == other.runtimeType &&
          byUserId == other.byUserId;

  @override
  int get hashCode => byUserId.hashCode;
}

class DropReasonCancelled extends DropReason {
  const DropReasonCancelled({
    required this.byUserId,
  });

  final String byUserId;

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
