import 'package:meta/meta.dart';

import '../../errors/stream_video_exception.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';

/// How a join attempt, or a run of them, ended.
///
/// Join attempts never leave the call themselves; the caller that started
/// them decides from the outcome.
@internal
sealed class JoinOutcome {
  const JoinOutcome();
}

/// The call joined.
@internal
final class JoinSucceeded extends JoinOutcome {
  const JoinSucceeded({this.migrationComplete});

  /// Null unless the join migrated to a new SFU. Then it completes once the
  /// new SFU answers the migration, with a failure if it did not complete.
  final Future<Result<None>>? migrationComplete;
}

/// The join failed with [error].
@internal
sealed class JoinFailed extends JoinOutcome {
  const JoinFailed(this.error, [this.stackTrace]);

  final StreamVideoException error;
  final StackTrace? stackTrace;
}

/// The join failed in a way another attempt may fix: from a run of attempts,
/// the retry budget is used up, or another join already holds the join lock.
@internal
final class JoinRetry extends JoinFailed {
  const JoinRetry(super.error, [super.stackTrace]);
}

/// The join failed in a way retrying will not fix.
@internal
final class JoinGiveUp extends JoinFailed {
  const JoinGiveUp(super.error, [super.stackTrace]);
}

/// Nobody answered the ring in time, so the call is rejected rather than only
/// left.
@internal
final class JoinRingUnanswered extends JoinFailed {
  const JoinRingUnanswered(super.error, [super.stackTrace]);
}

/// The call is leaving or has left, so the join stopped.
@internal
final class JoinCancelled extends JoinOutcome {
  const JoinCancelled();
}
