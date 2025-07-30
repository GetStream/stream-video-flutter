//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/edge_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_edges_response.g.dart';

/// Basic response information
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
/// * [edges]
@BuiltValue()
abstract class GetEdgesResponse
    implements Built<GetEdgesResponse, GetEdgesResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  @BuiltValueField(wireName: r'edges')
  BuiltList<EdgeResponse> get edges;

  GetEdgesResponse._();

  factory GetEdgesResponse([void updates(GetEdgesResponseBuilder b)]) =
      _$GetEdgesResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetEdgesResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetEdgesResponse> get serializer =>
      _$GetEdgesResponseSerializer();
}

class _$GetEdgesResponseSerializer
    implements PrimitiveSerializer<GetEdgesResponse> {
  @override
  final Iterable<Type> types = const [GetEdgesResponse, _$GetEdgesResponse];

  @override
  final String wireName = r'GetEdgesResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetEdgesResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'duration';
    yield serializers.serialize(
      object.duration,
      specifiedType: const FullType(String),
    );
    yield r'edges';
    yield serializers.serialize(
      object.edges,
      specifiedType: const FullType(BuiltList, [FullType(EdgeResponse)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GetEdgesResponse object, {
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
    required GetEdgesResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'duration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.duration = valueDes;
          break;
        case r'edges':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(EdgeResponse)]),
          ) as BuiltList<EdgeResponse>;
          result.edges.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GetEdgesResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetEdgesResponseBuilder();
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
