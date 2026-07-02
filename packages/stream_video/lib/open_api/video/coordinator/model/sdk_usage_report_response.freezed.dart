// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sdk_usage_report_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SDKUsageReportResponse {
  List<DailyAggregateSDKUsageReportResponse> get daily;

  /// Create a copy of SDKUsageReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SDKUsageReportResponseCopyWith<SDKUsageReportResponse> get copyWith =>
      _$SDKUsageReportResponseCopyWithImpl<SDKUsageReportResponse>(
        this as SDKUsageReportResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SDKUsageReportResponse &&
            const DeepCollectionEquality().equals(other.daily, daily));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(daily));

  @override
  String toString() {
    return 'SDKUsageReportResponse(daily: $daily)';
  }
}

/// @nodoc
abstract mixin class $SDKUsageReportResponseCopyWith<$Res> {
  factory $SDKUsageReportResponseCopyWith(
    SDKUsageReportResponse value,
    $Res Function(SDKUsageReportResponse) _then,
  ) = _$SDKUsageReportResponseCopyWithImpl;
  @useResult
  $Res call({List<DailyAggregateSDKUsageReportResponse> daily});
}

/// @nodoc
class _$SDKUsageReportResponseCopyWithImpl<$Res>
    implements $SDKUsageReportResponseCopyWith<$Res> {
  _$SDKUsageReportResponseCopyWithImpl(this._self, this._then);

  final SDKUsageReportResponse _self;
  final $Res Function(SDKUsageReportResponse) _then;

  /// Create a copy of SDKUsageReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? daily = null}) {
    return _then(
      SDKUsageReportResponse(
        daily: null == daily
            ? _self.daily
            : daily // ignore: cast_nullable_to_non_nullable
                  as List<DailyAggregateSDKUsageReportResponse>,
      ),
    );
  }
}
