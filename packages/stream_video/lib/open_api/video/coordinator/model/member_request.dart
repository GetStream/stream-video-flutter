//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'member_request.g.dart';

/// MemberRequest is the payload for adding a member to a call.
///
/// Properties:
/// * [custom] - Custom data for this object
/// * [role]
/// * [userId]
@BuiltValue()
abstract class MemberRequest
    implements Built<MemberRequest, MemberRequestBuilder> {
  /// Custom data for this object
  @BuiltValueField(wireName: r'custom')
  BuiltMap<String, JsonObject?>? get custom;

  @BuiltValueField(wireName: r'role')
  String? get role;

  @BuiltValueField(wireName: r'user_id')
  String get userId;

  MemberRequest._();

  factory MemberRequest([void updates(MemberRequestBuilder b)]) =
      _$MemberRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MemberRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MemberRequest> get serializer =>
      _$MemberRequestSerializer();
}

class _$MemberRequestSerializer implements PrimitiveSerializer<MemberRequest> {
  @override
  final Iterable<Type> types = const [MemberRequest, _$MemberRequest];

  @override
  final String wireName = r'MemberRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MemberRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.custom != null) {
      yield r'custom';
      yield serializers.serialize(
        object.custom,
        specifiedType: const FullType(
            BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.role != null) {
      yield r'role';
      yield serializers.serialize(
        object.role,
        specifiedType: const FullType(String),
      );
    }
    yield r'user_id';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MemberRequest object, {
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
    required MemberRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'custom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.custom.replace(valueDes);
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.role = valueDes;
          break;
        case r'user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MemberRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MemberRequestBuilder();
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
