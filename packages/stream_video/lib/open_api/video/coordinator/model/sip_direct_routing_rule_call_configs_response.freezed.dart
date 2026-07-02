// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sip_direct_routing_rule_call_configs_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SIPDirectRoutingRuleCallConfigsResponse {
  String get callId;
  String get callType;

  /// Create a copy of SIPDirectRoutingRuleCallConfigsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SIPDirectRoutingRuleCallConfigsResponseCopyWith<
    SIPDirectRoutingRuleCallConfigsResponse
  >
  get copyWith =>
      _$SIPDirectRoutingRuleCallConfigsResponseCopyWithImpl<
        SIPDirectRoutingRuleCallConfigsResponse
      >(this as SIPDirectRoutingRuleCallConfigsResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SIPDirectRoutingRuleCallConfigsResponse &&
            (identical(other.callId, callId) || other.callId == callId) &&
            (identical(other.callType, callType) ||
                other.callType == callType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, callId, callType);

  @override
  String toString() {
    return 'SIPDirectRoutingRuleCallConfigsResponse(callId: $callId, callType: $callType)';
  }
}

/// @nodoc
abstract mixin class $SIPDirectRoutingRuleCallConfigsResponseCopyWith<$Res> {
  factory $SIPDirectRoutingRuleCallConfigsResponseCopyWith(
    SIPDirectRoutingRuleCallConfigsResponse value,
    $Res Function(SIPDirectRoutingRuleCallConfigsResponse) _then,
  ) = _$SIPDirectRoutingRuleCallConfigsResponseCopyWithImpl;
  @useResult
  $Res call({String callId, String callType});
}

/// @nodoc
class _$SIPDirectRoutingRuleCallConfigsResponseCopyWithImpl<$Res>
    implements $SIPDirectRoutingRuleCallConfigsResponseCopyWith<$Res> {
  _$SIPDirectRoutingRuleCallConfigsResponseCopyWithImpl(this._self, this._then);

  final SIPDirectRoutingRuleCallConfigsResponse _self;
  final $Res Function(SIPDirectRoutingRuleCallConfigsResponse) _then;

  /// Create a copy of SIPDirectRoutingRuleCallConfigsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? callId = null, Object? callType = null}) {
    return _then(
      SIPDirectRoutingRuleCallConfigsResponse(
        callId: null == callId
            ? _self.callId
            : callId // ignore: cast_nullable_to_non_nullable
                  as String,
        callType: null == callType
            ? _self.callType
            : callType // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
