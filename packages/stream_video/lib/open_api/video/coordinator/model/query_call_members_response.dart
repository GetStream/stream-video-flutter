//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/member_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'query_call_members_response.g.dart';

/// Basic response information
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
/// * [members]
/// * [next]
/// * [prev]
@BuiltValue()
abstract class QueryCallMembersResponse
    implements
        Built<QueryCallMembersResponse, QueryCallMembersResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  @BuiltValueField(wireName: r'members')
  BuiltList<MemberResponse> get members;

  @BuiltValueField(wireName: r'next')
  String? get next;

  @BuiltValueField(wireName: r'prev')
  String? get prev;

  QueryCallMembersResponse._();

  factory QueryCallMembersResponse(
          [void updates(QueryCallMembersResponseBuilder b)]) =
      _$QueryCallMembersResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QueryCallMembersResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<QueryCallMembersResponse> get serializer =>
      _$QueryCallMembersResponseSerializer();
}

class _$QueryCallMembersResponseSerializer
    implements PrimitiveSerializer<QueryCallMembersResponse> {
  @override
  final Iterable<Type> types = const [
    QueryCallMembersResponse,
    _$QueryCallMembersResponse
  ];

  @override
  final String wireName = r'QueryCallMembersResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    QueryCallMembersResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'duration';
    yield serializers.serialize(
      object.duration,
      specifiedType: const FullType(String),
    );
    yield r'members';
    yield serializers.serialize(
      object.members,
      specifiedType: const FullType(BuiltList, [FullType(MemberResponse)]),
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
    QueryCallMembersResponse object, {
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
    required QueryCallMembersResponseBuilder result,
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
        case r'members':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(MemberResponse)]),
          ) as BuiltList<MemberResponse>;
          result.members.replace(valueDes);
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
  QueryCallMembersResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QueryCallMembersResponseBuilder();
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
