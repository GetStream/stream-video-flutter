// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pin_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PinResponse {
  String get duration;

  /// Create a copy of PinResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PinResponseCopyWith<PinResponse> get copyWith =>
      _$PinResponseCopyWithImpl<PinResponse>(this as PinResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PinResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration);

  @override
  String toString() {
    return 'PinResponse(duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $PinResponseCopyWith<$Res> {
  factory $PinResponseCopyWith(
    PinResponse value,
    $Res Function(PinResponse) _then,
  ) = _$PinResponseCopyWithImpl;
  @useResult
  $Res call({String duration});
}

/// @nodoc
class _$PinResponseCopyWithImpl<$Res> implements $PinResponseCopyWith<$Res> {
  _$PinResponseCopyWithImpl(this._self, this._then);

  final PinResponse _self;
  final $Res Function(PinResponse) _then;

  /// Create a copy of PinResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null}) {
    return _then(
      PinResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
