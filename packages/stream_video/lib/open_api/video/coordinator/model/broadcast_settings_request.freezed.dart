// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'broadcast_settings_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BroadcastSettingsRequest {
  bool? get enabled;
  HLSSettingsRequest? get hls;
  RTMPSettingsRequest? get rtmp;

  /// Create a copy of BroadcastSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BroadcastSettingsRequestCopyWith<BroadcastSettingsRequest> get copyWith =>
      _$BroadcastSettingsRequestCopyWithImpl<BroadcastSettingsRequest>(
        this as BroadcastSettingsRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BroadcastSettingsRequest &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.hls, hls) || other.hls == hls) &&
            (identical(other.rtmp, rtmp) || other.rtmp == rtmp));
  }

  @override
  int get hashCode => Object.hash(runtimeType, enabled, hls, rtmp);

  @override
  String toString() {
    return 'BroadcastSettingsRequest(enabled: $enabled, hls: $hls, rtmp: $rtmp)';
  }
}

/// @nodoc
abstract mixin class $BroadcastSettingsRequestCopyWith<$Res> {
  factory $BroadcastSettingsRequestCopyWith(
    BroadcastSettingsRequest value,
    $Res Function(BroadcastSettingsRequest) _then,
  ) = _$BroadcastSettingsRequestCopyWithImpl;
  @useResult
  $Res call({
    bool? enabled,
    HLSSettingsRequest? hls,
    RTMPSettingsRequest? rtmp,
  });
}

/// @nodoc
class _$BroadcastSettingsRequestCopyWithImpl<$Res>
    implements $BroadcastSettingsRequestCopyWith<$Res> {
  _$BroadcastSettingsRequestCopyWithImpl(this._self, this._then);

  final BroadcastSettingsRequest _self;
  final $Res Function(BroadcastSettingsRequest) _then;

  /// Create a copy of BroadcastSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = freezed,
    Object? hls = freezed,
    Object? rtmp = freezed,
  }) {
    return _then(
      BroadcastSettingsRequest(
        enabled: freezed == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        hls: freezed == hls
            ? _self.hls
            : hls // ignore: cast_nullable_to_non_nullable
                  as HLSSettingsRequest?,
        rtmp: freezed == rtmp
            ? _self.rtmp
            : rtmp // ignore: cast_nullable_to_non_nullable
                  as RTMPSettingsRequest?,
      ),
    );
  }
}
