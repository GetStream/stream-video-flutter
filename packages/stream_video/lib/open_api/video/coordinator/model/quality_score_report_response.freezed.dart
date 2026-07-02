// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quality_score_report_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QualityScoreReportResponse {
  List<DailyAggregateQualityScoreReportResponse> get daily;

  /// Create a copy of QualityScoreReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QualityScoreReportResponseCopyWith<QualityScoreReportResponse>
  get copyWith =>
      _$QualityScoreReportResponseCopyWithImpl<QualityScoreReportResponse>(
        this as QualityScoreReportResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QualityScoreReportResponse &&
            const DeepCollectionEquality().equals(other.daily, daily));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(daily));

  @override
  String toString() {
    return 'QualityScoreReportResponse(daily: $daily)';
  }
}

/// @nodoc
abstract mixin class $QualityScoreReportResponseCopyWith<$Res> {
  factory $QualityScoreReportResponseCopyWith(
    QualityScoreReportResponse value,
    $Res Function(QualityScoreReportResponse) _then,
  ) = _$QualityScoreReportResponseCopyWithImpl;
  @useResult
  $Res call({List<DailyAggregateQualityScoreReportResponse> daily});
}

/// @nodoc
class _$QualityScoreReportResponseCopyWithImpl<$Res>
    implements $QualityScoreReportResponseCopyWith<$Res> {
  _$QualityScoreReportResponseCopyWithImpl(this._self, this._then);

  final QualityScoreReportResponse _self;
  final $Res Function(QualityScoreReportResponse) _then;

  /// Create a copy of QualityScoreReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? daily = null}) {
    return _then(
      QualityScoreReportResponse(
        daily: null == daily
            ? _self.daily
            : daily // ignore: cast_nullable_to_non_nullable
                  as List<DailyAggregateQualityScoreReportResponse>,
      ),
    );
  }
}
