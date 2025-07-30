//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/call_request.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_or_create_call_request.g.dart';

/// GetOrCreateCallRequest
///
/// Properties:
/// * [data]
/// * [membersLimit]
/// * [notify] - if provided it sends a notification event to the members for this call
/// * [ring] - if provided it sends a ring event to the members for this call
/// * [video]
@BuiltValue()
abstract class GetOrCreateCallRequest
    implements Built<GetOrCreateCallRequest, GetOrCreateCallRequestBuilder> {
  @BuiltValueField(wireName: r'data')
  CallRequest? get data;

  @BuiltValueField(wireName: r'members_limit')
  int? get membersLimit;

  /// if provided it sends a notification event to the members for this call
  @BuiltValueField(wireName: r'notify')
  bool? get notify;

  /// if provided it sends a ring event to the members for this call
  @BuiltValueField(wireName: r'ring')
  bool? get ring;

  @BuiltValueField(wireName: r'video')
  bool? get video;

  GetOrCreateCallRequest._();

  factory GetOrCreateCallRequest(
          [void updates(GetOrCreateCallRequestBuilder b)]) =
      _$GetOrCreateCallRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetOrCreateCallRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetOrCreateCallRequest> get serializer =>
      _$GetOrCreateCallRequestSerializer();
}

class _$GetOrCreateCallRequestSerializer
    implements PrimitiveSerializer<GetOrCreateCallRequest> {
  @override
  final Iterable<Type> types = const [
    GetOrCreateCallRequest,
    _$GetOrCreateCallRequest
  ];

  @override
  final String wireName = r'GetOrCreateCallRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetOrCreateCallRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.data != null) {
      yield r'data';
      yield serializers.serialize(
        object.data,
        specifiedType: const FullType(CallRequest),
      );
    }
    if (object.membersLimit != null) {
      yield r'members_limit';
      yield serializers.serialize(
        object.membersLimit,
        specifiedType: const FullType(int),
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
    GetOrCreateCallRequest object, {
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
    required GetOrCreateCallRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CallRequest),
          ) as CallRequest;
          result.data.replace(valueDes);
          break;
        case r'members_limit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.membersLimit = valueDes;
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
  GetOrCreateCallRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetOrCreateCallRequestBuilder();
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
