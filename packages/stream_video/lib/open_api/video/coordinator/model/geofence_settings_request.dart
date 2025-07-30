//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geofence_settings_request.g.dart';

/// GeofenceSettingsRequest
///
/// Properties:
/// * [names]
@BuiltValue()
abstract class GeofenceSettingsRequest
    implements Built<GeofenceSettingsRequest, GeofenceSettingsRequestBuilder> {
  @BuiltValueField(wireName: r'names')
  BuiltList<String>? get names;

  GeofenceSettingsRequest._();

  factory GeofenceSettingsRequest(
          [void updates(GeofenceSettingsRequestBuilder b)]) =
      _$GeofenceSettingsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeofenceSettingsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeofenceSettingsRequest> get serializer =>
      _$GeofenceSettingsRequestSerializer();
}

class _$GeofenceSettingsRequestSerializer
    implements PrimitiveSerializer<GeofenceSettingsRequest> {
  @override
  final Iterable<Type> types = const [
    GeofenceSettingsRequest,
    _$GeofenceSettingsRequest
  ];

  @override
  final String wireName = r'GeofenceSettingsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeofenceSettingsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.names != null) {
      yield r'names';
      yield serializers.serialize(
        object.names,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GeofenceSettingsRequest object, {
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
    required GeofenceSettingsRequestBuilder result,
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
  GeofenceSettingsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeofenceSettingsRequestBuilder();
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
