// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'target_resolution.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TargetResolution {
  int? get bitrate;
  int get height;
  int get width;

  /// Create a copy of TargetResolution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TargetResolutionCopyWith<TargetResolution> get copyWith =>
      _$TargetResolutionCopyWithImpl<TargetResolution>(
        this as TargetResolution,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TargetResolution &&
            (identical(other.bitrate, bitrate) || other.bitrate == bitrate) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.width, width) || other.width == width));
  }

  @override
  int get hashCode => Object.hash(runtimeType, bitrate, height, width);

  @override
  String toString() {
    return 'TargetResolution(bitrate: $bitrate, height: $height, width: $width)';
  }
}

/// @nodoc
abstract mixin class $TargetResolutionCopyWith<$Res> {
  factory $TargetResolutionCopyWith(
    TargetResolution value,
    $Res Function(TargetResolution) _then,
  ) = _$TargetResolutionCopyWithImpl;
  @useResult
  $Res call({int? bitrate, int height, int width});
}

/// @nodoc
class _$TargetResolutionCopyWithImpl<$Res>
    implements $TargetResolutionCopyWith<$Res> {
  _$TargetResolutionCopyWithImpl(this._self, this._then);

  final TargetResolution _self;
  final $Res Function(TargetResolution) _then;

  /// Create a copy of TargetResolution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bitrate = freezed,
    Object? height = null,
    Object? width = null,
  }) {
    return _then(
      TargetResolution(
        bitrate: freezed == bitrate
            ? _self.bitrate
            : bitrate // ignore: cast_nullable_to_non_nullable
                  as int?,
        height: null == height
            ? _self.height
            : height // ignore: cast_nullable_to_non_nullable
                  as int,
        width: null == width
            ? _self.width
            : width // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
