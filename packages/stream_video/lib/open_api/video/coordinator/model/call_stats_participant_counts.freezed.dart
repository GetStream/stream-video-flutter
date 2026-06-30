// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_stats_participant_counts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallStatsParticipantCounts {
  int? get averageJitterMs;
  int? get averageLatencyMs;
  double? get avgUserRating;
  int? get callEventCount;
  int? get cqScore;
  int get liveSessions;
  int? get maxFreezesDurationMs;
  int? get minUserRating;
  int get participants;
  int get peakConcurrentSessions;
  int get peakConcurrentUsers;
  int get publishers;
  int get sessions;
  int get sfusUsed;
  int? get totalParticipantDuration;

  /// Create a copy of CallStatsParticipantCounts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallStatsParticipantCountsCopyWith<CallStatsParticipantCounts>
  get copyWith =>
      _$CallStatsParticipantCountsCopyWithImpl<CallStatsParticipantCounts>(
        this as CallStatsParticipantCounts,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallStatsParticipantCounts &&
            (identical(other.averageJitterMs, averageJitterMs) ||
                other.averageJitterMs == averageJitterMs) &&
            (identical(other.averageLatencyMs, averageLatencyMs) ||
                other.averageLatencyMs == averageLatencyMs) &&
            (identical(other.avgUserRating, avgUserRating) ||
                other.avgUserRating == avgUserRating) &&
            (identical(other.callEventCount, callEventCount) ||
                other.callEventCount == callEventCount) &&
            (identical(other.cqScore, cqScore) || other.cqScore == cqScore) &&
            (identical(other.liveSessions, liveSessions) ||
                other.liveSessions == liveSessions) &&
            (identical(other.maxFreezesDurationMs, maxFreezesDurationMs) ||
                other.maxFreezesDurationMs == maxFreezesDurationMs) &&
            (identical(other.minUserRating, minUserRating) ||
                other.minUserRating == minUserRating) &&
            (identical(other.participants, participants) ||
                other.participants == participants) &&
            (identical(other.peakConcurrentSessions, peakConcurrentSessions) ||
                other.peakConcurrentSessions == peakConcurrentSessions) &&
            (identical(other.peakConcurrentUsers, peakConcurrentUsers) ||
                other.peakConcurrentUsers == peakConcurrentUsers) &&
            (identical(other.publishers, publishers) ||
                other.publishers == publishers) &&
            (identical(other.sessions, sessions) ||
                other.sessions == sessions) &&
            (identical(other.sfusUsed, sfusUsed) ||
                other.sfusUsed == sfusUsed) &&
            (identical(
                  other.totalParticipantDuration,
                  totalParticipantDuration,
                ) ||
                other.totalParticipantDuration == totalParticipantDuration));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    averageJitterMs,
    averageLatencyMs,
    avgUserRating,
    callEventCount,
    cqScore,
    liveSessions,
    maxFreezesDurationMs,
    minUserRating,
    participants,
    peakConcurrentSessions,
    peakConcurrentUsers,
    publishers,
    sessions,
    sfusUsed,
    totalParticipantDuration,
  );

  @override
  String toString() {
    return 'CallStatsParticipantCounts(averageJitterMs: $averageJitterMs, averageLatencyMs: $averageLatencyMs, avgUserRating: $avgUserRating, callEventCount: $callEventCount, cqScore: $cqScore, liveSessions: $liveSessions, maxFreezesDurationMs: $maxFreezesDurationMs, minUserRating: $minUserRating, participants: $participants, peakConcurrentSessions: $peakConcurrentSessions, peakConcurrentUsers: $peakConcurrentUsers, publishers: $publishers, sessions: $sessions, sfusUsed: $sfusUsed, totalParticipantDuration: $totalParticipantDuration)';
  }
}

