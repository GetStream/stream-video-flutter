// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sip_inbound_routing_rule_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SIPInboundRoutingRuleResponse {
  SIPCallConfigsResponse? get callConfigs;
  List<String> get calledNumbers;
  SIPCallerConfigsResponse? get callerConfigs;
  List<String>? get callerNumbers;
  DateTime get createdAt;
  SIPDirectRoutingRuleCallConfigsResponse? get directRoutingConfigs;
  String get duration;
  String get id;
  String get name;
  SIPPinProtectionConfigsResponse? get pinProtectionConfigs;
  SIPInboundRoutingRulePinConfigsResponse? get pinRoutingConfigs;
  List<String> get trunkIds;
  DateTime get updatedAt;

  /// Create a copy of SIPInboundRoutingRuleResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SIPInboundRoutingRuleResponseCopyWith<SIPInboundRoutingRuleResponse>
  get copyWith =>
      _$SIPInboundRoutingRuleResponseCopyWithImpl<
        SIPInboundRoutingRuleResponse
      >(this as SIPInboundRoutingRuleResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SIPInboundRoutingRuleResponse &&
            (identical(other.callConfigs, callConfigs) ||
                other.callConfigs == callConfigs) &&
            const DeepCollectionEquality().equals(
              other.calledNumbers,
              calledNumbers,
            ) &&
            (identical(other.callerConfigs, callerConfigs) ||
                other.callerConfigs == callerConfigs) &&
            const DeepCollectionEquality().equals(
              other.callerNumbers,
              callerNumbers,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.directRoutingConfigs, directRoutingConfigs) ||
                other.directRoutingConfigs == directRoutingConfigs) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.pinProtectionConfigs, pinProtectionConfigs) ||
                other.pinProtectionConfigs == pinProtectionConfigs) &&
            (identical(other.pinRoutingConfigs, pinRoutingConfigs) ||
                other.pinRoutingConfigs == pinRoutingConfigs) &&
            const DeepCollectionEquality().equals(other.trunkIds, trunkIds) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callConfigs,
    const DeepCollectionEquality().hash(calledNumbers),
    callerConfigs,
    const DeepCollectionEquality().hash(callerNumbers),
    createdAt,
    directRoutingConfigs,
    duration,
    id,
    name,
    pinProtectionConfigs,
    pinRoutingConfigs,
    const DeepCollectionEquality().hash(trunkIds),
    updatedAt,
  );

  @override
  String toString() {
    return 'SIPInboundRoutingRuleResponse(callConfigs: $callConfigs, calledNumbers: $calledNumbers, callerConfigs: $callerConfigs, callerNumbers: $callerNumbers, createdAt: $createdAt, directRoutingConfigs: $directRoutingConfigs, duration: $duration, id: $id, name: $name, pinProtectionConfigs: $pinProtectionConfigs, pinRoutingConfigs: $pinRoutingConfigs, trunkIds: $trunkIds, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $SIPInboundRoutingRuleResponseCopyWith<$Res> {
  factory $SIPInboundRoutingRuleResponseCopyWith(
    SIPInboundRoutingRuleResponse value,
    $Res Function(SIPInboundRoutingRuleResponse) _then,
  ) = _$SIPInboundRoutingRuleResponseCopyWithImpl;
  @useResult
  $Res call({
    SIPCallConfigsResponse? callConfigs,
    List<String> calledNumbers,
    SIPCallerConfigsResponse? callerConfigs,
    List<String>? callerNumbers,
    DateTime createdAt,
    SIPDirectRoutingRuleCallConfigsResponse? directRoutingConfigs,
    String duration,
    String id,
    String name,
    SIPPinProtectionConfigsResponse? pinProtectionConfigs,
    SIPInboundRoutingRulePinConfigsResponse? pinRoutingConfigs,
    List<String> trunkIds,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$SIPInboundRoutingRuleResponseCopyWithImpl<$Res>
    implements $SIPInboundRoutingRuleResponseCopyWith<$Res> {
  _$SIPInboundRoutingRuleResponseCopyWithImpl(this._self, this._then);

  final SIPInboundRoutingRuleResponse _self;
  final $Res Function(SIPInboundRoutingRuleResponse) _then;

  /// Create a copy of SIPInboundRoutingRuleResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callConfigs = freezed,
    Object? calledNumbers = null,
    Object? callerConfigs = freezed,
    Object? callerNumbers = freezed,
    Object? createdAt = null,
    Object? directRoutingConfigs = freezed,
    Object? duration = null,
    Object? id = null,
    Object? name = null,
    Object? pinProtectionConfigs = freezed,
    Object? pinRoutingConfigs = freezed,
    Object? trunkIds = null,
    Object? updatedAt = null,
  }) {
    return _then(
      SIPInboundRoutingRuleResponse(
        callConfigs: freezed == callConfigs
            ? _self.callConfigs
            : callConfigs // ignore: cast_nullable_to_non_nullable
                  as SIPCallConfigsResponse?,
        calledNumbers: null == calledNumbers
            ? _self.calledNumbers
            : calledNumbers // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        callerConfigs: freezed == callerConfigs
            ? _self.callerConfigs
            : callerConfigs // ignore: cast_nullable_to_non_nullable
                  as SIPCallerConfigsResponse?,
        callerNumbers: freezed == callerNumbers
            ? _self.callerNumbers
            : callerNumbers // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        directRoutingConfigs: freezed == directRoutingConfigs
            ? _self.directRoutingConfigs
            : directRoutingConfigs // ignore: cast_nullable_to_non_nullable
                  as SIPDirectRoutingRuleCallConfigsResponse?,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        pinProtectionConfigs: freezed == pinProtectionConfigs
            ? _self.pinProtectionConfigs
            : pinProtectionConfigs // ignore: cast_nullable_to_non_nullable
                  as SIPPinProtectionConfigsResponse?,
        pinRoutingConfigs: freezed == pinRoutingConfigs
            ? _self.pinRoutingConfigs
            : pinRoutingConfigs // ignore: cast_nullable_to_non_nullable
                  as SIPInboundRoutingRulePinConfigsResponse?,
        trunkIds: null == trunkIds
            ? _self.trunkIds
            : trunkIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}
