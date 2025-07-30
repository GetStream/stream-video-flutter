//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sfu_response.g.dart';

/// SFUResponse
///
/// Properties:
/// * [edgeName]
/// * [url]
/// * [wsEndpoint]
@BuiltValue()
abstract class SFUResponse implements Built<SFUResponse, SFUResponseBuilder> {
  @BuiltValueField(wireName: r'edge_name')
  String get edgeName;

  @BuiltValueField(wireName: r'url')
  String get url;

  @BuiltValueField(wireName: r'ws_endpoint')
  String get wsEndpoint;

  SFUResponse._();

  factory SFUResponse([void updates(SFUResponseBuilder b)]) = _$SFUResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SFUResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SFUResponse> get serializer => _$SFUResponseSerializer();
}

class _$SFUResponseSerializer implements PrimitiveSerializer<SFUResponse> {
  @override
  final Iterable<Type> types = const [SFUResponse, _$SFUResponse];

  @override
  final String wireName = r'SFUResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SFUResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'edge_name';
    yield serializers.serialize(
      object.edgeName,
      specifiedType: const FullType(String),
    );
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
    yield r'ws_endpoint';
    yield serializers.serialize(
      object.wsEndpoint,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SFUResponse object, {
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
    required SFUResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'edge_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.edgeName = valueDes;
          break;
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        case r'ws_endpoint':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.wsEndpoint = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SFUResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SFUResponseBuilder();
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
