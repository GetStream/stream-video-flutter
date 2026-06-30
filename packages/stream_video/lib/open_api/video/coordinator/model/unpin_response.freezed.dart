// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unpin_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnpinResponse {
  String get duration;

  /// Create a copy of UnpinResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UnpinResponseCopyWith<UnpinResponse> get copyWith =>
      _$UnpinResponseCopyWithImpl<UnpinResponse>(
        this as UnpinResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UnpinResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration);

  @override
  String toString() {
    return 'UnpinResponse(duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $UnpinResponseCopyWith<$Res> {
  factory $UnpinResponseCopyWith(
    UnpinResponse value,
    $Res Function(UnpinResponse) _then,
  ) = _$UnpinResponseCopyWithImpl;
  @useResult
  $Res call({String duration});
}

/// @nodoc
class _$UnpinResponseCopyWithImpl<$Res>
    implements $UnpinResponseCopyWith<$Res> {
  _$UnpinResponseCopyWithImpl(this._self, this._then);

  final UnpinResponse _self;
  final $Res Function(UnpinResponse) _then;

  /// Create a copy of UnpinResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null}) {
    return _then(
      UnpinResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
