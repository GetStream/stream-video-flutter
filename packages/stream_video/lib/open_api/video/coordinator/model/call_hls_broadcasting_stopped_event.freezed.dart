// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_hls_broadcasting_stopped_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallHLSBroadcastingStoppedEvent {
  String get callCid;
  DateTime get createdAt;
  String get type;

  /// Create a copy of CallHLSBroadcastingStoppedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallHLSBroadcastingStoppedEventCopyWith<CallHLSBroadcastingStoppedEvent>
  get copyWith =>
      _$CallHLSBroadcastingStoppedEventCopyWithImpl<
        CallHLSBroadcastingStoppedEvent
      >(this as CallHLSBroadcastingStoppedEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallHLSBroadcastingStoppedEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, callCid, createdAt, type);

  @override
  String toString() {
    return 'CallHLSBroadcastingStoppedEvent(callCid: $callCid, createdAt: $createdAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallHLSBroadcastingStoppedEventCopyWith<$Res> {
  factory $CallHLSBroadcastingStoppedEventCopyWith(
    CallHLSBroadcastingStoppedEvent value,
    $Res Function(CallHLSBroadcastingStoppedEvent) _then,
  ) = _$CallHLSBroadcastingStoppedEventCopyWithImpl;
  @useResult
  $Res call({String callCid, DateTime createdAt, String type});
}

/// @nodoc
class _$CallHLSBroadcastingStoppedEventCopyWithImpl<$Res>
    implements $CallHLSBroadcastingStoppedEventCopyWith<$Res> {
  _$CallHLSBroadcastingStoppedEventCopyWithImpl(this._self, this._then);

  final CallHLSBroadcastingStoppedEvent _self;
  final $Res Function(CallHLSBroadcastingStoppedEvent) _then;

  /// Create a copy of CallHLSBroadcastingStoppedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? type = null,
  }) {
    return _then(
      CallHLSBroadcastingStoppedEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
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
