// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_rating_report_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserRatingReportResponse {
  double get average;
  int get count;

  /// Create a copy of UserRatingReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserRatingReportResponseCopyWith<UserRatingReportResponse> get copyWith =>
      _$UserRatingReportResponseCopyWithImpl<UserRatingReportResponse>(
        this as UserRatingReportResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserRatingReportResponse &&
            (identical(other.average, average) || other.average == average) &&
            (identical(other.count, count) || other.count == count));
  }

  @override
  int get hashCode => Object.hash(runtimeType, average, count);

  @override
  String toString() {
    return 'UserRatingReportResponse(average: $average, count: $count)';
  }
}

/// @nodoc
abstract mixin class $UserRatingReportResponseCopyWith<$Res> {
  factory $UserRatingReportResponseCopyWith(
    UserRatingReportResponse value,
    $Res Function(UserRatingReportResponse) _then,
  ) = _$UserRatingReportResponseCopyWithImpl;
  @useResult
  $Res call({double average, int count});
}

/// @nodoc
class _$UserRatingReportResponseCopyWithImpl<$Res>
    implements $UserRatingReportResponseCopyWith<$Res> {
  _$UserRatingReportResponseCopyWithImpl(this._self, this._then);

  final UserRatingReportResponse _self;
  final $Res Function(UserRatingReportResponse) _then;

  /// Create a copy of UserRatingReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? average = null, Object? count = null}) {
    return _then(
      UserRatingReportResponse(
        average: null == average
            ? _self.average
            : average // ignore: cast_nullable_to_non_nullable
                  as double,
        count: null == count
            ? _self.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
