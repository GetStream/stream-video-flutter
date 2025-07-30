//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'connect_user_details_request.g.dart';

/// ConnectUserDetailsRequest
///
/// Properties:
/// * [custom]
/// * [id]
/// * [image]
/// * [invisible]
/// * [language]
/// * [name]
/// * [privacySettings]
@BuiltValue()
abstract class ConnectUserDetailsRequest
    implements
        Built<ConnectUserDetailsRequest, ConnectUserDetailsRequestBuilder> {
  @BuiltValueField(wireName: r'custom')
  BuiltMap<String, JsonObject?>? get custom;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'image')
  String? get image;

  @BuiltValueField(wireName: r'invisible')
  bool? get invisible;

  @BuiltValueField(wireName: r'language')
  String? get language;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'privacy_settings')
  JsonObject? get privacySettings;

  ConnectUserDetailsRequest._();

  factory ConnectUserDetailsRequest(
          [void updates(ConnectUserDetailsRequestBuilder b)]) =
      _$ConnectUserDetailsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConnectUserDetailsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ConnectUserDetailsRequest> get serializer =>
      _$ConnectUserDetailsRequestSerializer();
}

class _$ConnectUserDetailsRequestSerializer
    implements PrimitiveSerializer<ConnectUserDetailsRequest> {
  @override
  final Iterable<Type> types = const [
    ConnectUserDetailsRequest,
    _$ConnectUserDetailsRequest
  ];

  @override
  final String wireName = r'ConnectUserDetailsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConnectUserDetailsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.custom != null) {
      yield r'custom';
      yield serializers.serialize(
        object.custom,
        specifiedType: const FullType(
            BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    if (object.image != null) {
      yield r'image';
      yield serializers.serialize(
        object.image,
        specifiedType: const FullType(String),
      );
    }
    if (object.invisible != null) {
      yield r'invisible';
      yield serializers.serialize(
        object.invisible,
        specifiedType: const FullType(bool),
      );
    }
    if (object.language != null) {
      yield r'language';
      yield serializers.serialize(
        object.language,
        specifiedType: const FullType(String),
      );
    }
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.privacySettings != null) {
      yield r'privacy_settings';
      yield serializers.serialize(
        object.privacySettings,
        specifiedType: const FullType(JsonObject),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ConnectUserDetailsRequest object, {
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
    required ConnectUserDetailsRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'custom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.custom.replace(valueDes);
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'image':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.image = valueDes;
          break;
        case r'invisible':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.invisible = valueDes;
          break;
        case r'language':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.language = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'privacy_settings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(JsonObject),
          ) as JsonObject;
          result.privacySettings = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ConnectUserDetailsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConnectUserDetailsRequestBuilder();
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
