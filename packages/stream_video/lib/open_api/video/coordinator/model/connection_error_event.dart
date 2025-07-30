//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/api_error.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'connection_error_event.g.dart';

/// This event is sent when the WS connection fails
///
/// Properties:
/// * [connectionId]
/// * [createdAt]
/// * [error]
/// * [type] - The type of event: \"connection.ok\" in this case
@BuiltValue()
abstract class ConnectionErrorEvent
    implements Built<ConnectionErrorEvent, ConnectionErrorEventBuilder> {
  @BuiltValueField(wireName: r'connection_id')
  String get connectionId;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'error')
  APIError get error;

  /// The type of event: \"connection.ok\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  ConnectionErrorEvent._();

  factory ConnectionErrorEvent([void updates(ConnectionErrorEventBuilder b)]) =
      _$ConnectionErrorEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConnectionErrorEventBuilder b) =>
      b..type = 'connection.error';

  @BuiltValueSerializer(custom: true)
  static Serializer<ConnectionErrorEvent> get serializer =>
      _$ConnectionErrorEventSerializer();
}

class _$ConnectionErrorEventSerializer
    implements PrimitiveSerializer<ConnectionErrorEvent> {
  @override
  final Iterable<Type> types = const [
    ConnectionErrorEvent,
    _$ConnectionErrorEvent
  ];

  @override
  final String wireName = r'ConnectionErrorEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConnectionErrorEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'error';
    yield serializers.serialize(
      object.error,
      specifiedType: const FullType(APIError),
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
    ConnectionErrorEvent object, {
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
    required ConnectionErrorEventBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'error':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(APIError),
          ) as APIError;
          result.error.replace(valueDes);
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
  ConnectionErrorEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConnectionErrorEventBuilder();
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
