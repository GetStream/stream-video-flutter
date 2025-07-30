//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/call_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/own_capability.dart';
import 'package:stream_video/open_api/video/coordinator/model/member_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_call_response.g.dart';

/// GetCallResponse
///
/// Properties:
/// * [call]
/// * [duration]
/// * [members]
/// * [membership]
/// * [ownCapabilities]
@BuiltValue()
abstract class GetCallResponse
    implements Built<GetCallResponse, GetCallResponseBuilder> {
  @BuiltValueField(wireName: r'call')
  CallResponse get call;

  @BuiltValueField(wireName: r'duration')
  String get duration;

  @BuiltValueField(wireName: r'members')
  BuiltList<MemberResponse> get members;

  @BuiltValueField(wireName: r'membership')
  MemberResponse? get membership;

  @BuiltValueField(wireName: r'own_capabilities')
  BuiltList<OwnCapability> get ownCapabilities;

  GetCallResponse._();

  factory GetCallResponse([void updates(GetCallResponseBuilder b)]) =
      _$GetCallResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GetCallResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GetCallResponse> get serializer =>
      _$GetCallResponseSerializer();
}

class _$GetCallResponseSerializer
    implements PrimitiveSerializer<GetCallResponse> {
  @override
  final Iterable<Type> types = const [GetCallResponse, _$GetCallResponse];

  @override
  final String wireName = r'GetCallResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GetCallResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'call';
    yield serializers.serialize(
      object.call,
      specifiedType: const FullType(CallResponse),
    );
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
    if (object.membership != null) {
      yield r'membership';
      yield serializers.serialize(
        object.membership,
        specifiedType: const FullType(MemberResponse),
      );
    }
    yield r'own_capabilities';
    yield serializers.serialize(
      object.ownCapabilities,
      specifiedType: const FullType(BuiltList, [FullType(OwnCapability)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GetCallResponse object, {
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
    required GetCallResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'call':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CallResponse),
          ) as CallResponse;
          result.call.replace(valueDes);
          break;
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
        case r'membership':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MemberResponse),
          ) as MemberResponse;
          result.membership.replace(valueDes);
          break;
        case r'own_capabilities':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OwnCapability)]),
          ) as BuiltList<OwnCapability>;
          result.ownCapabilities.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GetCallResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GetCallResponseBuilder();
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
