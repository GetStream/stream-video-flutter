//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/call_request.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'join_call_request.g.dart';

/// JoinCallRequest
///
/// Properties:
/// * [create] - if true the call will be created if it doesn't exist
/// * [data]
/// * [location]
/// * [membersLimit]
/// * [migratingFrom] - If the participant is migrating from another SFU, then this is the ID of the previous SFU
/// * [notify]
/// * [ring] - if true and the call is created, the notification will include ring=true
/// * [video]
@BuiltValue()
abstract class JoinCallRequest
    implements Built<JoinCallRequest, JoinCallRequestBuilder> {
  /// if true the call will be created if it doesn't exist
  @BuiltValueField(wireName: r'create')
  bool? get create;

  @BuiltValueField(wireName: r'data')
  CallRequest? get data;

  @BuiltValueField(wireName: r'location')
  String get location;

  @BuiltValueField(wireName: r'members_limit')
  int? get membersLimit;

  /// If the participant is migrating from another SFU, then this is the ID of the previous SFU
  @BuiltValueField(wireName: r'migrating_from')
  String? get migratingFrom;

  @BuiltValueField(wireName: r'notify')
  bool? get notify;

  /// if true and the call is created, the notification will include ring=true
  @BuiltValueField(wireName: r'ring')
  bool? get ring;

  @BuiltValueField(wireName: r'video')
  bool? get video;

  JoinCallRequest._();

  factory JoinCallRequest([void updates(JoinCallRequestBuilder b)]) =
      _$JoinCallRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(JoinCallRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<JoinCallRequest> get serializer =>
      _$JoinCallRequestSerializer();
}

class _$JoinCallRequestSerializer
    implements PrimitiveSerializer<JoinCallRequest> {
  @override
  final Iterable<Type> types = const [JoinCallRequest, _$JoinCallRequest];

  @override
  final String wireName = r'JoinCallRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    JoinCallRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.create != null) {
      yield r'create';
      yield serializers.serialize(
        object.create,
        specifiedType: const FullType(bool),
      );
    }
    if (object.data != null) {
      yield r'data';
      yield serializers.serialize(
        object.data,
        specifiedType: const FullType(CallRequest),
      );
    }
    yield r'location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(String),
    );
    if (object.membersLimit != null) {
      yield r'members_limit';
      yield serializers.serialize(
        object.membersLimit,
        specifiedType: const FullType(int),
      );
    }
    if (object.migratingFrom != null) {
      yield r'migrating_from';
      yield serializers.serialize(
        object.migratingFrom,
        specifiedType: const FullType(String),
      );
    }
    if (object.notify != null) {
      yield r'notify';
      yield serializers.serialize(
        object.notify,
        specifiedType: const FullType(bool),
      );
    }
    if (object.ring != null) {
      yield r'ring';
      yield serializers.serialize(
        object.ring,
        specifiedType: const FullType(bool),
      );
    }
    if (object.video != null) {
      yield r'video';
      yield serializers.serialize(
        object.video,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    JoinCallRequest object, {
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
    required JoinCallRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'create':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.create = valueDes;
          break;
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CallRequest),
          ) as CallRequest;
          result.data.replace(valueDes);
          break;
        case r'location':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.location = valueDes;
          break;
        case r'members_limit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.membersLimit = valueDes;
          break;
        case r'migrating_from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.migratingFrom = valueDes;
          break;
        case r'notify':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.notify = valueDes;
          break;
        case r'ring':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.ring = valueDes;
          break;
        case r'video':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.video = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  JoinCallRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = JoinCallRequestBuilder();
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
