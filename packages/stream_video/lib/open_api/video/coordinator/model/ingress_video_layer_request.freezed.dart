// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingress_video_layer_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IngressVideoLayerRequest {
  int get bitrate;
  IngressVideoLayerRequestCodec get codec;
  int get frameRateLimit;
  int get maxDimension;
  int get minDimension;

  /// Create a copy of IngressVideoLayerRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IngressVideoLayerRequestCopyWith<IngressVideoLayerRequest> get copyWith =>
      _$IngressVideoLayerRequestCopyWithImpl<IngressVideoLayerRequest>(
        this as IngressVideoLayerRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IngressVideoLayerRequest &&
            (identical(other.bitrate, bitrate) || other.bitrate == bitrate) &&
            (identical(other.codec, codec) || other.codec == codec) &&
            (identical(other.frameRateLimit, frameRateLimit) ||
                other.frameRateLimit == frameRateLimit) &&
            (identical(other.maxDimension, maxDimension) ||
                other.maxDimension == maxDimension) &&
            (identical(other.minDimension, minDimension) ||
                other.minDimension == minDimension));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    bitrate,
    codec,
    frameRateLimit,
    maxDimension,
    minDimension,
  );

  @override
  String toString() {
    return 'IngressVideoLayerRequest(bitrate: $bitrate, codec: $codec, frameRateLimit: $frameRateLimit, maxDimension: $maxDimension, minDimension: $minDimension)';
  }
}

/// @nodoc
abstract mixin class $IngressVideoLayerRequestCopyWith<$Res> {
  factory $IngressVideoLayerRequestCopyWith(
    IngressVideoLayerRequest value,
    $Res Function(IngressVideoLayerRequest) _then,
  ) = _$IngressVideoLayerRequestCopyWithImpl;
  @useResult
  $Res call({
    int bitrate,
    IngressVideoLayerRequestCodec codec,
    int frameRateLimit,
    int maxDimension,
    int minDimension,
  });
}

/// @nodoc
class _$IngressVideoLayerRequestCopyWithImpl<$Res>
    implements $IngressVideoLayerRequestCopyWith<$Res> {
  _$IngressVideoLayerRequestCopyWithImpl(this._self, this._then);

  final IngressVideoLayerRequest _self;
  final $Res Function(IngressVideoLayerRequest) _then;

  /// Create a copy of IngressVideoLayerRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bitrate = null,
    Object? codec = null,
    Object? frameRateLimit = null,
    Object? maxDimension = null,
    Object? minDimension = null,
  }) {
    return _then(
      IngressVideoLayerRequest(
        bitrate: null == bitrate
            ? _self.bitrate
            : bitrate // ignore: cast_nullable_to_non_nullable
                  as int,
        codec: null == codec
            ? _self.codec
            : codec // ignore: cast_nullable_to_non_nullable
                  as IngressVideoLayerRequestCodec,
        frameRateLimit: null == frameRateLimit
            ? _self.frameRateLimit
            : frameRateLimit // ignore: cast_nullable_to_non_nullable
                  as int,
        maxDimension: null == maxDimension
            ? _self.maxDimension
            : maxDimension // ignore: cast_nullable_to_non_nullable
                  as int,
        minDimension: null == minDimension
            ? _self.minDimension
            : minDimension // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
