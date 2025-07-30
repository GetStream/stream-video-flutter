//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/typing_indicators.dart';
import 'package:stream_video/open_api/video/coordinator/model/read_receipts.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'privacy_settings.g.dart';

/// PrivacySettings
///
/// Properties:
/// * [readReceipts]
/// * [typingIndicators]
@BuiltValue()
abstract class PrivacySettings
    implements Built<PrivacySettings, PrivacySettingsBuilder> {
  @BuiltValueField(wireName: r'read_receipts')
  ReadReceipts? get readReceipts;

  @BuiltValueField(wireName: r'typing_indicators')
  TypingIndicators? get typingIndicators;

  PrivacySettings._();

  factory PrivacySettings([void updates(PrivacySettingsBuilder b)]) =
      _$PrivacySettings;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PrivacySettingsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PrivacySettings> get serializer =>
      _$PrivacySettingsSerializer();
}

class _$PrivacySettingsSerializer
    implements PrimitiveSerializer<PrivacySettings> {
  @override
  final Iterable<Type> types = const [PrivacySettings, _$PrivacySettings];

  @override
  final String wireName = r'PrivacySettings';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PrivacySettings object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.readReceipts != null) {
      yield r'read_receipts';
      yield serializers.serialize(
        object.readReceipts,
        specifiedType: const FullType(ReadReceipts),
      );
    }
    if (object.typingIndicators != null) {
      yield r'typing_indicators';
      yield serializers.serialize(
        object.typingIndicators,
        specifiedType: const FullType(TypingIndicators),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PrivacySettings object, {
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
    required PrivacySettingsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'read_receipts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReadReceipts),
          ) as ReadReceipts;
          result.readReceipts.replace(valueDes);
          break;
        case r'typing_indicators':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TypingIndicators),
          ) as TypingIndicators;
          result.typingIndicators.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PrivacySettings deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PrivacySettingsBuilder();
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
