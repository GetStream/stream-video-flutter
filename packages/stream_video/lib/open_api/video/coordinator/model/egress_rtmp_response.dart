//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'egress_rtmp_response.g.dart';

/// EgressRTMPResponse
///
/// Properties:
/// * [name]
/// * [startedAt]
/// * [streamKey]
/// * [streamUrl]
@BuiltValue()
abstract class EgressRTMPResponse
    implements Built<EgressRTMPResponse, EgressRTMPResponseBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'started_at')
  DateTime get startedAt;

  @BuiltValueField(wireName: r'stream_key')
  String? get streamKey;

  @BuiltValueField(wireName: r'stream_url')
  String? get streamUrl;

  EgressRTMPResponse._();

  factory EgressRTMPResponse([void updates(EgressRTMPResponseBuilder b)]) =
      _$EgressRTMPResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EgressRTMPResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EgressRTMPResponse> get serializer =>
      _$EgressRTMPResponseSerializer();
}

class _$EgressRTMPResponseSerializer
    implements PrimitiveSerializer<EgressRTMPResponse> {
  @override
  final Iterable<Type> types = const [EgressRTMPResponse, _$EgressRTMPResponse];

  @override
  final String wireName = r'EgressRTMPResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EgressRTMPResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'started_at';
    yield serializers.serialize(
      object.startedAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.streamKey != null) {
      yield r'stream_key';
      yield serializers.serialize(
        object.streamKey,
        specifiedType: const FullType(String),
      );
    }
    if (object.streamUrl != null) {
      yield r'stream_url';
      yield serializers.serialize(
        object.streamUrl,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    EgressRTMPResponse object, {
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
    required EgressRTMPResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'started_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startedAt = valueDes;
          break;
        case r'stream_key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.streamKey = valueDes;
          break;
        case r'stream_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.streamUrl = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EgressRTMPResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EgressRTMPResponseBuilder();
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
