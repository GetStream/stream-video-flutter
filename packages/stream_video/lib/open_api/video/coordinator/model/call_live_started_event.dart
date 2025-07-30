//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/call_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_live_started_event.g.dart';

/// This event is sent when a call is started. Clients receiving this event should start the call.
///
/// Properties:
/// * [call]
/// * [callCid]
/// * [createdAt]
/// * [type] - The type of event: \"call.live_started\" in this case
@BuiltValue()
abstract class CallLiveStartedEvent
    implements Built<CallLiveStartedEvent, CallLiveStartedEventBuilder> {
  @BuiltValueField(wireName: r'call')
  CallResponse get call;

  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// The type of event: \"call.live_started\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  CallLiveStartedEvent._();

  factory CallLiveStartedEvent([void updates(CallLiveStartedEventBuilder b)]) =
      _$CallLiveStartedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallLiveStartedEventBuilder b) =>
      b..type = 'call.live_started';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallLiveStartedEvent> get serializer =>
      _$CallLiveStartedEventSerializer();
}

class _$CallLiveStartedEventSerializer
    implements PrimitiveSerializer<CallLiveStartedEvent> {
  @override
  final Iterable<Type> types = const [
    CallLiveStartedEvent,
    _$CallLiveStartedEvent
  ];

  @override
  final String wireName = r'CallLiveStartedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallLiveStartedEvent object, {
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
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CallLiveStartedEvent object, {
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
    required CallLiveStartedEventBuilder result,
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
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.type = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CallLiveStartedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallLiveStartedEventBuilder();
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
