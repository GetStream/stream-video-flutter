//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'limits_settings_response.g.dart';

/// LimitsSettingsResponse
///
/// Properties:
/// * [maxDurationSeconds]
/// * [maxParticipants]
/// * [maxParticipantsExcludeOwner]
/// * [maxParticipantsExcludeRoles]
@BuiltValue()
abstract class LimitsSettingsResponse
    implements Built<LimitsSettingsResponse, LimitsSettingsResponseBuilder> {
  @BuiltValueField(wireName: r'max_duration_seconds')
  int? get maxDurationSeconds;

  @BuiltValueField(wireName: r'max_participants')
  int? get maxParticipants;

  @BuiltValueField(wireName: r'max_participants_exclude_owner')
  bool? get maxParticipantsExcludeOwner;

  @BuiltValueField(wireName: r'max_participants_exclude_roles')
  BuiltList<String> get maxParticipantsExcludeRoles;

  LimitsSettingsResponse._();

  factory LimitsSettingsResponse(
          [void updates(LimitsSettingsResponseBuilder b)]) =
      _$LimitsSettingsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LimitsSettingsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LimitsSettingsResponse> get serializer =>
      _$LimitsSettingsResponseSerializer();
}

class _$LimitsSettingsResponseSerializer
    implements PrimitiveSerializer<LimitsSettingsResponse> {
  @override
  final Iterable<Type> types = const [
    LimitsSettingsResponse,
    _$LimitsSettingsResponse
  ];

  @override
  final String wireName = r'LimitsSettingsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LimitsSettingsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.maxDurationSeconds != null) {
      yield r'max_duration_seconds';
      yield serializers.serialize(
        object.maxDurationSeconds,
        specifiedType: const FullType(int),
      );
    }
    if (object.maxParticipants != null) {
      yield r'max_participants';
      yield serializers.serialize(
        object.maxParticipants,
        specifiedType: const FullType(int),
      );
    }
    if (object.maxParticipantsExcludeOwner != null) {
      yield r'max_participants_exclude_owner';
      yield serializers.serialize(
        object.maxParticipantsExcludeOwner,
        specifiedType: const FullType(bool),
      );
    }
    yield r'max_participants_exclude_roles';
    yield serializers.serialize(
      object.maxParticipantsExcludeRoles,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LimitsSettingsResponse object, {
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
    required LimitsSettingsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'max_duration_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.maxDurationSeconds = valueDes;
          break;
        case r'max_participants':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.maxParticipants = valueDes;
          break;
        case r'max_participants_exclude_owner':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.maxParticipantsExcludeOwner = valueDes;
          break;
        case r'max_participants_exclude_roles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.maxParticipantsExcludeRoles.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LimitsSettingsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LimitsSettingsResponseBuilder();
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
