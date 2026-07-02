// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sip_inbound_routing_rule_pin_configs_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SIPInboundRoutingRulePinConfigsResponse {
  String? get customWebhookUrl;
  String? get pinFailedAttemptPrompt;
  String? get pinHangupPrompt;
  String? get pinPrompt;
  String? get pinSuccessPrompt;

  /// Create a copy of SIPInboundRoutingRulePinConfigsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SIPInboundRoutingRulePinConfigsResponseCopyWith<
    SIPInboundRoutingRulePinConfigsResponse
  >
  get copyWith =>
      _$SIPInboundRoutingRulePinConfigsResponseCopyWithImpl<
        SIPInboundRoutingRulePinConfigsResponse
      >(this as SIPInboundRoutingRulePinConfigsResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SIPInboundRoutingRulePinConfigsResponse &&
            (identical(other.customWebhookUrl, customWebhookUrl) ||
                other.customWebhookUrl == customWebhookUrl) &&
            (identical(other.pinFailedAttemptPrompt, pinFailedAttemptPrompt) ||
                other.pinFailedAttemptPrompt == pinFailedAttemptPrompt) &&
            (identical(other.pinHangupPrompt, pinHangupPrompt) ||
                other.pinHangupPrompt == pinHangupPrompt) &&
            (identical(other.pinPrompt, pinPrompt) ||
                other.pinPrompt == pinPrompt) &&
            (identical(other.pinSuccessPrompt, pinSuccessPrompt) ||
                other.pinSuccessPrompt == pinSuccessPrompt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    customWebhookUrl,
    pinFailedAttemptPrompt,
    pinHangupPrompt,
    pinPrompt,
    pinSuccessPrompt,
  );

  @override
  String toString() {
    return 'SIPInboundRoutingRulePinConfigsResponse(customWebhookUrl: $customWebhookUrl, pinFailedAttemptPrompt: $pinFailedAttemptPrompt, pinHangupPrompt: $pinHangupPrompt, pinPrompt: $pinPrompt, pinSuccessPrompt: $pinSuccessPrompt)';
  }
}

/// @nodoc
abstract mixin class $SIPInboundRoutingRulePinConfigsResponseCopyWith<$Res> {
  factory $SIPInboundRoutingRulePinConfigsResponseCopyWith(
    SIPInboundRoutingRulePinConfigsResponse value,
    $Res Function(SIPInboundRoutingRulePinConfigsResponse) _then,
  ) = _$SIPInboundRoutingRulePinConfigsResponseCopyWithImpl;
  @useResult
  $Res call({
    String? customWebhookUrl,
    String? pinFailedAttemptPrompt,
    String? pinHangupPrompt,
    String? pinPrompt,
    String? pinSuccessPrompt,
  });
}

/// @nodoc
class _$SIPInboundRoutingRulePinConfigsResponseCopyWithImpl<$Res>
    implements $SIPInboundRoutingRulePinConfigsResponseCopyWith<$Res> {
  _$SIPInboundRoutingRulePinConfigsResponseCopyWithImpl(this._self, this._then);

  final SIPInboundRoutingRulePinConfigsResponse _self;
  final $Res Function(SIPInboundRoutingRulePinConfigsResponse) _then;

  /// Create a copy of SIPInboundRoutingRulePinConfigsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customWebhookUrl = freezed,
    Object? pinFailedAttemptPrompt = freezed,
    Object? pinHangupPrompt = freezed,
    Object? pinPrompt = freezed,
    Object? pinSuccessPrompt = freezed,
  }) {
    return _then(
      SIPInboundRoutingRulePinConfigsResponse(
        customWebhookUrl: freezed == customWebhookUrl
            ? _self.customWebhookUrl
            : customWebhookUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        pinFailedAttemptPrompt: freezed == pinFailedAttemptPrompt
            ? _self.pinFailedAttemptPrompt
            : pinFailedAttemptPrompt // ignore: cast_nullable_to_non_nullable
                  as String?,
        pinHangupPrompt: freezed == pinHangupPrompt
            ? _self.pinHangupPrompt
            : pinHangupPrompt // ignore: cast_nullable_to_non_nullable
                  as String?,
        pinPrompt: freezed == pinPrompt
            ? _self.pinPrompt
            : pinPrompt // ignore: cast_nullable_to_non_nullable
                  as String?,
        pinSuccessPrompt: freezed == pinSuccessPrompt
            ? _self.pinSuccessPrompt
            : pinSuccessPrompt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
