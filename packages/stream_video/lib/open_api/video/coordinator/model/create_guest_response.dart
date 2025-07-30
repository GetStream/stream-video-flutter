//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/user_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_guest_response.g.dart';

/// CreateGuestResponse
///
/// Properties:
/// * [accessToken] - the access token to authenticate the user
/// * [duration] - Duration of the request in milliseconds
/// * [user]
@BuiltValue()
abstract class CreateGuestResponse
    implements Built<CreateGuestResponse, CreateGuestResponseBuilder> {
  /// the access token to authenticate the user
  @BuiltValueField(wireName: r'access_token')
  String get accessToken;

  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  @BuiltValueField(wireName: r'user')
  UserResponse get user;

  CreateGuestResponse._();

  factory CreateGuestResponse([void updates(CreateGuestResponseBuilder b)]) =
      _$CreateGuestResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateGuestResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateGuestResponse> get serializer =>
      _$CreateGuestResponseSerializer();
}

class _$CreateGuestResponseSerializer
    implements PrimitiveSerializer<CreateGuestResponse> {
  @override
  final Iterable<Type> types = const [
    CreateGuestResponse,
    _$CreateGuestResponse
  ];

  @override
  final String wireName = r'CreateGuestResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateGuestResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'access_token';
    yield serializers.serialize(
      object.accessToken,
      specifiedType: const FullType(String),
    );
    yield r'duration';
    yield serializers.serialize(
      object.duration,
      specifiedType: const FullType(String),
    );
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(UserResponse),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateGuestResponse object, {
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
    required CreateGuestResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'access_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accessToken = valueDes;
          break;
        case r'duration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.duration = valueDes;
          break;
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserResponse),
          ) as UserResponse;
          result.user.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateGuestResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateGuestResponseBuilder();
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
