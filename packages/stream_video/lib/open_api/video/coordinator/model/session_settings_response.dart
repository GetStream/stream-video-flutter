//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'session_settings_response.g.dart';

/// SessionSettingsResponse
///
/// Properties:
/// * [inactivityTimeoutSeconds]
@BuiltValue()
abstract class SessionSettingsResponse
    implements Built<SessionSettingsResponse, SessionSettingsResponseBuilder> {
  @BuiltValueField(wireName: r'inactivity_timeout_seconds')
  int get inactivityTimeoutSeconds;

  SessionSettingsResponse._();

  factory SessionSettingsResponse(
          [void updates(SessionSettingsResponseBuilder b)]) =
      _$SessionSettingsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SessionSettingsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SessionSettingsResponse> get serializer =>
      _$SessionSettingsResponseSerializer();
}

class _$SessionSettingsResponseSerializer
    implements PrimitiveSerializer<SessionSettingsResponse> {
  @override
  final Iterable<Type> types = const [
    SessionSettingsResponse,
    _$SessionSettingsResponse
  ];

  @override
  final String wireName = r'SessionSettingsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SessionSettingsResponse object, {
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
    SessionSettingsResponse object, {
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
    required SessionSettingsResponseBuilder result,
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
  SessionSettingsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SessionSettingsResponseBuilder();
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
