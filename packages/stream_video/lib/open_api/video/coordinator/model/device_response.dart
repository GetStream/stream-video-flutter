//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'device_response.g.dart';

/// Response for Device
///
/// Properties:
/// * [createdAt] - Date/time of creation
/// * [disabled] - Whether device is disabled or not
/// * [disabledReason] - Reason explaining why device had been disabled
/// * [id] - Device ID
/// * [pushProvider] - Push provider
/// * [pushProviderName] - Push provider name
/// * [userId] - User ID
/// * [voip] - When true the token is for Apple VoIP push notifications
@BuiltValue()
abstract class DeviceResponse
    implements Built<DeviceResponse, DeviceResponseBuilder> {
  /// Date/time of creation
  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// Whether device is disabled or not
  @BuiltValueField(wireName: r'disabled')
  bool? get disabled;

  /// Reason explaining why device had been disabled
  @BuiltValueField(wireName: r'disabled_reason')
  String? get disabledReason;

  /// Device ID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Push provider
  @BuiltValueField(wireName: r'push_provider')
  String get pushProvider;

  /// Push provider name
  @BuiltValueField(wireName: r'push_provider_name')
  String? get pushProviderName;

  /// User ID
  @BuiltValueField(wireName: r'user_id')
  String get userId;

  /// When true the token is for Apple VoIP push notifications
  @BuiltValueField(wireName: r'voip')
  bool? get voip;

  DeviceResponse._();

  factory DeviceResponse([void updates(DeviceResponseBuilder b)]) =
      _$DeviceResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeviceResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeviceResponse> get serializer =>
      _$DeviceResponseSerializer();
}

class _$DeviceResponseSerializer
    implements PrimitiveSerializer<DeviceResponse> {
  @override
  final Iterable<Type> types = const [DeviceResponse, _$DeviceResponse];

  @override
  final String wireName = r'DeviceResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeviceResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.disabled != null) {
      yield r'disabled';
      yield serializers.serialize(
        object.disabled,
        specifiedType: const FullType(bool),
      );
    }
    if (object.disabledReason != null) {
      yield r'disabled_reason';
      yield serializers.serialize(
        object.disabledReason,
        specifiedType: const FullType(String),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'push_provider';
    yield serializers.serialize(
      object.pushProvider,
      specifiedType: const FullType(String),
    );
    if (object.pushProviderName != null) {
      yield r'push_provider_name';
      yield serializers.serialize(
        object.pushProviderName,
        specifiedType: const FullType(String),
      );
    }
    yield r'user_id';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
    if (object.voip != null) {
      yield r'voip';
      yield serializers.serialize(
        object.voip,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DeviceResponse object, {
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
    required DeviceResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'disabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.disabled = valueDes;
          break;
        case r'disabled_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.disabledReason = valueDes;
          break;
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
            specifiedType: const FullType(String),
          ) as String;
          result.pushProvider = valueDes;
          break;
        case r'push_provider_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.pushProviderName = valueDes;
          break;
        case r'user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userId = valueDes;
          break;
        case r'voip':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.voip = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeviceResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeviceResponseBuilder();
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
