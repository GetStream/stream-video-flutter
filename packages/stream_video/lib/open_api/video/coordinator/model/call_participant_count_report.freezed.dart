// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_participant_count_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallParticipantCountReport {
  List<ReportByHistogramBucket> get histogram;

  /// Create a copy of CallParticipantCountReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallParticipantCountReportCopyWith<CallParticipantCountReport>
  get copyWith =>
      _$CallParticipantCountReportCopyWithImpl<CallParticipantCountReport>(
        this as CallParticipantCountReport,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallParticipantCountReport &&
            const DeepCollectionEquality().equals(other.histogram, histogram));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(histogram));

  @override
  String toString() {
    return 'CallParticipantCountReport(histogram: $histogram)';
  }
}

/// @nodoc
abstract mixin class $CallParticipantCountReportCopyWith<$Res> {
  factory $CallParticipantCountReportCopyWith(
    CallParticipantCountReport value,
    $Res Function(CallParticipantCountReport) _then,
  ) = _$CallParticipantCountReportCopyWithImpl;
  @useResult
  $Res call({List<ReportByHistogramBucket> histogram});
}

/// @nodoc
class _$CallParticipantCountReportCopyWithImpl<$Res>
    implements $CallParticipantCountReportCopyWith<$Res> {
  _$CallParticipantCountReportCopyWithImpl(this._self, this._then);

  final CallParticipantCountReport _self;
  final $Res Function(CallParticipantCountReport) _then;

  /// Create a copy of CallParticipantCountReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? histogram = null}) {
    return _then(
      CallParticipantCountReport(
        histogram: null == histogram
            ? _self.histogram
            : histogram // ignore: cast_nullable_to_non_nullable
                  as List<ReportByHistogramBucket>,
      ),
    );
  }
}
