// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportResponse {
  CallReportResponse get call;
  ParticipantReportResponse get participants;
  UserRatingReportResponse get userRatings;

  /// Create a copy of ReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReportResponseCopyWith<ReportResponse> get copyWith =>
      _$ReportResponseCopyWithImpl<ReportResponse>(
        this as ReportResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReportResponse &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.participants, participants) ||
                other.participants == participants) &&
            (identical(other.userRatings, userRatings) ||
                other.userRatings == userRatings));
  }

  @override
  int get hashCode => Object.hash(runtimeType, call, participants, userRatings);

  @override
  String toString() {
    return 'ReportResponse(call: $call, participants: $participants, userRatings: $userRatings)';
  }
}

/// @nodoc
abstract mixin class $ReportResponseCopyWith<$Res> {
  factory $ReportResponseCopyWith(
    ReportResponse value,
    $Res Function(ReportResponse) _then,
  ) = _$ReportResponseCopyWithImpl;
  @useResult
  $Res call({
    CallReportResponse call,
    ParticipantReportResponse participants,
    UserRatingReportResponse userRatings,
  });
}

/// @nodoc
class _$ReportResponseCopyWithImpl<$Res>
    implements $ReportResponseCopyWith<$Res> {
  _$ReportResponseCopyWithImpl(this._self, this._then);

  final ReportResponse _self;
  final $Res Function(ReportResponse) _then;

  /// Create a copy of ReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? call = null,
    Object? participants = null,
    Object? userRatings = null,
  }) {
    return _then(
      ReportResponse(
        call: null == call
            ? _self.call
            : call // ignore: cast_nullable_to_non_nullable
                  as CallReportResponse,
        participants: null == participants
            ? _self.participants
            : participants // ignore: cast_nullable_to_non_nullable
                  as ParticipantReportResponse,
        userRatings: null == userRatings
            ? _self.userRatings
            : userRatings // ignore: cast_nullable_to_non_nullable
                  as UserRatingReportResponse,
      ),
    );
  }
}
