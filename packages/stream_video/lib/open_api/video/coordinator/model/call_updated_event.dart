//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/call_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_updated_event.g.dart';

/// This event is sent when a call is updated, clients should use this update the local state of the call. This event also contains the capabilities by role for the call, clients should update the own_capability for the current.
///
/// Properties:
/// * [call]
/// * [callCid]
/// * [capabilitiesByRole] - The capabilities by role for this call
/// * [createdAt]
/// * [type] - The type of event: \"call.ended\" in this case
@BuiltValue()
abstract class CallUpdatedEvent
    implements Built<CallUpdatedEvent, CallUpdatedEventBuilder> {
  @BuiltValueField(wireName: r'call')
  CallResponse get call;

  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  /// The capabilities by role for this call
  @BuiltValueField(wireName: r'capabilities_by_role')
  BuiltMap<String, BuiltList<String>> get capabilitiesByRole;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// The type of event: \"call.ended\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  CallUpdatedEvent._();

  factory CallUpdatedEvent([void updates(CallUpdatedEventBuilder b)]) =
      _$CallUpdatedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallUpdatedEventBuilder b) => b..type = 'call.updated';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallUpdatedEvent> get serializer =>
      _$CallUpdatedEventSerializer();
}

class _$CallUpdatedEventSerializer
    implements PrimitiveSerializer<CallUpdatedEvent> {
  @override
  final Iterable<Type> types = const [CallUpdatedEvent, _$CallUpdatedEvent];

  @override
  final String wireName = r'CallUpdatedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallUpdatedEvent object, {
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
    yield r'capabilities_by_role';
    yield serializers.serialize(
      object.capabilitiesByRole,
      specifiedType: const FullType(BuiltMap, [
        FullType(String),
        FullType(BuiltList, [FullType(String)])
      ]),
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
    CallUpdatedEvent object, {
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
    required CallUpdatedEventBuilder result,
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
        case r'capabilities_by_role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [
              FullType(String),
              FullType(BuiltList, [FullType(String)])
            ]),
          ) as BuiltMap<String, BuiltList<String>>;
          result.capabilitiesByRole.replace(valueDes);
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
  CallUpdatedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallUpdatedEventBuilder();
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
