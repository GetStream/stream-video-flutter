//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/app_event_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'app_updated_event.g.dart';

/// Emitted when app settings are updated
///
/// Properties:
/// * [app]
/// * [createdAt] - Date/time of creation
/// * [custom]
/// * [receivedAt]
/// * [type] - The type of event: \"app.updated\" in this case
@BuiltValue()
abstract class AppUpdatedEvent
    implements Built<AppUpdatedEvent, AppUpdatedEventBuilder> {
  @BuiltValueField(wireName: r'app')
  AppEventResponse get app;

  /// Date/time of creation
  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'custom')
  BuiltMap<String, JsonObject?> get custom;

  @BuiltValueField(wireName: r'received_at')
  DateTime? get receivedAt;

  /// The type of event: \"app.updated\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  AppUpdatedEvent._();

  factory AppUpdatedEvent([void updates(AppUpdatedEventBuilder b)]) =
      _$AppUpdatedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AppUpdatedEventBuilder b) => b..type = 'app.updated';

  @BuiltValueSerializer(custom: true)
  static Serializer<AppUpdatedEvent> get serializer =>
      _$AppUpdatedEventSerializer();
}

class _$AppUpdatedEventSerializer
    implements PrimitiveSerializer<AppUpdatedEvent> {
  @override
  final Iterable<Type> types = const [AppUpdatedEvent, _$AppUpdatedEvent];

  @override
  final String wireName = r'AppUpdatedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AppUpdatedEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'app';
    yield serializers.serialize(
      object.app,
      specifiedType: const FullType(AppEventResponse),
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
    AppUpdatedEvent object, {
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
    required AppUpdatedEventBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'app':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AppEventResponse),
          ) as AppEventResponse;
          result.app.replace(valueDes);
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
  AppUpdatedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AppUpdatedEventBuilder();
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
