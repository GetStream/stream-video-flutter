// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sdk_usage_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SDKUsageReport {
  Map<String, PerSDKUsageReport> get perSdkUsage;

  /// Create a copy of SDKUsageReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SDKUsageReportCopyWith<SDKUsageReport> get copyWith =>
      _$SDKUsageReportCopyWithImpl<SDKUsageReport>(
        this as SDKUsageReport,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SDKUsageReport &&
            const DeepCollectionEquality().equals(
              other.perSdkUsage,
              perSdkUsage,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(perSdkUsage),
  );

  @override
  String toString() {
    return 'SDKUsageReport(perSdkUsage: $perSdkUsage)';
  }
}

/// @nodoc
abstract mixin class $SDKUsageReportCopyWith<$Res> {
  factory $SDKUsageReportCopyWith(
    SDKUsageReport value,
    $Res Function(SDKUsageReport) _then,
  ) = _$SDKUsageReportCopyWithImpl;
  @useResult
  $Res call({Map<String, PerSDKUsageReport> perSdkUsage});
}

/// @nodoc
class _$SDKUsageReportCopyWithImpl<$Res>
    implements $SDKUsageReportCopyWith<$Res> {
  _$SDKUsageReportCopyWithImpl(this._self, this._then);

  final SDKUsageReport _self;
  final $Res Function(SDKUsageReport) _then;

  /// Create a copy of SDKUsageReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? perSdkUsage = null}) {
    return _then(
      SDKUsageReport(
        perSdkUsage: null == perSdkUsage
            ? _self.perSdkUsage
            : perSdkUsage // ignore: cast_nullable_to_non_nullable
                  as Map<String, PerSDKUsageReport>,
      ),
    );
  }
}
