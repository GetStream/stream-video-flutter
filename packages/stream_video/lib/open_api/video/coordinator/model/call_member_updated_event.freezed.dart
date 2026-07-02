// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_member_updated_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallMemberUpdatedEvent {
  CallResponse get call;
  String get callCid;
  DateTime get createdAt;
  List<MemberResponse> get members;
  String get type;

  /// Create a copy of CallMemberUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallMemberUpdatedEventCopyWith<CallMemberUpdatedEvent> get copyWith =>
      _$CallMemberUpdatedEventCopyWithImpl<CallMemberUpdatedEvent>(
        this as CallMemberUpdatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallMemberUpdatedEvent &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    call,
    callCid,
    createdAt,
    const DeepCollectionEquality().hash(members),
    type,
  );

  @override
  String toString() {
    return 'CallMemberUpdatedEvent(call: $call, callCid: $callCid, createdAt: $createdAt, members: $members, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallMemberUpdatedEventCopyWith<$Res> {
  factory $CallMemberUpdatedEventCopyWith(
    CallMemberUpdatedEvent value,
    $Res Function(CallMemberUpdatedEvent) _then,
  ) = _$CallMemberUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    CallResponse call,
    String callCid,
    DateTime createdAt,
    List<MemberResponse> members,
    String type,
  });
}

/// @nodoc
class _$CallMemberUpdatedEventCopyWithImpl<$Res>
    implements $CallMemberUpdatedEventCopyWith<$Res> {
  _$CallMemberUpdatedEventCopyWithImpl(this._self, this._then);

  final CallMemberUpdatedEvent _self;
  final $Res Function(CallMemberUpdatedEvent) _then;

  /// Create a copy of CallMemberUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? call = null,
    Object? callCid = null,
    Object? createdAt = null,
    Object? members = null,
    Object? type = null,
  }) {
    return _then(
      CallMemberUpdatedEvent(
        call: null == call
            ? _self.call
            : call // ignore: cast_nullable_to_non_nullable
                  as CallResponse,
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        members: null == members
            ? _self.members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<MemberResponse>,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
