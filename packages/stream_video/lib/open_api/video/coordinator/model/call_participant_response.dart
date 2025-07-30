//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/user_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_participant_response.g.dart';

/// CallParticipantResponse
///
/// Properties:
/// * [joinedAt]
/// * [role]
/// * [user]
/// * [userSessionId]
@BuiltValue()
abstract class CallParticipantResponse
    implements Built<CallParticipantResponse, CallParticipantResponseBuilder> {
  @BuiltValueField(wireName: r'joined_at')
  DateTime get joinedAt;

  @BuiltValueField(wireName: r'role')
  String get role;

  @BuiltValueField(wireName: r'user')
  UserResponse get user;

  @BuiltValueField(wireName: r'user_session_id')
  String get userSessionId;

  CallParticipantResponse._();

  factory CallParticipantResponse(
          [void updates(CallParticipantResponseBuilder b)]) =
      _$CallParticipantResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallParticipantResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CallParticipantResponse> get serializer =>
      _$CallParticipantResponseSerializer();
}

class _$CallParticipantResponseSerializer
    implements PrimitiveSerializer<CallParticipantResponse> {
  @override
  final Iterable<Type> types = const [
    CallParticipantResponse,
    _$CallParticipantResponse
  ];

  @override
  final String wireName = r'CallParticipantResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallParticipantResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'joined_at';
    yield serializers.serialize(
      object.joinedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(String),
    );
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(UserResponse),
    );
    yield r'user_session_id';
    yield serializers.serialize(
      object.userSessionId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CallParticipantResponse object, {
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
    required CallParticipantResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'joined_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.joinedAt = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.role = valueDes;
          break;
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserResponse),
          ) as UserResponse;
          result.user.replace(valueDes);
          break;
        case r'user_session_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userSessionId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CallParticipantResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallParticipantResponseBuilder();
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
