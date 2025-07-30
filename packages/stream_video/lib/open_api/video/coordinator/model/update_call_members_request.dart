//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/member_request.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_call_members_request.g.dart';

/// Update call members
///
/// Properties:
/// * [removeMembers] - List of userID to remove
/// * [updateMembers] - List of members to update or insert
@BuiltValue()
abstract class UpdateCallMembersRequest
    implements
        Built<UpdateCallMembersRequest, UpdateCallMembersRequestBuilder> {
  /// List of userID to remove
  @BuiltValueField(wireName: r'remove_members')
  BuiltList<String>? get removeMembers;

  /// List of members to update or insert
  @BuiltValueField(wireName: r'update_members')
  BuiltList<MemberRequest>? get updateMembers;

  UpdateCallMembersRequest._();

  factory UpdateCallMembersRequest(
          [void updates(UpdateCallMembersRequestBuilder b)]) =
      _$UpdateCallMembersRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateCallMembersRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateCallMembersRequest> get serializer =>
      _$UpdateCallMembersRequestSerializer();
}

class _$UpdateCallMembersRequestSerializer
    implements PrimitiveSerializer<UpdateCallMembersRequest> {
  @override
  final Iterable<Type> types = const [
    UpdateCallMembersRequest,
    _$UpdateCallMembersRequest
  ];

  @override
  final String wireName = r'UpdateCallMembersRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateCallMembersRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.removeMembers != null) {
      yield r'remove_members';
      yield serializers.serialize(
        object.removeMembers,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.updateMembers != null) {
      yield r'update_members';
      yield serializers.serialize(
        object.updateMembers,
        specifiedType: const FullType(BuiltList, [FullType(MemberRequest)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateCallMembersRequest object, {
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
    required UpdateCallMembersRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'remove_members':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.removeMembers.replace(valueDes);
          break;
        case r'update_members':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MemberRequest)]),
          ) as BuiltList<MemberRequest>;
          result.updateMembers.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateCallMembersRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateCallMembersRequestBuilder();
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
