// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingress_video_layer_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IngressVideoLayerResponse {
  int get bitrate;
  String get codec;
  int get frameRateLimit;
  int get maxDimension;
  int get minDimension;

  /// Create a copy of IngressVideoLayerResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IngressVideoLayerResponseCopyWith<IngressVideoLayerResponse> get copyWith =>
      _$IngressVideoLayerResponseCopyWithImpl<IngressVideoLayerResponse>(
        this as IngressVideoLayerResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IngressVideoLayerResponse &&
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
    return 'IngressVideoLayerResponse(bitrate: $bitrate, codec: $codec, frameRateLimit: $frameRateLimit, maxDimension: $maxDimension, minDimension: $minDimension)';
  }
}

/// @nodoc
abstract mixin class $IngressVideoLayerResponseCopyWith<$Res> {
  factory $IngressVideoLayerResponseCopyWith(
    IngressVideoLayerResponse value,
    $Res Function(IngressVideoLayerResponse) _then,
  ) = _$IngressVideoLayerResponseCopyWithImpl;
  @useResult
  $Res call({
    int bitrate,
    String codec,
    int frameRateLimit,
    int maxDimension,
    int minDimension,
  });
}

/// @nodoc
class _$IngressVideoLayerResponseCopyWithImpl<$Res>
    implements $IngressVideoLayerResponseCopyWith<$Res> {
  _$IngressVideoLayerResponseCopyWithImpl(this._self, this._then);

  final IngressVideoLayerResponse _self;
  final $Res Function(IngressVideoLayerResponse) _then;

  /// Create a copy of IngressVideoLayerResponse
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
      IngressVideoLayerResponse(
        bitrate: null == bitrate
            ? _self.bitrate
            : bitrate // ignore: cast_nullable_to_non_nullable
                  as int,
        codec: null == codec
            ? _self.codec
            : codec // ignore: cast_nullable_to_non_nullable
                  as String,
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
