// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingress_settings_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IngressSettingsRequest {
  IngressAudioEncodingOptionsRequest? get audioEncodingOptions;
  bool? get enabled;
  Map<String, IngressVideoEncodingOptionsRequest>? get videoEncodingOptions;

  /// Create a copy of IngressSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IngressSettingsRequestCopyWith<IngressSettingsRequest> get copyWith =>
      _$IngressSettingsRequestCopyWithImpl<IngressSettingsRequest>(
        this as IngressSettingsRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IngressSettingsRequest &&
            (identical(other.audioEncodingOptions, audioEncodingOptions) ||
                other.audioEncodingOptions == audioEncodingOptions) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            const DeepCollectionEquality().equals(
              other.videoEncodingOptions,
              videoEncodingOptions,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    audioEncodingOptions,
    enabled,
    const DeepCollectionEquality().hash(videoEncodingOptions),
  );

  @override
  String toString() {
    return 'IngressSettingsRequest(audioEncodingOptions: $audioEncodingOptions, enabled: $enabled, videoEncodingOptions: $videoEncodingOptions)';
  }
}

/// @nodoc
abstract mixin class $IngressSettingsRequestCopyWith<$Res> {
  factory $IngressSettingsRequestCopyWith(
    IngressSettingsRequest value,
    $Res Function(IngressSettingsRequest) _then,
  ) = _$IngressSettingsRequestCopyWithImpl;
  @useResult
  $Res call({
    IngressAudioEncodingOptionsRequest? audioEncodingOptions,
    bool? enabled,
    Map<String, IngressVideoEncodingOptionsRequest>? videoEncodingOptions,
  });
}

/// @nodoc
class _$IngressSettingsRequestCopyWithImpl<$Res>
    implements $IngressSettingsRequestCopyWith<$Res> {
  _$IngressSettingsRequestCopyWithImpl(this._self, this._then);

  final IngressSettingsRequest _self;
  final $Res Function(IngressSettingsRequest) _then;

  /// Create a copy of IngressSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? audioEncodingOptions = freezed,
    Object? enabled = freezed,
    Object? videoEncodingOptions = freezed,
  }) {
    return _then(
      IngressSettingsRequest(
        audioEncodingOptions: freezed == audioEncodingOptions
            ? _self.audioEncodingOptions
            : audioEncodingOptions // ignore: cast_nullable_to_non_nullable
                  as IngressAudioEncodingOptionsRequest?,
        enabled: freezed == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        videoEncodingOptions: freezed == videoEncodingOptions
            ? _self.videoEncodingOptions
            : videoEncodingOptions // ignore: cast_nullable_to_non_nullable
                  as Map<String, IngressVideoEncodingOptionsRequest>?,
      ),
    );
  }
}
