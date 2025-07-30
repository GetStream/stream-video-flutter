//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'record_settings_response.g.dart';

/// RecordSettings is the payload for recording settings
///
/// Properties:
/// * [audioOnly]
/// * [mode]
/// * [quality]
@BuiltValue()
abstract class RecordSettingsResponse
    implements Built<RecordSettingsResponse, RecordSettingsResponseBuilder> {
  @BuiltValueField(wireName: r'audio_only')
  bool get audioOnly;

  @BuiltValueField(wireName: r'mode')
  String get mode;

  @BuiltValueField(wireName: r'quality')
  String get quality;

  RecordSettingsResponse._();

  factory RecordSettingsResponse(
          [void updates(RecordSettingsResponseBuilder b)]) =
      _$RecordSettingsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecordSettingsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecordSettingsResponse> get serializer =>
      _$RecordSettingsResponseSerializer();
}

class _$RecordSettingsResponseSerializer
    implements PrimitiveSerializer<RecordSettingsResponse> {
  @override
  final Iterable<Type> types = const [
    RecordSettingsResponse,
    _$RecordSettingsResponse
  ];

  @override
  final String wireName = r'RecordSettingsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecordSettingsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'audio_only';
    yield serializers.serialize(
      object.audioOnly,
      specifiedType: const FullType(bool),
    );
    yield r'mode';
    yield serializers.serialize(
      object.mode,
      specifiedType: const FullType(String),
    );
    yield r'quality';
    yield serializers.serialize(
      object.quality,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RecordSettingsResponse object, {
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
    required RecordSettingsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'audio_only':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.audioOnly = valueDes;
          break;
        case r'mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mode = valueDes;
          break;
        case r'quality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.quality = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecordSettingsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecordSettingsResponseBuilder();
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
