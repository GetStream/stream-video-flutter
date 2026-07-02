// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_session_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParticipantSessionDetails {
  int? get durationInSeconds;
  DateTime? get joinedAt;
  DateTime? get leftAt;
  String get publisherType;
  List<String> get roles;
  String get userId;
  String get userSessionId;

  /// Create a copy of ParticipantSessionDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ParticipantSessionDetailsCopyWith<ParticipantSessionDetails> get copyWith =>
      _$ParticipantSessionDetailsCopyWithImpl<ParticipantSessionDetails>(
        this as ParticipantSessionDetails,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ParticipantSessionDetails &&
            (identical(other.durationInSeconds, durationInSeconds) ||
                other.durationInSeconds == durationInSeconds) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt) &&
            (identical(other.leftAt, leftAt) || other.leftAt == leftAt) &&
            (identical(other.publisherType, publisherType) ||
                other.publisherType == publisherType) &&
            const DeepCollectionEquality().equals(other.roles, roles) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userSessionId, userSessionId) ||
                other.userSessionId == userSessionId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    durationInSeconds,
    joinedAt,
    leftAt,
    publisherType,
    const DeepCollectionEquality().hash(roles),
    userId,
    userSessionId,
  );

  @override
  String toString() {
    return 'ParticipantSessionDetails(durationInSeconds: $durationInSeconds, joinedAt: $joinedAt, leftAt: $leftAt, publisherType: $publisherType, roles: $roles, userId: $userId, userSessionId: $userSessionId)';
  }
}

/// @nodoc
abstract mixin class $ParticipantSessionDetailsCopyWith<$Res> {
  factory $ParticipantSessionDetailsCopyWith(
    ParticipantSessionDetails value,
    $Res Function(ParticipantSessionDetails) _then,
  ) = _$ParticipantSessionDetailsCopyWithImpl;
  @useResult
  $Res call({
    int? durationInSeconds,
    DateTime? joinedAt,
    DateTime? leftAt,
    String publisherType,
    List<String> roles,
    String userId,
    String userSessionId,
  });
}

/// @nodoc
class _$ParticipantSessionDetailsCopyWithImpl<$Res>
    implements $ParticipantSessionDetailsCopyWith<$Res> {
  _$ParticipantSessionDetailsCopyWithImpl(this._self, this._then);

  final ParticipantSessionDetails _self;
  final $Res Function(ParticipantSessionDetails) _then;

  /// Create a copy of ParticipantSessionDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? durationInSeconds = freezed,
    Object? joinedAt = freezed,
    Object? leftAt = freezed,
    Object? publisherType = null,
    Object? roles = null,
    Object? userId = null,
    Object? userSessionId = null,
  }) {
    return _then(
      ParticipantSessionDetails(
        durationInSeconds: freezed == durationInSeconds
            ? _self.durationInSeconds
            : durationInSeconds // ignore: cast_nullable_to_non_nullable
                  as int?,
        joinedAt: freezed == joinedAt
            ? _self.joinedAt
            : joinedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        leftAt: freezed == leftAt
            ? _self.leftAt
            : leftAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        publisherType: null == publisherType
            ? _self.publisherType
            : publisherType // ignore: cast_nullable_to_non_nullable
                  as String,
        roles: null == roles
            ? _self.roles
            : roles // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        userSessionId: null == userSessionId
            ? _self.userSessionId
            : userSessionId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
