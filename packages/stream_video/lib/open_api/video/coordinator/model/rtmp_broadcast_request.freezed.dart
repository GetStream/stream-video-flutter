// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rtmp_broadcast_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RTMPBroadcastRequest {
  LayoutSettingsRequest? get layout;
  String get name;
  RTMPBroadcastRequestQuality? get quality;
  String? get streamKey;
  String get streamUrl;

  /// Create a copy of RTMPBroadcastRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RTMPBroadcastRequestCopyWith<RTMPBroadcastRequest> get copyWith =>
      _$RTMPBroadcastRequestCopyWithImpl<RTMPBroadcastRequest>(
        this as RTMPBroadcastRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RTMPBroadcastRequest &&
            (identical(other.layout, layout) || other.layout == layout) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quality, quality) || other.quality == quality) &&
            (identical(other.streamKey, streamKey) ||
                other.streamKey == streamKey) &&
            (identical(other.streamUrl, streamUrl) ||
                other.streamUrl == streamUrl));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, layout, name, quality, streamKey, streamUrl);

  @override
  String toString() {
    return 'RTMPBroadcastRequest(layout: $layout, name: $name, quality: $quality, streamKey: $streamKey, streamUrl: $streamUrl)';
  }
}

/// @nodoc
abstract mixin class $RTMPBroadcastRequestCopyWith<$Res> {
  factory $RTMPBroadcastRequestCopyWith(
    RTMPBroadcastRequest value,
    $Res Function(RTMPBroadcastRequest) _then,
  ) = _$RTMPBroadcastRequestCopyWithImpl;
  @useResult
  $Res call({
    LayoutSettingsRequest? layout,
    String name,
    RTMPBroadcastRequestQuality? quality,
    String? streamKey,
    String streamUrl,
  });
}

/// @nodoc
class _$RTMPBroadcastRequestCopyWithImpl<$Res>
    implements $RTMPBroadcastRequestCopyWith<$Res> {
  _$RTMPBroadcastRequestCopyWithImpl(this._self, this._then);

  final RTMPBroadcastRequest _self;
  final $Res Function(RTMPBroadcastRequest) _then;

  /// Create a copy of RTMPBroadcastRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? layout = freezed,
    Object? name = null,
    Object? quality = freezed,
    Object? streamKey = freezed,
    Object? streamUrl = null,
  }) {
    return _then(
      RTMPBroadcastRequest(
        layout: freezed == layout
            ? _self.layout
            : layout // ignore: cast_nullable_to_non_nullable
                  as LayoutSettingsRequest?,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        quality: freezed == quality
            ? _self.quality
            : quality // ignore: cast_nullable_to_non_nullable
                  as RTMPBroadcastRequestQuality?,
        streamKey: freezed == streamKey
            ? _self.streamKey
            : streamKey // ignore: cast_nullable_to_non_nullable
                  as String?,
        streamUrl: null == streamUrl
            ? _self.streamUrl
            : streamUrl // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
