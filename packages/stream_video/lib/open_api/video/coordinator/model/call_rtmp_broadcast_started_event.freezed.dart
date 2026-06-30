// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_rtmp_broadcast_started_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallRtmpBroadcastStartedEvent {
  String get callCid;
  DateTime get createdAt;
  String get name;
  String get type;

  /// Create a copy of CallRtmpBroadcastStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallRtmpBroadcastStartedEventCopyWith<CallRtmpBroadcastStartedEvent>
  get copyWith =>
      _$CallRtmpBroadcastStartedEventCopyWithImpl<
        CallRtmpBroadcastStartedEvent
      >(this as CallRtmpBroadcastStartedEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallRtmpBroadcastStartedEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, callCid, createdAt, name, type);

  @override
  String toString() {
    return 'CallRtmpBroadcastStartedEvent(callCid: $callCid, createdAt: $createdAt, name: $name, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallRtmpBroadcastStartedEventCopyWith<$Res> {
  factory $CallRtmpBroadcastStartedEventCopyWith(
    CallRtmpBroadcastStartedEvent value,
    $Res Function(CallRtmpBroadcastStartedEvent) _then,
  ) = _$CallRtmpBroadcastStartedEventCopyWithImpl;
  @useResult
  $Res call({String callCid, DateTime createdAt, String name, String type});
}

/// @nodoc
class _$CallRtmpBroadcastStartedEventCopyWithImpl<$Res>
    implements $CallRtmpBroadcastStartedEventCopyWith<$Res> {
  _$CallRtmpBroadcastStartedEventCopyWithImpl(this._self, this._then);

  final CallRtmpBroadcastStartedEvent _self;
  final $Res Function(CallRtmpBroadcastStartedEvent) _then;

  /// Create a copy of CallRtmpBroadcastStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? name = null,
    Object? type = null,
  }) {
    return _then(
      CallRtmpBroadcastStartedEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
