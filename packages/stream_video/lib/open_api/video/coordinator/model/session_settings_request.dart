//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'session_settings_request.g.dart';

/// SessionSettingsRequest
///
/// Properties:
/// * [inactivityTimeoutSeconds]
@BuiltValue()
abstract class SessionSettingsRequest
    implements Built<SessionSettingsRequest, SessionSettingsRequestBuilder> {
  @BuiltValueField(wireName: r'inactivity_timeout_seconds')
  int get inactivityTimeoutSeconds;

  SessionSettingsRequest._();

  factory SessionSettingsRequest(
          [void updates(SessionSettingsRequestBuilder b)]) =
      _$SessionSettingsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SessionSettingsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SessionSettingsRequest> get serializer =>
      _$SessionSettingsRequestSerializer();
}

class _$SessionSettingsRequestSerializer
    implements PrimitiveSerializer<SessionSettingsRequest> {
  @override
  final Iterable<Type> types = const [
    SessionSettingsRequest,
    _$SessionSettingsRequest
  ];

  @override
  final String wireName = r'SessionSettingsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SessionSettingsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'inactivity_timeout_seconds';
    yield serializers.serialize(
      object.inactivityTimeoutSeconds,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SessionSettingsRequest object, {
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
    required SessionSettingsRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'inactivity_timeout_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.inactivityTimeoutSeconds = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SessionSettingsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SessionSettingsRequestBuilder();
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
