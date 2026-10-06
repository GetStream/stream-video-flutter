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

  /// When migrating, completes once the new SFU confirms the migration.
  final Future<Result<None>>? migrationComplete;
}

/// The join failed in a way another attempt may fix. From a run of attempts,
/// it means the retry budget is used up.
@internal
final class JoinRetry extends JoinOutcome {
  const JoinRetry(this.error, [this.stackTrace]);

  final StreamVideoException error;
  final StackTrace? stackTrace;
}

/// The join failed in a way retrying will not fix.
@internal
final class JoinGiveUp extends JoinOutcome {
  const JoinGiveUp(this.error, {this.stackTrace, this.rejectRing = false});

  final StreamVideoException error;
  final StackTrace? stackTrace;

  /// Whether the ring was not answered in time, so the call is rejected
  /// rather than only left.
  final bool rejectRing;
}

/// The call is leaving or has left, so the join stopped.
@internal
final class JoinCancelled extends JoinOutcome {
  const JoinCancelled();
}
