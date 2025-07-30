//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'egress_hls_response.g.dart';

/// EgressHLSResponse
///
/// Properties:
/// * [playlistUrl]
/// * [status]
@BuiltValue()
abstract class EgressHLSResponse
    implements Built<EgressHLSResponse, EgressHLSResponseBuilder> {
  @BuiltValueField(wireName: r'playlist_url')
  String get playlistUrl;

  @BuiltValueField(wireName: r'status')
  String get status;

  EgressHLSResponse._();

  factory EgressHLSResponse([void updates(EgressHLSResponseBuilder b)]) =
      _$EgressHLSResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EgressHLSResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EgressHLSResponse> get serializer =>
      _$EgressHLSResponseSerializer();
}

class _$EgressHLSResponseSerializer
    implements PrimitiveSerializer<EgressHLSResponse> {
  @override
  final Iterable<Type> types = const [EgressHLSResponse, _$EgressHLSResponse];

  @override
  final String wireName = r'EgressHLSResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EgressHLSResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'playlist_url';
    yield serializers.serialize(
      object.playlistUrl,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EgressHLSResponse object, {
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
    required EgressHLSResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'playlist_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.playlistUrl = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EgressHLSResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EgressHLSResponseBuilder();
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
