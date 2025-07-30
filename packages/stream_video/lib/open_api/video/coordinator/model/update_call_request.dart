//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_settings_request.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_call_request.g.dart';

/// Request for updating a call
///
/// Properties:
/// * [custom] - Custom data for this object
/// * [settingsOverride]
/// * [startsAt] - the time the call is scheduled to start
@BuiltValue()
abstract class UpdateCallRequest
    implements Built<UpdateCallRequest, UpdateCallRequestBuilder> {
  /// Custom data for this object
  @BuiltValueField(wireName: r'custom')
  BuiltMap<String, JsonObject?>? get custom;

  @BuiltValueField(wireName: r'settings_override')
  CallSettingsRequest? get settingsOverride;

  /// the time the call is scheduled to start
  @BuiltValueField(wireName: r'starts_at')
  DateTime? get startsAt;

  UpdateCallRequest._();

  factory UpdateCallRequest([void updates(UpdateCallRequestBuilder b)]) =
      _$UpdateCallRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateCallRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateCallRequest> get serializer =>
      _$UpdateCallRequestSerializer();
}

class _$UpdateCallRequestSerializer
    implements PrimitiveSerializer<UpdateCallRequest> {
  @override
  final Iterable<Type> types = const [UpdateCallRequest, _$UpdateCallRequest];

  @override
  final String wireName = r'UpdateCallRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateCallRequest object, {
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
    if (object.settingsOverride != null) {
      yield r'settings_override';
      yield serializers.serialize(
        object.settingsOverride,
        specifiedType: const FullType(CallSettingsRequest),
      );
    }
    if (object.startsAt != null) {
      yield r'starts_at';
      yield serializers.serialize(
        object.startsAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateCallRequest object, {
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
    required UpdateCallRequestBuilder result,
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
        case r'settings_override':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CallSettingsRequest),
          ) as CallSettingsRequest;
          result.settingsOverride.replace(valueDes);
          break;
        case r'starts_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startsAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateCallRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateCallRequestBuilder();
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
