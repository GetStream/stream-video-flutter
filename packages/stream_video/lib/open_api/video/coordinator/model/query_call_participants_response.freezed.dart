// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_call_participants_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryCallParticipantsResponse {
  CallResponse get call;
  String get duration;
  List<MemberResponse> get members;
  MemberResponse? get membership;
  List<OwnCapability> get ownCapabilities;
  List<CallParticipantResponse> get participants;
  int get totalParticipants;

  /// Create a copy of QueryCallParticipantsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryCallParticipantsResponseCopyWith<QueryCallParticipantsResponse>
  get copyWith =>
      _$QueryCallParticipantsResponseCopyWithImpl<
        QueryCallParticipantsResponse
      >(this as QueryCallParticipantsResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryCallParticipantsResponse &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.membership, membership) ||
                other.membership == membership) &&
            const DeepCollectionEquality().equals(
              other.ownCapabilities,
              ownCapabilities,
            ) &&
            const DeepCollectionEquality().equals(
              other.participants,
              participants,
            ) &&
            (identical(other.totalParticipants, totalParticipants) ||
                other.totalParticipants == totalParticipants));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    call,
    duration,
    const DeepCollectionEquality().hash(members),
    membership,
    const DeepCollectionEquality().hash(ownCapabilities),
    const DeepCollectionEquality().hash(participants),
    totalParticipants,
  );

  @override
  String toString() {
    return 'QueryCallParticipantsResponse(call: $call, duration: $duration, members: $members, membership: $membership, ownCapabilities: $ownCapabilities, participants: $participants, totalParticipants: $totalParticipants)';
  }
}

/// @nodoc
abstract mixin class $QueryCallParticipantsResponseCopyWith<$Res> {
  factory $QueryCallParticipantsResponseCopyWith(
    QueryCallParticipantsResponse value,
    $Res Function(QueryCallParticipantsResponse) _then,
  ) = _$QueryCallParticipantsResponseCopyWithImpl;
  @useResult
  $Res call({
    CallResponse call,
    String duration,
    List<MemberResponse> members,
    MemberResponse? membership,
    List<OwnCapability> ownCapabilities,
    List<CallParticipantResponse> participants,
    int totalParticipants,
  });
}

/// @nodoc
class _$QueryCallParticipantsResponseCopyWithImpl<$Res>
    implements $QueryCallParticipantsResponseCopyWith<$Res> {
  _$QueryCallParticipantsResponseCopyWithImpl(this._self, this._then);

  final QueryCallParticipantsResponse _self;
  final $Res Function(QueryCallParticipantsResponse) _then;

  /// Create a copy of QueryCallParticipantsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? call = null,
    Object? duration = null,
    Object? members = null,
    Object? membership = freezed,
    Object? ownCapabilities = null,
    Object? participants = null,
    Object? totalParticipants = null,
  }) {
    return _then(
      QueryCallParticipantsResponse(
        call: null == call
            ? _self.call
            : call // ignore: cast_nullable_to_non_nullable
                  as CallResponse,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        members: null == members
            ? _self.members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<MemberResponse>,
        membership: freezed == membership
            ? _self.membership
            : membership // ignore: cast_nullable_to_non_nullable
                  as MemberResponse?,
        ownCapabilities: null == ownCapabilities
            ? _self.ownCapabilities
            : ownCapabilities // ignore: cast_nullable_to_non_nullable
                  as List<OwnCapability>,
        participants: null == participants
            ? _self.participants
            : participants // ignore: cast_nullable_to_non_nullable
                  as List<CallParticipantResponse>,
        totalParticipants: null == totalParticipants
            ? _self.totalParticipants
            : totalParticipants // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
