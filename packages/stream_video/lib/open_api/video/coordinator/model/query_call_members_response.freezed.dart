// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_call_members_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryCallMembersResponse {
  String get duration;
  List<MemberResponse> get members;
  String? get next;
  String? get prev;

  /// Create a copy of QueryCallMembersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryCallMembersResponseCopyWith<QueryCallMembersResponse> get copyWith =>
      _$QueryCallMembersResponseCopyWithImpl<QueryCallMembersResponse>(
        this as QueryCallMembersResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryCallMembersResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.next, next) || other.next == next) &&
            (identical(other.prev, prev) || other.prev == prev));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    const DeepCollectionEquality().hash(members),
    next,
    prev,
  );

  @override
  String toString() {
    return 'QueryCallMembersResponse(duration: $duration, members: $members, next: $next, prev: $prev)';
  }
}

/// @nodoc
abstract mixin class $QueryCallMembersResponseCopyWith<$Res> {
  factory $QueryCallMembersResponseCopyWith(
    QueryCallMembersResponse value,
    $Res Function(QueryCallMembersResponse) _then,
  ) = _$QueryCallMembersResponseCopyWithImpl;
  @useResult
  $Res call({
    String duration,
    List<MemberResponse> members,
    String? next,
    String? prev,
  });
}

/// @nodoc
class _$QueryCallMembersResponseCopyWithImpl<$Res>
    implements $QueryCallMembersResponseCopyWith<$Res> {
  _$QueryCallMembersResponseCopyWithImpl(this._self, this._then);

  final QueryCallMembersResponse _self;
  final $Res Function(QueryCallMembersResponse) _then;

  /// Create a copy of QueryCallMembersResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? members = null,
    Object? next = freezed,
    Object? prev = freezed,
  }) {
    return _then(
      QueryCallMembersResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        members: null == members
            ? _self.members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<MemberResponse>,
        next: freezed == next
            ? _self.next
            : next // ignore: cast_nullable_to_non_nullable
                  as String?,
        prev: freezed == prev
            ? _self.prev
            : prev // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
