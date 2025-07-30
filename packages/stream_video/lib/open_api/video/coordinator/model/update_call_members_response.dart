//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/member_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_call_members_response.g.dart';

/// Basic response information
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
/// * [members]
@BuiltValue()
abstract class UpdateCallMembersResponse
    implements
        Built<UpdateCallMembersResponse, UpdateCallMembersResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  @BuiltValueField(wireName: r'members')
  BuiltList<MemberResponse> get members;

  UpdateCallMembersResponse._();

  factory UpdateCallMembersResponse(
          [void updates(UpdateCallMembersResponseBuilder b)]) =
      _$UpdateCallMembersResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateCallMembersResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateCallMembersResponse> get serializer =>
      _$UpdateCallMembersResponseSerializer();
}

class _$UpdateCallMembersResponseSerializer
    implements PrimitiveSerializer<UpdateCallMembersResponse> {
  @override
  final Iterable<Type> types = const [
    UpdateCallMembersResponse,
    _$UpdateCallMembersResponse
  ];

  @override
  final String wireName = r'UpdateCallMembersResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateCallMembersResponse object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateCallMembersResponse object, {
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
    required UpdateCallMembersResponseBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateCallMembersResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateCallMembersResponseBuilder();
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
