//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_device_request.g.dart';

/// Create device request
///
/// Properties:
/// * [id] - Device ID
/// * [pushProvider] - Push provider
/// * [pushProviderName] - Push provider name
/// * [voipToken] - When true the token is for Apple VoIP push notifications
@BuiltValue()
abstract class CreateDeviceRequest
    implements Built<CreateDeviceRequest, CreateDeviceRequestBuilder> {
  /// Device ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Push provider
  @BuiltValueField(wireName: r'push_provider')
  CreateDeviceRequestPushProviderEnum get pushProvider;
  // enum pushProviderEnum {  firebase,  apn,  huawei,  xiaomi,  };

  /// Push provider name
  @BuiltValueField(wireName: r'push_provider_name')
  String? get pushProviderName;

  /// When true the token is for Apple VoIP push notifications
  @BuiltValueField(wireName: r'voip_token')
  bool? get voipToken;

  CreateDeviceRequest._();

  factory CreateDeviceRequest([void updates(CreateDeviceRequestBuilder b)]) =
      _$CreateDeviceRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateDeviceRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateDeviceRequest> get serializer =>
      _$CreateDeviceRequestSerializer();
}

class _$CreateDeviceRequestSerializer
    implements PrimitiveSerializer<CreateDeviceRequest> {
  @override
  final Iterable<Type> types = const [
    CreateDeviceRequest,
    _$CreateDeviceRequest
  ];

  @override
  final String wireName = r'CreateDeviceRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateDeviceRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'push_provider';
    yield serializers.serialize(
      object.pushProvider,
      specifiedType: const FullType(CreateDeviceRequestPushProviderEnum),
    );
    if (object.pushProviderName != null) {
      yield r'push_provider_name';
      yield serializers.serialize(
        object.pushProviderName,
        specifiedType: const FullType(String),
      );
    }
    if (object.voipToken != null) {
      yield r'voip_token';
      yield serializers.serialize(
        object.voipToken,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateDeviceRequest object, {
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
    required CreateDeviceRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'push_provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreateDeviceRequestPushProviderEnum),
          ) as CreateDeviceRequestPushProviderEnum;
          result.pushProvider = valueDes;
          break;
        case r'push_provider_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.pushProviderName = valueDes;
          break;
        case r'voip_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.voipToken = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateDeviceRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateDeviceRequestBuilder();
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

class CreateDeviceRequestPushProviderEnum extends EnumClass {
  /// Push provider
  @BuiltValueEnumConst(wireName: r'firebase')
  static const CreateDeviceRequestPushProviderEnum firebase =
      _$createDeviceRequestPushProviderEnum_firebase;

  /// Push provider
  @BuiltValueEnumConst(wireName: r'apn')
  static const CreateDeviceRequestPushProviderEnum apn =
      _$createDeviceRequestPushProviderEnum_apn;

  /// Push provider
  @BuiltValueEnumConst(wireName: r'huawei')
  static const CreateDeviceRequestPushProviderEnum huawei =
      _$createDeviceRequestPushProviderEnum_huawei;

  /// Push provider
  @BuiltValueEnumConst(wireName: r'xiaomi')
  static const CreateDeviceRequestPushProviderEnum xiaomi =
      _$createDeviceRequestPushProviderEnum_xiaomi;

  static Serializer<CreateDeviceRequestPushProviderEnum> get serializer =>
      _$createDeviceRequestPushProviderEnumSerializer;

  const CreateDeviceRequestPushProviderEnum._(String name) : super(name);

  static BuiltSet<CreateDeviceRequestPushProviderEnum> get values =>
      _$createDeviceRequestPushProviderEnumValues;
  static CreateDeviceRequestPushProviderEnum valueOf(String name) =>
      _$createDeviceRequestPushProviderEnumValueOf(name);
}
