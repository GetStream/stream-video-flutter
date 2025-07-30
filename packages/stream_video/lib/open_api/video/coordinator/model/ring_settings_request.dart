//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ring_settings_request.g.dart';

/// RingSettingsRequest
///
/// Properties:
/// * [autoCancelTimeoutMs] - When none of the callees accept a ring call in this time a rejection will be sent by the caller with reason 'timeout' by the SDKs
/// * [incomingCallTimeoutMs] - When a callee is online but doesn't answer a ring call in this time a rejection will be sent with reason 'timeout' by the SDKs
/// * [missedCallTimeoutMs] - When a callee doesn't accept or reject a ring call in this time a missed call event will be sent
@BuiltValue()
abstract class RingSettingsRequest
    implements Built<RingSettingsRequest, RingSettingsRequestBuilder> {
  /// When none of the callees accept a ring call in this time a rejection will be sent by the caller with reason 'timeout' by the SDKs
  @BuiltValueField(wireName: r'auto_cancel_timeout_ms')
  int get autoCancelTimeoutMs;

  /// When a callee is online but doesn't answer a ring call in this time a rejection will be sent with reason 'timeout' by the SDKs
  @BuiltValueField(wireName: r'incoming_call_timeout_ms')
  int get incomingCallTimeoutMs;

  /// When a callee doesn't accept or reject a ring call in this time a missed call event will be sent
  @BuiltValueField(wireName: r'missed_call_timeout_ms')
  int? get missedCallTimeoutMs;

  RingSettingsRequest._();

  factory RingSettingsRequest([void updates(RingSettingsRequestBuilder b)]) =
      _$RingSettingsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RingSettingsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RingSettingsRequest> get serializer =>
      _$RingSettingsRequestSerializer();
}

class _$RingSettingsRequestSerializer
    implements PrimitiveSerializer<RingSettingsRequest> {
  @override
  final Iterable<Type> types = const [
    RingSettingsRequest,
    _$RingSettingsRequest
  ];

  @override
  final String wireName = r'RingSettingsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RingSettingsRequest object, {
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
    if (object.missedCallTimeoutMs != null) {
      yield r'missed_call_timeout_ms';
      yield serializers.serialize(
        object.missedCallTimeoutMs,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RingSettingsRequest object, {
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
    required RingSettingsRequestBuilder result,
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
  RingSettingsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RingSettingsRequestBuilder();
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
