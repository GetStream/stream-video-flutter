//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/call_state_response_fields.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'query_calls_response.g.dart';

/// QueryCallsResponse
///
/// Properties:
/// * [calls]
/// * [duration] - Duration of the request in milliseconds
/// * [next]
/// * [prev]
@BuiltValue()
abstract class QueryCallsResponse
    implements Built<QueryCallsResponse, QueryCallsResponseBuilder> {
  @BuiltValueField(wireName: r'calls')
  BuiltList<CallStateResponseFields> get calls;

  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  @BuiltValueField(wireName: r'next')
  String? get next;

  @BuiltValueField(wireName: r'prev')
  String? get prev;

  QueryCallsResponse._();

  factory QueryCallsResponse([void updates(QueryCallsResponseBuilder b)]) =
      _$QueryCallsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QueryCallsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<QueryCallsResponse> get serializer =>
      _$QueryCallsResponseSerializer();
}

class _$QueryCallsResponseSerializer
    implements PrimitiveSerializer<QueryCallsResponse> {
  @override
  final Iterable<Type> types = const [QueryCallsResponse, _$QueryCallsResponse];

  @override
  final String wireName = r'QueryCallsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    QueryCallsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'calls';
    yield serializers.serialize(
      object.calls,
      specifiedType:
          const FullType(BuiltList, [FullType(CallStateResponseFields)]),
    );
    yield r'duration';
    yield serializers.serialize(
      object.duration,
      specifiedType: const FullType(String),
    );
    if (object.next != null) {
      yield r'next';
      yield serializers.serialize(
        object.next,
        specifiedType: const FullType(String),
      );
    }
    if (object.prev != null) {
      yield r'prev';
      yield serializers.serialize(
        object.prev,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    QueryCallsResponse object, {
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
    required QueryCallsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'calls':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(CallStateResponseFields)]),
          ) as BuiltList<CallStateResponseFields>;
          result.calls.replace(valueDes);
          break;
        case r'duration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.duration = valueDes;
          break;
        case r'next':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.next = valueDes;
          break;
        case r'prev':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.prev = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  QueryCallsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QueryCallsResponseBuilder();
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
