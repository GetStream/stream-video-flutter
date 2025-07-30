//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/call_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/own_capability.dart';
import 'package:stream_video/open_api/video/coordinator/model/stats_options.dart';
import 'package:stream_video/open_api/video/coordinator/model/credentials.dart';
import 'package:stream_video/open_api/video/coordinator/model/member_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'join_call_response.g.dart';

/// JoinCallResponse
///
/// Properties:
/// * [call]
/// * [created]
/// * [credentials]
/// * [duration]
/// * [members]
/// * [membership]
/// * [ownCapabilities]
/// * [statsOptions]
@BuiltValue()
abstract class JoinCallResponse
    implements Built<JoinCallResponse, JoinCallResponseBuilder> {
  @BuiltValueField(wireName: r'call')
  CallResponse get call;

  @BuiltValueField(wireName: r'created')
  bool get created;

  @BuiltValueField(wireName: r'credentials')
  Credentials get credentials;

  @BuiltValueField(wireName: r'duration')
  String get duration;

  @BuiltValueField(wireName: r'members')
  BuiltList<MemberResponse> get members;

  @BuiltValueField(wireName: r'membership')
  MemberResponse? get membership;

  @BuiltValueField(wireName: r'own_capabilities')
  BuiltList<OwnCapability> get ownCapabilities;

  @BuiltValueField(wireName: r'stats_options')
  StatsOptions get statsOptions;

  JoinCallResponse._();

  factory JoinCallResponse([void updates(JoinCallResponseBuilder b)]) =
      _$JoinCallResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(JoinCallResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<JoinCallResponse> get serializer =>
      _$JoinCallResponseSerializer();
}

class _$JoinCallResponseSerializer
    implements PrimitiveSerializer<JoinCallResponse> {
  @override
  final Iterable<Type> types = const [JoinCallResponse, _$JoinCallResponse];

  @override
  final String wireName = r'JoinCallResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    JoinCallResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'call';
    yield serializers.serialize(
      object.call,
      specifiedType: const FullType(CallResponse),
    );
    yield r'created';
    yield serializers.serialize(
      object.created,
      specifiedType: const FullType(bool),
    );
    yield r'credentials';
    yield serializers.serialize(
      object.credentials,
      specifiedType: const FullType(Credentials),
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
    yield r'stats_options';
    yield serializers.serialize(
      object.statsOptions,
      specifiedType: const FullType(StatsOptions),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    JoinCallResponse object, {
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
    required JoinCallResponseBuilder result,
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
        case r'created':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.created = valueDes;
          break;
        case r'credentials':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Credentials),
          ) as Credentials;
          result.credentials.replace(valueDes);
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
        case r'stats_options':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StatsOptions),
          ) as StatsOptions;
          result.statsOptions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  JoinCallResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = JoinCallResponseBuilder();
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
