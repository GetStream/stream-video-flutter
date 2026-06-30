// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sip_call_configs_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SIPCallConfigsResponse {
  Map<String, Object?> get customData;

  /// Create a copy of SIPCallConfigsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SIPCallConfigsResponseCopyWith<SIPCallConfigsResponse> get copyWith =>
      _$SIPCallConfigsResponseCopyWithImpl<SIPCallConfigsResponse>(
        this as SIPCallConfigsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SIPCallConfigsResponse &&
            const DeepCollectionEquality().equals(
              other.customData,
              customData,
            ));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(customData));

  @override
  String toString() {
    return 'SIPCallConfigsResponse(customData: $customData)';
  }
}

/// @nodoc
abstract mixin class $SIPCallConfigsResponseCopyWith<$Res> {
  factory $SIPCallConfigsResponseCopyWith(
    SIPCallConfigsResponse value,
    $Res Function(SIPCallConfigsResponse) _then,
  ) = _$SIPCallConfigsResponseCopyWithImpl;
  @useResult
  $Res call({Map<String, Object?> customData});
}

/// @nodoc
class _$SIPCallConfigsResponseCopyWithImpl<$Res>
    implements $SIPCallConfigsResponseCopyWith<$Res> {
  _$SIPCallConfigsResponseCopyWithImpl(this._self, this._then);

  final SIPCallConfigsResponse _self;
  final $Res Function(SIPCallConfigsResponse) _then;

  /// Create a copy of SIPCallConfigsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? customData = null}) {
    return _then(
      SIPCallConfigsResponse(
        customData: null == customData
            ? _self.customData
            : customData // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
      ),
    );
  }
}
