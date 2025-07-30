//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geofence_settings_response.g.dart';

/// GeofenceSettingsResponse
///
/// Properties:
/// * [names]
@BuiltValue()
abstract class GeofenceSettingsResponse
    implements
        Built<GeofenceSettingsResponse, GeofenceSettingsResponseBuilder> {
  @BuiltValueField(wireName: r'names')
  BuiltList<String> get names;

  GeofenceSettingsResponse._();

  factory GeofenceSettingsResponse(
          [void updates(GeofenceSettingsResponseBuilder b)]) =
      _$GeofenceSettingsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeofenceSettingsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeofenceSettingsResponse> get serializer =>
      _$GeofenceSettingsResponseSerializer();
}

class _$GeofenceSettingsResponseSerializer
    implements PrimitiveSerializer<GeofenceSettingsResponse> {
  @override
  final Iterable<Type> types = const [
    GeofenceSettingsResponse,
    _$GeofenceSettingsResponse
  ];

  @override
  final String wireName = r'GeofenceSettingsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeofenceSettingsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'names';
    yield serializers.serialize(
      object.names,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GeofenceSettingsResponse object, {
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
    required GeofenceSettingsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'names':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.names.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeofenceSettingsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeofenceSettingsResponseBuilder();
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
