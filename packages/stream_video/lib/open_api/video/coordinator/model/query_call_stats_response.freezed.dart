// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_call_stats_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryCallStatsResponse {
  String get duration;
  String? get next;
  String? get prev;
  List<CallStatsReportSummaryResponse> get reports;

  /// Create a copy of QueryCallStatsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryCallStatsResponseCopyWith<QueryCallStatsResponse> get copyWith =>
      _$QueryCallStatsResponseCopyWithImpl<QueryCallStatsResponse>(
        this as QueryCallStatsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryCallStatsResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.next, next) || other.next == next) &&
            (identical(other.prev, prev) || other.prev == prev) &&
            const DeepCollectionEquality().equals(other.reports, reports));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    next,
    prev,
    const DeepCollectionEquality().hash(reports),
  );

  @override
  String toString() {
    return 'QueryCallStatsResponse(duration: $duration, next: $next, prev: $prev, reports: $reports)';
  }
}

/// @nodoc
abstract mixin class $QueryCallStatsResponseCopyWith<$Res> {
  factory $QueryCallStatsResponseCopyWith(
    QueryCallStatsResponse value,
    $Res Function(QueryCallStatsResponse) _then,
  ) = _$QueryCallStatsResponseCopyWithImpl;
  @useResult
  $Res call({
    String duration,
    String? next,
    String? prev,
    List<CallStatsReportSummaryResponse> reports,
  });
}

/// @nodoc
class _$QueryCallStatsResponseCopyWithImpl<$Res>
    implements $QueryCallStatsResponseCopyWith<$Res> {
  _$QueryCallStatsResponseCopyWithImpl(this._self, this._then);

  final QueryCallStatsResponse _self;
  final $Res Function(QueryCallStatsResponse) _then;

  /// Create a copy of QueryCallStatsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? next = freezed,
    Object? prev = freezed,
    Object? reports = null,
  }) {
    return _then(
      QueryCallStatsResponse(
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
        reports: null == reports
            ? _self.reports
            : reports // ignore: cast_nullable_to_non_nullable
                  as List<CallStatsReportSummaryResponse>,
      ),
    );
  }
}
