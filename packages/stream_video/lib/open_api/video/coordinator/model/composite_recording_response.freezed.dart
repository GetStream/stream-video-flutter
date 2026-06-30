// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'composite_recording_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CompositeRecordingResponse {
  String get status;

  /// Create a copy of CompositeRecordingResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CompositeRecordingResponseCopyWith<CompositeRecordingResponse>
  get copyWith =>
      _$CompositeRecordingResponseCopyWithImpl<CompositeRecordingResponse>(
        this as CompositeRecordingResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CompositeRecordingResponse &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status);

  @override
  String toString() {
    return 'CompositeRecordingResponse(status: $status)';
  }
}

/// @nodoc
abstract mixin class $CompositeRecordingResponseCopyWith<$Res> {
  factory $CompositeRecordingResponseCopyWith(
    CompositeRecordingResponse value,
    $Res Function(CompositeRecordingResponse) _then,
  ) = _$CompositeRecordingResponseCopyWithImpl;
  @useResult
  $Res call({String status});
}

/// @nodoc
class _$CompositeRecordingResponseCopyWithImpl<$Res>
    implements $CompositeRecordingResponseCopyWith<$Res> {
  _$CompositeRecordingResponseCopyWithImpl(this._self, this._then);

  final CompositeRecordingResponse _self;
  final $Res Function(CompositeRecordingResponse) _then;

  /// Create a copy of CompositeRecordingResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null}) {
    return _then(
      CompositeRecordingResponse(
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
