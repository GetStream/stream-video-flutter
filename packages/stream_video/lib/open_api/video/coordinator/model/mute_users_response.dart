//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mute_users_response.g.dart';

/// MuteUsersResponse is the response payload for the mute users endpoint.
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
@BuiltValue()
abstract class MuteUsersResponse
    implements Built<MuteUsersResponse, MuteUsersResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  MuteUsersResponse._();

  factory MuteUsersResponse([void updates(MuteUsersResponseBuilder b)]) =
      _$MuteUsersResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MuteUsersResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MuteUsersResponse> get serializer =>
      _$MuteUsersResponseSerializer();
}

class _$MuteUsersResponseSerializer
    implements PrimitiveSerializer<MuteUsersResponse> {
  @override
  final Iterable<Type> types = const [MuteUsersResponse, _$MuteUsersResponse];

  @override
  final String wireName = r'MuteUsersResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MuteUsersResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'duration';
    yield serializers.serialize(
      object.duration,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MuteUsersResponse object, {
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
    required MuteUsersResponseBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MuteUsersResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MuteUsersResponseBuilder();
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
