// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_call_members_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryCallMembersRequest {
  Map<String, Object?>? get filterConditions;
  String get id;
  int? get limit;
  String? get next;
  String? get prev;
  List<SortParamRequest>? get sort;
  String get type;

  /// Create a copy of QueryCallMembersRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryCallMembersRequestCopyWith<QueryCallMembersRequest> get copyWith =>
      _$QueryCallMembersRequestCopyWithImpl<QueryCallMembersRequest>(
        this as QueryCallMembersRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryCallMembersRequest &&
            const DeepCollectionEquality().equals(
              other.filterConditions,
              filterConditions,
            ) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.next, next) || other.next == next) &&
            (identical(other.prev, prev) || other.prev == prev) &&
            const DeepCollectionEquality().equals(other.sort, sort) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(filterConditions),
    id,
    limit,
    next,
    prev,
    const DeepCollectionEquality().hash(sort),
    type,
  );

  @override
  String toString() {
    return 'QueryCallMembersRequest(filterConditions: $filterConditions, id: $id, limit: $limit, next: $next, prev: $prev, sort: $sort, type: $type)';
  }
}

/// @nodoc
abstract mixin class $QueryCallMembersRequestCopyWith<$Res> {
  factory $QueryCallMembersRequestCopyWith(
    QueryCallMembersRequest value,
    $Res Function(QueryCallMembersRequest) _then,
  ) = _$QueryCallMembersRequestCopyWithImpl;
  @useResult
  $Res call({
    Map<String, Object?>? filterConditions,
    String id,
    int? limit,
    String? next,
    String? prev,
    List<SortParamRequest>? sort,
    String type,
  });
}

/// @nodoc
class _$QueryCallMembersRequestCopyWithImpl<$Res>
    implements $QueryCallMembersRequestCopyWith<$Res> {
  _$QueryCallMembersRequestCopyWithImpl(this._self, this._then);

  final QueryCallMembersRequest _self;
  final $Res Function(QueryCallMembersRequest) _then;

  /// Create a copy of QueryCallMembersRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filterConditions = freezed,
    Object? id = null,
    Object? limit = freezed,
    Object? next = freezed,
    Object? prev = freezed,
    Object? sort = freezed,
    Object? type = null,
  }) {
    return _then(
      QueryCallMembersRequest(
        filterConditions: freezed == filterConditions
            ? _self.filterConditions
            : filterConditions // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        limit: freezed == limit
            ? _self.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
        next: freezed == next
            ? _self.next
            : next // ignore: cast_nullable_to_non_nullable
                  as String?,
        prev: freezed == prev
            ? _self.prev
            : prev // ignore: cast_nullable_to_non_nullable
                  as String?,
        sort: freezed == sort
            ? _self.sort
            : sort // ignore: cast_nullable_to_non_nullable
                  as List<SortParamRequest>?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
