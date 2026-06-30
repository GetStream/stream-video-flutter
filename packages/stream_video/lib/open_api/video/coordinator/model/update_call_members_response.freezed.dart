// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_call_members_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateCallMembersResponse {
  String get duration;
  List<MemberResponse> get members;

  /// Create a copy of UpdateCallMembersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateCallMembersResponseCopyWith<UpdateCallMembersResponse> get copyWith =>
      _$UpdateCallMembersResponseCopyWithImpl<UpdateCallMembersResponse>(
        this as UpdateCallMembersResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateCallMembersResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(other.members, members));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    const DeepCollectionEquality().hash(members),
  );

  @override
  String toString() {
    return 'UpdateCallMembersResponse(duration: $duration, members: $members)';
  }
}

/// @nodoc
abstract mixin class $UpdateCallMembersResponseCopyWith<$Res> {
  factory $UpdateCallMembersResponseCopyWith(
    UpdateCallMembersResponse value,
    $Res Function(UpdateCallMembersResponse) _then,
  ) = _$UpdateCallMembersResponseCopyWithImpl;
  @useResult
  $Res call({String duration, List<MemberResponse> members});
}

/// @nodoc
class _$UpdateCallMembersResponseCopyWithImpl<$Res>
    implements $UpdateCallMembersResponseCopyWith<$Res> {
  _$UpdateCallMembersResponseCopyWithImpl(this._self, this._then);

  final UpdateCallMembersResponse _self;
  final $Res Function(UpdateCallMembersResponse) _then;

  /// Create a copy of UpdateCallMembersResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? members = null}) {
    return _then(
      UpdateCallMembersResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        members: null == members
            ? _self.members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<MemberResponse>,
      ),
    );
  }
}
