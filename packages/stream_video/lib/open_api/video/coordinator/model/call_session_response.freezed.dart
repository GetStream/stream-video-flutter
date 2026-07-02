// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_session_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallSessionResponse {
  Map<String, DateTime> get acceptedBy;
  int get anonymousParticipantCount;
  DateTime? get endedAt;
  String get id;
  DateTime? get liveEndedAt;
  DateTime? get liveStartedAt;
  Map<String, DateTime> get missedBy;
  List<CallParticipantResponse> get participants;
  Map<String, int> get participantsCountByRole;
  Map<String, DateTime> get rejectedBy;
  DateTime? get startedAt;
  DateTime? get timerEndsAt;

  /// Create a copy of CallSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallSessionResponseCopyWith<CallSessionResponse> get copyWith =>
      _$CallSessionResponseCopyWithImpl<CallSessionResponse>(
        this as CallSessionResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallSessionResponse &&
            const DeepCollectionEquality().equals(
              other.acceptedBy,
              acceptedBy,
            ) &&
            (identical(
                  other.anonymousParticipantCount,
                  anonymousParticipantCount,
                ) ||
                other.anonymousParticipantCount == anonymousParticipantCount) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.liveEndedAt, liveEndedAt) ||
                other.liveEndedAt == liveEndedAt) &&
            (identical(other.liveStartedAt, liveStartedAt) ||
                other.liveStartedAt == liveStartedAt) &&
            const DeepCollectionEquality().equals(other.missedBy, missedBy) &&
            const DeepCollectionEquality().equals(
              other.participants,
              participants,
            ) &&
            const DeepCollectionEquality().equals(
              other.participantsCountByRole,
              participantsCountByRole,
            ) &&
            const DeepCollectionEquality().equals(
              other.rejectedBy,
              rejectedBy,
            ) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.timerEndsAt, timerEndsAt) ||
                other.timerEndsAt == timerEndsAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(acceptedBy),
    anonymousParticipantCount,
    endedAt,
    id,
    liveEndedAt,
    liveStartedAt,
    const DeepCollectionEquality().hash(missedBy),
    const DeepCollectionEquality().hash(participants),
    const DeepCollectionEquality().hash(participantsCountByRole),
    const DeepCollectionEquality().hash(rejectedBy),
    startedAt,
    timerEndsAt,
  );

  @override
  String toString() {
    return 'CallSessionResponse(acceptedBy: $acceptedBy, anonymousParticipantCount: $anonymousParticipantCount, endedAt: $endedAt, id: $id, liveEndedAt: $liveEndedAt, liveStartedAt: $liveStartedAt, missedBy: $missedBy, participants: $participants, participantsCountByRole: $participantsCountByRole, rejectedBy: $rejectedBy, startedAt: $startedAt, timerEndsAt: $timerEndsAt)';
  }
}

/// @nodoc
abstract mixin class $CallSessionResponseCopyWith<$Res> {
  factory $CallSessionResponseCopyWith(
    CallSessionResponse value,
    $Res Function(CallSessionResponse) _then,
  ) = _$CallSessionResponseCopyWithImpl;
  @useResult
  $Res call({
    Map<String, DateTime> acceptedBy,
    int anonymousParticipantCount,
    DateTime? endedAt,
    String id,
    DateTime? liveEndedAt,
    DateTime? liveStartedAt,
    Map<String, DateTime> missedBy,
    List<CallParticipantResponse> participants,
    Map<String, int> participantsCountByRole,
    Map<String, DateTime> rejectedBy,
    DateTime? startedAt,
    DateTime? timerEndsAt,
  });
}

/// @nodoc
class _$CallSessionResponseCopyWithImpl<$Res>
    implements $CallSessionResponseCopyWith<$Res> {
  _$CallSessionResponseCopyWithImpl(this._self, this._then);

  final CallSessionResponse _self;
  final $Res Function(CallSessionResponse) _then;

  /// Create a copy of CallSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? acceptedBy = null,
    Object? anonymousParticipantCount = null,
    Object? endedAt = freezed,
    Object? id = null,
    Object? liveEndedAt = freezed,
    Object? liveStartedAt = freezed,
    Object? missedBy = null,
    Object? participants = null,
    Object? participantsCountByRole = null,
    Object? rejectedBy = null,
    Object? startedAt = freezed,
    Object? timerEndsAt = freezed,
  }) {
    return _then(
      CallSessionResponse(
        acceptedBy: null == acceptedBy
            ? _self.acceptedBy
            : acceptedBy // ignore: cast_nullable_to_non_nullable
                  as Map<String, DateTime>,
        anonymousParticipantCount: null == anonymousParticipantCount
            ? _self.anonymousParticipantCount
            : anonymousParticipantCount // ignore: cast_nullable_to_non_nullable
                  as int,
        endedAt: freezed == endedAt
            ? _self.endedAt
            : endedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        liveEndedAt: freezed == liveEndedAt
            ? _self.liveEndedAt
            : liveEndedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        liveStartedAt: freezed == liveStartedAt
            ? _self.liveStartedAt
            : liveStartedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        missedBy: null == missedBy
            ? _self.missedBy
            : missedBy // ignore: cast_nullable_to_non_nullable
                  as Map<String, DateTime>,
        participants: null == participants
            ? _self.participants
            : participants // ignore: cast_nullable_to_non_nullable
                  as List<CallParticipantResponse>,
        participantsCountByRole: null == participantsCountByRole
            ? _self.participantsCountByRole
            : participantsCountByRole // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        rejectedBy: null == rejectedBy
            ? _self.rejectedBy
            : rejectedBy // ignore: cast_nullable_to_non_nullable
                  as Map<String, DateTime>,
        startedAt: freezed == startedAt
            ? _self.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        timerEndsAt: freezed == timerEndsAt
            ? _self.timerEndsAt
            : timerEndsAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}
