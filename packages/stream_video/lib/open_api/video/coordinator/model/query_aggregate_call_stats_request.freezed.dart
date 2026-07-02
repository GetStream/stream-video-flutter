// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_aggregate_call_stats_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryAggregateCallStatsRequest {
  String? get from;
  List<String>? get reportTypes;
  String? get to;

  /// Create a copy of QueryAggregateCallStatsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryAggregateCallStatsRequestCopyWith<QueryAggregateCallStatsRequest>
  get copyWith =>
      _$QueryAggregateCallStatsRequestCopyWithImpl<
        QueryAggregateCallStatsRequest
      >(this as QueryAggregateCallStatsRequest, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryAggregateCallStatsRequest &&
            (identical(other.from, from) || other.from == from) &&
            const DeepCollectionEquality().equals(
              other.reportTypes,
              reportTypes,
            ) &&
            (identical(other.to, to) || other.to == to));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    from,
    const DeepCollectionEquality().hash(reportTypes),
    to,
  );

  @override
  String toString() {
    return 'QueryAggregateCallStatsRequest(from: $from, reportTypes: $reportTypes, to: $to)';
  }
}

/// @nodoc
abstract mixin class $QueryAggregateCallStatsRequestCopyWith<$Res> {
  factory $QueryAggregateCallStatsRequestCopyWith(
    QueryAggregateCallStatsRequest value,
    $Res Function(QueryAggregateCallStatsRequest) _then,
  ) = _$QueryAggregateCallStatsRequestCopyWithImpl;
  @useResult
  $Res call({String? from, List<String>? reportTypes, String? to});
}

/// @nodoc
class _$QueryAggregateCallStatsRequestCopyWithImpl<$Res>
    implements $QueryAggregateCallStatsRequestCopyWith<$Res> {
  _$QueryAggregateCallStatsRequestCopyWithImpl(this._self, this._then);

  final QueryAggregateCallStatsRequest _self;
  final $Res Function(QueryAggregateCallStatsRequest) _then;

  /// Create a copy of QueryAggregateCallStatsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = freezed,
    Object? reportTypes = freezed,
    Object? to = freezed,
  }) {
    return _then(
      QueryAggregateCallStatsRequest(
        from: freezed == from
            ? _self.from
            : from // ignore: cast_nullable_to_non_nullable
                  as String?,
        reportTypes: freezed == reportTypes
            ? _self.reportTypes
            : reportTypes // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        to: freezed == to
            ? _self.to
            : to // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
