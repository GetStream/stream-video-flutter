// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_reaction_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallReactionEvent {
  String get callCid;
  DateTime get createdAt;
  VideoReactionResponse get reaction;
  String get type;

  /// Create a copy of CallReactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallReactionEventCopyWith<CallReactionEvent> get copyWith =>
      _$CallReactionEventCopyWithImpl<CallReactionEvent>(
        this as CallReactionEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallReactionEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.reaction, reaction) ||
                other.reaction == reaction) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, callCid, createdAt, reaction, type);

  @override
  String toString() {
    return 'CallReactionEvent(callCid: $callCid, createdAt: $createdAt, reaction: $reaction, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallReactionEventCopyWith<$Res> {
  factory $CallReactionEventCopyWith(
    CallReactionEvent value,
    $Res Function(CallReactionEvent) _then,
  ) = _$CallReactionEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime createdAt,
    VideoReactionResponse reaction,
    String type,
  });
}

/// @nodoc
class _$CallReactionEventCopyWithImpl<$Res>
    implements $CallReactionEventCopyWith<$Res> {
  _$CallReactionEventCopyWithImpl(this._self, this._then);

  final CallReactionEvent _self;
  final $Res Function(CallReactionEvent) _then;

  /// Create a copy of CallReactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? reaction = null,
    Object? type = null,
  }) {
    return _then(
      CallReactionEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        reaction: null == reaction
            ? _self.reaction
            : reaction // ignore: cast_nullable_to_non_nullable
                  as VideoReactionResponse,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
