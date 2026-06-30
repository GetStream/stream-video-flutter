// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_report_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallReportResponse {
  DateTime? get endedAt;
  double get score;
  DateTime? get startedAt;

  /// Create a copy of CallReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallReportResponseCopyWith<CallReportResponse> get copyWith =>
      _$CallReportResponseCopyWithImpl<CallReportResponse>(
        this as CallReportResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallReportResponse &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, endedAt, score, startedAt);

  @override
  String toString() {
    return 'CallReportResponse(endedAt: $endedAt, score: $score, startedAt: $startedAt)';
  }
}

/// @nodoc
abstract mixin class $CallReportResponseCopyWith<$Res> {
  factory $CallReportResponseCopyWith(
    CallReportResponse value,
    $Res Function(CallReportResponse) _then,
  ) = _$CallReportResponseCopyWithImpl;
  @useResult
  $Res call({DateTime? endedAt, double score, DateTime? startedAt});
}

/// @nodoc
class _$CallReportResponseCopyWithImpl<$Res>
    implements $CallReportResponseCopyWith<$Res> {
  _$CallReportResponseCopyWithImpl(this._self, this._then);

  final CallReportResponse _self;
  final $Res Function(CallReportResponse) _then;

  /// Create a copy of CallReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? endedAt = freezed,
    Object? score = null,
    Object? startedAt = freezed,
  }) {
    return _then(
      CallReportResponse(
        endedAt: freezed == endedAt
            ? _self.endedAt
            : endedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        score: null == score
            ? _self.score
            : score // ignore: cast_nullable_to_non_nullable
                  as double,
        startedAt: freezed == startedAt
            ? _self.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}
