//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ring_settings_response.g.dart';

/// RingSettingsResponse
///
/// Properties:
/// * [autoCancelTimeoutMs]
/// * [incomingCallTimeoutMs]
/// * [missedCallTimeoutMs]
@BuiltValue()
abstract class RingSettingsResponse
    implements Built<RingSettingsResponse, RingSettingsResponseBuilder> {
  @BuiltValueField(wireName: r'auto_cancel_timeout_ms')
  int get autoCancelTimeoutMs;

  @BuiltValueField(wireName: r'incoming_call_timeout_ms')
  int get incomingCallTimeoutMs;

  @BuiltValueField(wireName: r'missed_call_timeout_ms')
  int get missedCallTimeoutMs;

  RingSettingsResponse._();

  factory RingSettingsResponse([void updates(RingSettingsResponseBuilder b)]) =
      _$RingSettingsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RingSettingsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RingSettingsResponse> get serializer =>
      _$RingSettingsResponseSerializer();
}

class _$RingSettingsResponseSerializer
    implements PrimitiveSerializer<RingSettingsResponse> {
  @override
  final Iterable<Type> types = const [
    RingSettingsResponse,
    _$RingSettingsResponse
  ];

  @override
  final String wireName = r'RingSettingsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RingSettingsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'auto_cancel_timeout_ms';
    yield serializers.serialize(
      object.autoCancelTimeoutMs,
      specifiedType: const FullType(int),
    );
    yield r'incoming_call_timeout_ms';
    yield serializers.serialize(
      object.incomingCallTimeoutMs,
      specifiedType: const FullType(int),
    );
    yield r'missed_call_timeout_ms';
    yield serializers.serialize(
      object.missedCallTimeoutMs,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RingSettingsResponse object, {
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
    required RingSettingsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'auto_cancel_timeout_ms':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.autoCancelTimeoutMs = valueDes;
          break;
        case r'incoming_call_timeout_ms':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.incomingCallTimeoutMs = valueDes;
          break;
        case r'missed_call_timeout_ms':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.missedCallTimeoutMs = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RingSettingsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RingSettingsResponseBuilder();
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
