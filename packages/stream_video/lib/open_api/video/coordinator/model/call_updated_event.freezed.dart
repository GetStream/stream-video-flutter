// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_updated_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallUpdatedEvent {
  CallResponse get call;
  String get callCid;
  Map<String, List<String>> get capabilitiesByRole;
  DateTime get createdAt;
  String get type;

  /// Create a copy of CallUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallUpdatedEventCopyWith<CallUpdatedEvent> get copyWith =>
      _$CallUpdatedEventCopyWithImpl<CallUpdatedEvent>(
        this as CallUpdatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallUpdatedEvent &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            const DeepCollectionEquality().equals(
              other.capabilitiesByRole,
              capabilitiesByRole,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    call,
    callCid,
    const DeepCollectionEquality().hash(capabilitiesByRole),
    createdAt,
    type,
  );

  @override
  String toString() {
    return 'CallUpdatedEvent(call: $call, callCid: $callCid, capabilitiesByRole: $capabilitiesByRole, createdAt: $createdAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallUpdatedEventCopyWith<$Res> {
  factory $CallUpdatedEventCopyWith(
    CallUpdatedEvent value,
    $Res Function(CallUpdatedEvent) _then,
  ) = _$CallUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    CallResponse call,
    String callCid,
    Map<String, List<String>> capabilitiesByRole,
    DateTime createdAt,
    String type,
  });
}

/// @nodoc
class _$CallUpdatedEventCopyWithImpl<$Res>
    implements $CallUpdatedEventCopyWith<$Res> {
  _$CallUpdatedEventCopyWithImpl(this._self, this._then);

  final CallUpdatedEvent _self;
  final $Res Function(CallUpdatedEvent) _then;

  /// Create a copy of CallUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? call = null,
    Object? callCid = null,
    Object? capabilitiesByRole = null,
    Object? createdAt = null,
    Object? type = null,
  }) {
    return _then(
      CallUpdatedEvent(
        call: null == call
            ? _self.call
            : call // ignore: cast_nullable_to_non_nullable
                  as CallResponse,
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        capabilitiesByRole: null == capabilitiesByRole
            ? _self.capabilitiesByRole
            : capabilitiesByRole // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<String>>,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
