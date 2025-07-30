//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_user_muted_event.g.dart';

/// This event is sent when a call member is muted
///
/// Properties:
/// * [callCid]
/// * [createdAt]
/// * [fromUserId]
/// * [mutedUserIds]
/// * [type] - The type of event: \"call.user_muted\" in this case
@BuiltValue()
abstract class CallUserMutedEvent
    implements Built<CallUserMutedEvent, CallUserMutedEventBuilder> {
  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'from_user_id')
  String get fromUserId;

  @BuiltValueField(wireName: r'muted_user_ids')
  BuiltList<String> get mutedUserIds;

  /// The type of event: \"call.user_muted\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  CallUserMutedEvent._();

  factory CallUserMutedEvent([void updates(CallUserMutedEventBuilder b)]) =
      _$CallUserMutedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallUserMutedEventBuilder b) =>
      b..type = 'call.user_muted';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallUserMutedEvent> get serializer =>
      _$CallUserMutedEventSerializer();
}

class _$CallUserMutedEventSerializer
    implements PrimitiveSerializer<CallUserMutedEvent> {
  @override
  final Iterable<Type> types = const [CallUserMutedEvent, _$CallUserMutedEvent];

  @override
  final String wireName = r'CallUserMutedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallUserMutedEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'from_user_id';
    yield serializers.serialize(
      object.fromUserId,
      specifiedType: const FullType(String),
    );
    yield r'muted_user_ids';
    yield serializers.serialize(
      object.mutedUserIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
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
    CallUserMutedEvent object, {
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
    required CallUserMutedEventBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'from_user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fromUserId = valueDes;
          break;
        case r'muted_user_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.mutedUserIds.replace(valueDes);
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
  CallUserMutedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallUserMutedEventBuilder();
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
