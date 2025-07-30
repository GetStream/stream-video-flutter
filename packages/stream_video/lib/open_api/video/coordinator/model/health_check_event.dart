//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'health_check_event.g.dart';

/// HealthCheckEvent
///
/// Properties:
/// * [cid]
/// * [connectionId]
/// * [createdAt]
/// * [custom]
/// * [receivedAt]
/// * [type]
@BuiltValue()
abstract class HealthCheckEvent
    implements Built<HealthCheckEvent, HealthCheckEventBuilder> {
  @BuiltValueField(wireName: r'cid')
  String? get cid;

  @BuiltValueField(wireName: r'connection_id')
  String get connectionId;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'custom')
  BuiltMap<String, JsonObject?> get custom;

  @BuiltValueField(wireName: r'received_at')
  DateTime? get receivedAt;

  @BuiltValueField(wireName: r'type')
  String get type;

  HealthCheckEvent._();

  factory HealthCheckEvent([void updates(HealthCheckEventBuilder b)]) =
      _$HealthCheckEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(HealthCheckEventBuilder b) => b..type = 'health.check';

  @BuiltValueSerializer(custom: true)
  static Serializer<HealthCheckEvent> get serializer =>
      _$HealthCheckEventSerializer();
}

class _$HealthCheckEventSerializer
    implements PrimitiveSerializer<HealthCheckEvent> {
  @override
  final Iterable<Type> types = const [HealthCheckEvent, _$HealthCheckEvent];

  @override
  final String wireName = r'HealthCheckEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    HealthCheckEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.cid != null) {
      yield r'cid';
      yield serializers.serialize(
        object.cid,
        specifiedType: const FullType(String),
      );
    }
    yield r'connection_id';
    yield serializers.serialize(
      object.connectionId,
      specifiedType: const FullType(String),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'custom';
    yield serializers.serialize(
      object.custom,
      specifiedType: const FullType(
          BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    if (object.receivedAt != null) {
      yield r'received_at';
      yield serializers.serialize(
        object.receivedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    HealthCheckEvent object, {
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
    required HealthCheckEventBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.cid = valueDes;
          break;
        case r'connection_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.connectionId = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'custom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.custom.replace(valueDes);
          break;
        case r'received_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.receivedAt = valueDes;
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
  HealthCheckEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = HealthCheckEventBuilder();
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
