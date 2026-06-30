// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_participant_count_report_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallParticipantCountReportResponse {
  List<DailyAggregateCallParticipantCountReportResponse> get daily;

  /// Create a copy of CallParticipantCountReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallParticipantCountReportResponseCopyWith<
    CallParticipantCountReportResponse
  >
  get copyWith =>
      _$CallParticipantCountReportResponseCopyWithImpl<
        CallParticipantCountReportResponse
      >(this as CallParticipantCountReportResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallParticipantCountReportResponse &&
            const DeepCollectionEquality().equals(other.daily, daily));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(daily));

  @override
  String toString() {
    return 'CallParticipantCountReportResponse(daily: $daily)';
  }
}

/// @nodoc
abstract mixin class $CallParticipantCountReportResponseCopyWith<$Res> {
  factory $CallParticipantCountReportResponseCopyWith(
    CallParticipantCountReportResponse value,
    $Res Function(CallParticipantCountReportResponse) _then,
  ) = _$CallParticipantCountReportResponseCopyWithImpl;
  @useResult
  $Res call({List<DailyAggregateCallParticipantCountReportResponse> daily});
}

/// @nodoc
class _$CallParticipantCountReportResponseCopyWithImpl<$Res>
    implements $CallParticipantCountReportResponseCopyWith<$Res> {
  _$CallParticipantCountReportResponseCopyWithImpl(this._self, this._then);

  final CallParticipantCountReportResponse _self;
  final $Res Function(CallParticipantCountReportResponse) _then;

  /// Create a copy of CallParticipantCountReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? daily = null}) {
    return _then(
      CallParticipantCountReportResponse(
        daily: null == daily
            ? _self.daily
            : daily // ignore: cast_nullable_to_non_nullable
                  as List<DailyAggregateCallParticipantCountReportResponse>,
      ),
    );
  }
}
