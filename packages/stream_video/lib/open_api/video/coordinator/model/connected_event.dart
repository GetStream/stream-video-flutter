//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/own_user_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'connected_event.g.dart';

/// This event is sent when the WS connection is established and authenticated, this event contains the full user object as it is stored on the server
///
/// Properties:
/// * [connectionId] - The connection_id for this client
/// * [createdAt]
/// * [me]
/// * [type] - The type of event: \"connection.ok\" in this case
@BuiltValue()
abstract class ConnectedEvent
    implements Built<ConnectedEvent, ConnectedEventBuilder> {
  /// The connection_id for this client
  @BuiltValueField(wireName: r'connection_id')
  String get connectionId;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'me')
  OwnUserResponse get me;

  /// The type of event: \"connection.ok\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  ConnectedEvent._();

  factory ConnectedEvent([void updates(ConnectedEventBuilder b)]) =
      _$ConnectedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConnectedEventBuilder b) => b..type = 'connection.ok';

  @BuiltValueSerializer(custom: true)
  static Serializer<ConnectedEvent> get serializer =>
      _$ConnectedEventSerializer();
}

class _$ConnectedEventSerializer
    implements PrimitiveSerializer<ConnectedEvent> {
  @override
  final Iterable<Type> types = const [ConnectedEvent, _$ConnectedEvent];

  @override
  final String wireName = r'ConnectedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConnectedEvent object, {
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
    yield r'me';
    yield serializers.serialize(
      object.me,
      specifiedType: const FullType(OwnUserResponse),
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
    ConnectedEvent object, {
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
    required ConnectedEventBuilder result,
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
        case r'me':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OwnUserResponse),
          ) as OwnUserResponse;
          result.me.replace(valueDes);
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
  ConnectedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConnectedEventBuilder();
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
