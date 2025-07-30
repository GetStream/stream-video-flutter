//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/call_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/user_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_rejected_event.g.dart';

/// This event is sent when a user rejects a notification to join a call.
///
/// Properties:
/// * [call]
/// * [callCid]
/// * [createdAt]
/// * [reason] - Provides information about why the call was rejected. You can provide any value, but the Stream API and SDKs use these default values: rejected, cancel, timeout and busy
/// * [type] - The type of event: \"call.rejected\" in this case
/// * [user]
@BuiltValue()
abstract class CallRejectedEvent
    implements Built<CallRejectedEvent, CallRejectedEventBuilder> {
  @BuiltValueField(wireName: r'call')
  CallResponse get call;

  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// Provides information about why the call was rejected. You can provide any value, but the Stream API and SDKs use these default values: rejected, cancel, timeout and busy
  @BuiltValueField(wireName: r'reason')
  String? get reason;

  /// The type of event: \"call.rejected\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  @BuiltValueField(wireName: r'user')
  UserResponse get user;

  CallRejectedEvent._();

  factory CallRejectedEvent([void updates(CallRejectedEventBuilder b)]) =
      _$CallRejectedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallRejectedEventBuilder b) =>
      b..type = 'call.rejected';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallRejectedEvent> get serializer =>
      _$CallRejectedEventSerializer();
}

class _$CallRejectedEventSerializer
    implements PrimitiveSerializer<CallRejectedEvent> {
  @override
  final Iterable<Type> types = const [CallRejectedEvent, _$CallRejectedEvent];

  @override
  final String wireName = r'CallRejectedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallRejectedEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'call';
    yield serializers.serialize(
      object.call,
      specifiedType: const FullType(CallResponse),
    );
    yield r'call_cid';
    yield serializers.serialize(
      object.callCid,
      specifiedType: const FullType(String),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(UserResponse),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CallRejectedEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CallRejectedEventBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'call':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CallResponse),
          ) as CallResponse;
          result.call.replace(valueDes);
          break;
        case r'call_cid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.callCid = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.type = valueDes;
          break;
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserResponse),
          ) as UserResponse;
          result.user.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CallRejectedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallRejectedEventBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}
