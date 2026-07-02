// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingress_source_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IngressSourceResponse {
  int get fps;
  int get height;
  int get width;

  /// Create a copy of IngressSourceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IngressSourceResponseCopyWith<IngressSourceResponse> get copyWith =>
      _$IngressSourceResponseCopyWithImpl<IngressSourceResponse>(
        this as IngressSourceResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IngressSourceResponse &&
            (identical(other.fps, fps) || other.fps == fps) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.width, width) || other.width == width));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fps, height, width);

  @override
  String toString() {
    return 'IngressSourceResponse(fps: $fps, height: $height, width: $width)';
  }
}

/// @nodoc
abstract mixin class $IngressSourceResponseCopyWith<$Res> {
  factory $IngressSourceResponseCopyWith(
    IngressSourceResponse value,
    $Res Function(IngressSourceResponse) _then,
  ) = _$IngressSourceResponseCopyWithImpl;
  @useResult
  $Res call({int fps, int height, int width});
}

/// @nodoc
class _$IngressSourceResponseCopyWithImpl<$Res>
    implements $IngressSourceResponseCopyWith<$Res> {
  _$IngressSourceResponseCopyWithImpl(this._self, this._then);

  final IngressSourceResponse _self;
  final $Res Function(IngressSourceResponse) _then;

  /// Create a copy of IngressSourceResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? fps = null, Object? height = null, Object? width = null}) {
    return _then(
      IngressSourceResponse(
        fps: null == fps
            ? _self.fps
            : fps // ignore: cast_nullable_to_non_nullable
                  as int,
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
