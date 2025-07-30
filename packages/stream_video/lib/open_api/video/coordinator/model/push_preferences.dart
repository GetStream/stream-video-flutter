//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'push_preferences.g.dart';

/// PushPreferences
///
/// Properties:
/// * [callLevel]
/// * [chatLevel]
/// * [disabledUntil]
@BuiltValue()
abstract class PushPreferences
    implements Built<PushPreferences, PushPreferencesBuilder> {
  @BuiltValueField(wireName: r'call_level')
  String? get callLevel;

  @BuiltValueField(wireName: r'chat_level')
  String? get chatLevel;

  @BuiltValueField(wireName: r'disabled_until')
  DateTime? get disabledUntil;

  PushPreferences._();

  factory PushPreferences([void updates(PushPreferencesBuilder b)]) =
      _$PushPreferences;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PushPreferencesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PushPreferences> get serializer =>
      _$PushPreferencesSerializer();
}

class _$PushPreferencesSerializer
    implements PrimitiveSerializer<PushPreferences> {
  @override
  final Iterable<Type> types = const [PushPreferences, _$PushPreferences];

  @override
  final String wireName = r'PushPreferences';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PushPreferences object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.callLevel != null) {
      yield r'call_level';
      yield serializers.serialize(
        object.callLevel,
        specifiedType: const FullType(String),
      );
    }
    if (object.chatLevel != null) {
      yield r'chat_level';
      yield serializers.serialize(
        object.chatLevel,
        specifiedType: const FullType(String),
      );
    }
    if (object.disabledUntil != null) {
      yield r'disabled_until';
      yield serializers.serialize(
        object.disabledUntil,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PushPreferences object, {
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
    required PushPreferencesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'call_level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.callLevel = valueDes;
          break;
        case r'chat_level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.chatLevel = valueDes;
          break;
        case r'disabled_until':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.disabledUntil = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PushPreferences deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PushPreferencesBuilder();
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
