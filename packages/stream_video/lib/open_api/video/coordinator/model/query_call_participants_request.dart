//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'query_call_participants_request.g.dart';

/// QueryCallParticipantsRequest
///
/// Properties:
/// * [filterConditions]
@BuiltValue()
abstract class QueryCallParticipantsRequest
    implements
        Built<QueryCallParticipantsRequest,
            QueryCallParticipantsRequestBuilder> {
  @BuiltValueField(wireName: r'filter_conditions')
  BuiltMap<String, JsonObject?>? get filterConditions;

  QueryCallParticipantsRequest._();

  factory QueryCallParticipantsRequest(
          [void updates(QueryCallParticipantsRequestBuilder b)]) =
      _$QueryCallParticipantsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QueryCallParticipantsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<QueryCallParticipantsRequest> get serializer =>
      _$QueryCallParticipantsRequestSerializer();
}

class _$QueryCallParticipantsRequestSerializer
    implements PrimitiveSerializer<QueryCallParticipantsRequest> {
  @override
  final Iterable<Type> types = const [
    QueryCallParticipantsRequest,
    _$QueryCallParticipantsRequest
  ];

  @override
  final String wireName = r'QueryCallParticipantsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    QueryCallParticipantsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.filterConditions != null) {
      yield r'filter_conditions';
      yield serializers.serialize(
        object.filterConditions,
        specifiedType: const FullType(
            BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    QueryCallParticipantsRequest object, {
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
    required QueryCallParticipantsRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'filter_conditions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.filterConditions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  QueryCallParticipantsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QueryCallParticipantsRequestBuilder();
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
