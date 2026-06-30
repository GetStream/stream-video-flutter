// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_level_event_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallLevelEventPayload {
  String get eventType;
  Map<String, Object?>? get payload;
  int get timestamp;
  String get userId;

  /// Create a copy of CallLevelEventPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallLevelEventPayloadCopyWith<CallLevelEventPayload> get copyWith =>
      _$CallLevelEventPayloadCopyWithImpl<CallLevelEventPayload>(
        this as CallLevelEventPayload,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallLevelEventPayload &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            const DeepCollectionEquality().equals(other.payload, payload) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    eventType,
    const DeepCollectionEquality().hash(payload),
    timestamp,
    userId,
  );

  @override
  String toString() {
    return 'CallLevelEventPayload(eventType: $eventType, payload: $payload, timestamp: $timestamp, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $CallLevelEventPayloadCopyWith<$Res> {
  factory $CallLevelEventPayloadCopyWith(
    CallLevelEventPayload value,
    $Res Function(CallLevelEventPayload) _then,
  ) = _$CallLevelEventPayloadCopyWithImpl;
  @useResult
  $Res call({
    String eventType,
    Map<String, Object?>? payload,
    int timestamp,
    String userId,
  });
}

/// @nodoc
class _$CallLevelEventPayloadCopyWithImpl<$Res>
    implements $CallLevelEventPayloadCopyWith<$Res> {
  _$CallLevelEventPayloadCopyWithImpl(this._self, this._then);

  final CallLevelEventPayload _self;
  final $Res Function(CallLevelEventPayload) _then;

  /// Create a copy of CallLevelEventPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventType = null,
    Object? payload = freezed,
    Object? timestamp = null,
    Object? userId = null,
  }) {
    return _then(
      CallLevelEventPayload(
        eventType: null == eventType
            ? _self.eventType
            : eventType // ignore: cast_nullable_to_non_nullable
                  as String,
        payload: freezed == payload
            ? _self.payload
            : payload // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        timestamp: null == timestamp
            ? _self.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as int,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
