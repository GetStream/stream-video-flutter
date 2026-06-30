// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_calls_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryCallsResponse {
  List<CallStateResponseFields> get calls;
  String get duration;
  String? get next;
  String? get prev;

  /// Create a copy of QueryCallsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryCallsResponseCopyWith<QueryCallsResponse> get copyWith =>
      _$QueryCallsResponseCopyWithImpl<QueryCallsResponse>(
        this as QueryCallsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryCallsResponse &&
            const DeepCollectionEquality().equals(other.calls, calls) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.next, next) || other.next == next) &&
            (identical(other.prev, prev) || other.prev == prev));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(calls),
    duration,
    next,
    prev,
  );

  @override
  String toString() {
    return 'QueryCallsResponse(calls: $calls, duration: $duration, next: $next, prev: $prev)';
  }
}

/// @nodoc
abstract mixin class $QueryCallsResponseCopyWith<$Res> {
  factory $QueryCallsResponseCopyWith(
    QueryCallsResponse value,
    $Res Function(QueryCallsResponse) _then,
  ) = _$QueryCallsResponseCopyWithImpl;
  @useResult
  $Res call({
    List<CallStateResponseFields> calls,
    String duration,
    String? next,
    String? prev,
  });
}

/// @nodoc
class _$QueryCallsResponseCopyWithImpl<$Res>
    implements $QueryCallsResponseCopyWith<$Res> {
  _$QueryCallsResponseCopyWithImpl(this._self, this._then);

  final QueryCallsResponse _self;
  final $Res Function(QueryCallsResponse) _then;

  /// Create a copy of QueryCallsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? calls = null,
    Object? duration = null,
    Object? next = freezed,
    Object? prev = freezed,
  }) {
    return _then(
      QueryCallsResponse(
        calls: null == calls
            ? _self.calls
            : calls // ignore: cast_nullable_to_non_nullable
                  as List<CallStateResponseFields>,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
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
