//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'noise_cancellation_settings.g.dart';

/// NoiseCancellationSettings
///
/// Properties:
/// * [mode]
@BuiltValue()
abstract class NoiseCancellationSettings
    implements
        Built<NoiseCancellationSettings, NoiseCancellationSettingsBuilder> {
  @BuiltValueField(wireName: r'mode')
  NoiseCancellationSettingsModeEnum get mode;
  // enum modeEnum {  available,  disabled,  auto-on,  };

  NoiseCancellationSettings._();

  factory NoiseCancellationSettings(
          [void updates(NoiseCancellationSettingsBuilder b)]) =
      _$NoiseCancellationSettings;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NoiseCancellationSettingsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NoiseCancellationSettings> get serializer =>
      _$NoiseCancellationSettingsSerializer();
}

class _$NoiseCancellationSettingsSerializer
    implements PrimitiveSerializer<NoiseCancellationSettings> {
  @override
  final Iterable<Type> types = const [
    NoiseCancellationSettings,
    _$NoiseCancellationSettings
  ];

  @override
  final String wireName = r'NoiseCancellationSettings';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NoiseCancellationSettings object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'mode';
    yield serializers.serialize(
      object.mode,
      specifiedType: const FullType(NoiseCancellationSettingsModeEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    NoiseCancellationSettings object, {
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
    required NoiseCancellationSettingsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(NoiseCancellationSettingsModeEnum),
          ) as NoiseCancellationSettingsModeEnum;
          result.mode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NoiseCancellationSettings deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NoiseCancellationSettingsBuilder();
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

class NoiseCancellationSettingsModeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'available')
  static const NoiseCancellationSettingsModeEnum available =
      _$noiseCancellationSettingsModeEnum_available;
  @BuiltValueEnumConst(wireName: r'disabled')
  static const NoiseCancellationSettingsModeEnum disabled =
      _$noiseCancellationSettingsModeEnum_disabled;
  @BuiltValueEnumConst(wireName: r'auto-on')
  static const NoiseCancellationSettingsModeEnum autoOn =
      _$noiseCancellationSettingsModeEnum_autoOn;

  static Serializer<NoiseCancellationSettingsModeEnum> get serializer =>
      _$noiseCancellationSettingsModeEnumSerializer;

  const NoiseCancellationSettingsModeEnum._(String name) : super(name);

  static BuiltSet<NoiseCancellationSettingsModeEnum> get values =>
      _$noiseCancellationSettingsModeEnumValues;
  static NoiseCancellationSettingsModeEnum valueOf(String name) =>
      _$noiseCancellationSettingsModeEnumValueOf(name);
}