/// @nodoc
abstract mixin class $CallStatsParticipantCountsCopyWith<$Res> {
  factory $CallStatsParticipantCountsCopyWith(
    CallStatsParticipantCounts value,
    $Res Function(CallStatsParticipantCounts) _then,
  ) = _$CallStatsParticipantCountsCopyWithImpl;
  @useResult
  $Res call({
    int? averageJitterMs,
    int? averageLatencyMs,
    double? avgUserRating,
    int? callEventCount,
    int? cqScore,
    int liveSessions,
    int? maxFreezesDurationMs,
    int? minUserRating,
    int participants,
    int peakConcurrentSessions,
    int peakConcurrentUsers,
    int publishers,
    int sessions,
    int sfusUsed,
    int? totalParticipantDuration,
  });
}

/// @nodoc
class _$CallStatsParticipantCountsCopyWithImpl<$Res>
    implements $CallStatsParticipantCountsCopyWith<$Res> {
  _$CallStatsParticipantCountsCopyWithImpl(this._self, this._then);

  final CallStatsParticipantCounts _self;
  final $Res Function(CallStatsParticipantCounts) _then;

  /// Create a copy of CallStatsParticipantCounts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageJitterMs = freezed,
    Object? averageLatencyMs = freezed,
    Object? avgUserRating = freezed,
    Object? callEventCount = freezed,
    Object? cqScore = freezed,
    Object? liveSessions = null,
    Object? maxFreezesDurationMs = freezed,
    Object? minUserRating = freezed,
    Object? participants = null,
    Object? peakConcurrentSessions = null,
    Object? peakConcurrentUsers = null,
    Object? publishers = null,
    Object? sessions = null,
    Object? sfusUsed = null,
    Object? totalParticipantDuration = freezed,
  }) {
    return _then(
      CallStatsParticipantCounts(
        averageJitterMs: freezed == averageJitterMs
            ? _self.averageJitterMs
            : averageJitterMs // ignore: cast_nullable_to_non_nullable
                  as int?,
        averageLatencyMs: freezed == averageLatencyMs
            ? _self.averageLatencyMs
            : averageLatencyMs // ignore: cast_nullable_to_non_nullable
                  as int?,
        avgUserRating: freezed == avgUserRating
            ? _self.avgUserRating
            : avgUserRating // ignore: cast_nullable_to_non_nullable
                  as double?,
        callEventCount: freezed == callEventCount
            ? _self.callEventCount
            : callEventCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        cqScore: freezed == cqScore
            ? _self.cqScore
            : cqScore // ignore: cast_nullable_to_non_nullable
                  as int?,
        liveSessions: null == liveSessions
            ? _self.liveSessions
            : liveSessions // ignore: cast_nullable_to_non_nullable
                  as int,
        maxFreezesDurationMs: freezed == maxFreezesDurationMs
            ? _self.maxFreezesDurationMs
            : maxFreezesDurationMs // ignore: cast_nullable_to_non_nullable
                  as int?,
        minUserRating: freezed == minUserRating
            ? _self.minUserRating
            : minUserRating // ignore: cast_nullable_to_non_nullable
                  as int?,
        participants: null == participants
            ? _self.participants
            : participants // ignore: cast_nullable_to_non_nullable
                  as int,
        peakConcurrentSessions: null == peakConcurrentSessions
            ? _self.peakConcurrentSessions
            : peakConcurrentSessions // ignore: cast_nullable_to_non_nullable
                  as int,
        peakConcurrentUsers: null == peakConcurrentUsers
            ? _self.peakConcurrentUsers
            : peakConcurrentUsers // ignore: cast_nullable_to_non_nullable
                  as int,
        publishers: null == publishers
            ? _self.publishers
            : publishers // ignore: cast_nullable_to_non_nullable
                  as int,
        sessions: null == sessions
            ? _self.sessions
            : sessions // ignore: cast_nullable_to_non_nullable
                  as int,
        sfusUsed: null == sfusUsed
            ? _self.sfusUsed
            : sfusUsed // ignore: cast_nullable_to_non_nullable
                  as int,
        totalParticipantDuration: freezed == totalParticipantDuration
            ? _self.totalParticipantDuration
            : totalParticipantDuration // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}
