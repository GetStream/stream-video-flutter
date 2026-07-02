// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'individual_recording_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IndividualRecordingResponse {
  String get status;

  /// Create a copy of IndividualRecordingResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IndividualRecordingResponseCopyWith<IndividualRecordingResponse>
  get copyWith =>
      _$IndividualRecordingResponseCopyWithImpl<IndividualRecordingResponse>(
        this as IndividualRecordingResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IndividualRecordingResponse &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status);

  @override
  String toString() {
    return 'IndividualRecordingResponse(status: $status)';
  }
}

/// @nodoc
abstract mixin class $IndividualRecordingResponseCopyWith<$Res> {
  factory $IndividualRecordingResponseCopyWith(
    IndividualRecordingResponse value,
    $Res Function(IndividualRecordingResponse) _then,
  ) = _$IndividualRecordingResponseCopyWithImpl;
  @useResult
  $Res call({String status});
}

/// @nodoc
class _$IndividualRecordingResponseCopyWithImpl<$Res>
    implements $IndividualRecordingResponseCopyWith<$Res> {
  _$IndividualRecordingResponseCopyWithImpl(this._self, this._then);

  final IndividualRecordingResponse _self;
  final $Res Function(IndividualRecordingResponse) _then;

  /// Create a copy of IndividualRecordingResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null}) {
    return _then(
      IndividualRecordingResponse(
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
