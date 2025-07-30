//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'backstage_settings_response.g.dart';

/// BackstageSettingsResponse
///
/// Properties:
/// * [enabled]
/// * [joinAheadTimeSeconds]
@BuiltValue()
abstract class BackstageSettingsResponse
    implements
        Built<BackstageSettingsResponse, BackstageSettingsResponseBuilder> {
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'join_ahead_time_seconds')
  int? get joinAheadTimeSeconds;

  BackstageSettingsResponse._();

  factory BackstageSettingsResponse(
          [void updates(BackstageSettingsResponseBuilder b)]) =
      _$BackstageSettingsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BackstageSettingsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BackstageSettingsResponse> get serializer =>
      _$BackstageSettingsResponseSerializer();
}

class _$BackstageSettingsResponseSerializer
    implements PrimitiveSerializer<BackstageSettingsResponse> {
  @override
  final Iterable<Type> types = const [
    BackstageSettingsResponse,
    _$BackstageSettingsResponse
  ];

  @override
  final String wireName = r'BackstageSettingsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BackstageSettingsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    if (object.joinAheadTimeSeconds != null) {
      yield r'join_ahead_time_seconds';
      yield serializers.serialize(
        object.joinAheadTimeSeconds,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BackstageSettingsResponse object, {
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
    required BackstageSettingsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'join_ahead_time_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.joinAheadTimeSeconds = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BackstageSettingsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BackstageSettingsResponseBuilder();
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
