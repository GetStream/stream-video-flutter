// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingress_video_encoding_options_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IngressVideoEncodingOptionsRequest {
  List<IngressVideoLayerRequest> get layers;
  IngressSourceRequest get source;

  /// Create a copy of IngressVideoEncodingOptionsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IngressVideoEncodingOptionsRequestCopyWith<
    IngressVideoEncodingOptionsRequest
  >
  get copyWith =>
      _$IngressVideoEncodingOptionsRequestCopyWithImpl<
        IngressVideoEncodingOptionsRequest
      >(this as IngressVideoEncodingOptionsRequest, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IngressVideoEncodingOptionsRequest &&
            const DeepCollectionEquality().equals(other.layers, layers) &&
            (identical(other.source, source) || other.source == source));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(layers),
    source,
  );

  @override
  String toString() {
    return 'IngressVideoEncodingOptionsRequest(layers: $layers, source: $source)';
  }
}

/// @nodoc
abstract mixin class $IngressVideoEncodingOptionsRequestCopyWith<$Res> {
  factory $IngressVideoEncodingOptionsRequestCopyWith(
    IngressVideoEncodingOptionsRequest value,
    $Res Function(IngressVideoEncodingOptionsRequest) _then,
  ) = _$IngressVideoEncodingOptionsRequestCopyWithImpl;
  @useResult
  $Res call({
    List<IngressVideoLayerRequest> layers,
    IngressSourceRequest source,
  });
}

/// @nodoc
class _$IngressVideoEncodingOptionsRequestCopyWithImpl<$Res>
    implements $IngressVideoEncodingOptionsRequestCopyWith<$Res> {
  _$IngressVideoEncodingOptionsRequestCopyWithImpl(this._self, this._then);

  final IngressVideoEncodingOptionsRequest _self;
  final $Res Function(IngressVideoEncodingOptionsRequest) _then;

  /// Create a copy of IngressVideoEncodingOptionsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? layers = null, Object? source = null}) {
    return _then(
      IngressVideoEncodingOptionsRequest(
        layers: null == layers
            ? _self.layers
            : layers // ignore: cast_nullable_to_non_nullable
                  as List<IngressVideoLayerRequest>,
        source: null == source
            ? _self.source
            : source // ignore: cast_nullable_to_non_nullable
                  as IngressSourceRequest,
      ),
    );
  }
}
