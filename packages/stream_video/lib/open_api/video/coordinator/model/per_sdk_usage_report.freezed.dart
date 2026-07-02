// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'per_sdk_usage_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PerSDKUsageReport {
  Map<String, int> get byVersion;
  int get total;

  /// Create a copy of PerSDKUsageReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PerSDKUsageReportCopyWith<PerSDKUsageReport> get copyWith =>
      _$PerSDKUsageReportCopyWithImpl<PerSDKUsageReport>(
        this as PerSDKUsageReport,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PerSDKUsageReport &&
            const DeepCollectionEquality().equals(other.byVersion, byVersion) &&
            (identical(other.total, total) || other.total == total));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(byVersion),
    total,
  );

  @override
  String toString() {
    return 'PerSDKUsageReport(byVersion: $byVersion, total: $total)';
  }
}

/// @nodoc
abstract mixin class $PerSDKUsageReportCopyWith<$Res> {
  factory $PerSDKUsageReportCopyWith(
    PerSDKUsageReport value,
    $Res Function(PerSDKUsageReport) _then,
  ) = _$PerSDKUsageReportCopyWithImpl;
  @useResult
  $Res call({Map<String, int> byVersion, int total});
}

/// @nodoc
class _$PerSDKUsageReportCopyWithImpl<$Res>
    implements $PerSDKUsageReportCopyWith<$Res> {
  _$PerSDKUsageReportCopyWithImpl(this._self, this._then);

  final PerSDKUsageReport _self;
  final $Res Function(PerSDKUsageReport) _then;

  /// Create a copy of PerSDKUsageReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? byVersion = null, Object? total = null}) {
    return _then(
      PerSDKUsageReport(
        byVersion: null == byVersion
            ? _self.byVersion
            : byVersion // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        total: null == total
            ? _self.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
