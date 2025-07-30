//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/user_request.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_guest_request.g.dart';

/// CreateGuestRequest
///
/// Properties:
/// * [user]
@BuiltValue()
abstract class CreateGuestRequest
    implements Built<CreateGuestRequest, CreateGuestRequestBuilder> {
  @BuiltValueField(wireName: r'user')
  UserRequest get user;

  CreateGuestRequest._();

  factory CreateGuestRequest([void updates(CreateGuestRequestBuilder b)]) =
      _$CreateGuestRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateGuestRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateGuestRequest> get serializer =>
      _$CreateGuestRequestSerializer();
}

class _$CreateGuestRequestSerializer
    implements PrimitiveSerializer<CreateGuestRequest> {
  @override
  final Iterable<Type> types = const [CreateGuestRequest, _$CreateGuestRequest];

  @override
  final String wireName = r'CreateGuestRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateGuestRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(UserRequest),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateGuestRequest object, {
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
    required CreateGuestRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserRequest),
          ) as UserRequest;
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
  CreateGuestRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateGuestRequestBuilder();
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
