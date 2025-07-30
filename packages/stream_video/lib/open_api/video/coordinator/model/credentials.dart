//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/sfu_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/ice_server.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'credentials.g.dart';

/// Credentials
///
/// Properties:
/// * [iceServers]
/// * [server]
/// * [token]
@BuiltValue()
abstract class Credentials implements Built<Credentials, CredentialsBuilder> {
  @BuiltValueField(wireName: r'ice_servers')
  BuiltList<ICEServer> get iceServers;

  @BuiltValueField(wireName: r'server')
  SFUResponse get server;

  @BuiltValueField(wireName: r'token')
  String get token;

  Credentials._();

  factory Credentials([void updates(CredentialsBuilder b)]) = _$Credentials;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CredentialsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Credentials> get serializer => _$CredentialsSerializer();
}

class _$CredentialsSerializer implements PrimitiveSerializer<Credentials> {
  @override
  final Iterable<Type> types = const [Credentials, _$Credentials];

  @override
  final String wireName = r'Credentials';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Credentials object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ice_servers';
    yield serializers.serialize(
      object.iceServers,
      specifiedType: const FullType(BuiltList, [FullType(ICEServer)]),
    );
    yield r'server';
    yield serializers.serialize(
      object.server,
      specifiedType: const FullType(SFUResponse),
    );
    yield r'token';
    yield serializers.serialize(
      object.token,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Credentials object, {
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
    required CredentialsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ice_servers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ICEServer)]),
          ) as BuiltList<ICEServer>;
          result.iceServers.replace(valueDes);
          break;
        case r'server':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SFUResponse),
          ) as SFUResponse;
          result.server.replace(valueDes);
          break;
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.token = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Credentials deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CredentialsBuilder();
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
