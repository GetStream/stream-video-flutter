//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/member_request.dart';
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_settings_request.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_request.g.dart';

/// CallRequest is the payload for creating a call.
///
/// Properties:
/// * [channelCid]
/// * [custom]
/// * [members]
/// * [settingsOverride]
/// * [startsAt]
/// * [team]
/// * [video]
@BuiltValue()
abstract class CallRequest implements Built<CallRequest, CallRequestBuilder> {
  @BuiltValueField(wireName: r'channel_cid')
  String? get channelCid;

  @BuiltValueField(wireName: r'custom')
  BuiltMap<String, JsonObject?>? get custom;

  @BuiltValueField(wireName: r'members')
  BuiltList<MemberRequest>? get members;

  @BuiltValueField(wireName: r'settings_override')
  CallSettingsRequest? get settingsOverride;

  @BuiltValueField(wireName: r'starts_at')
  DateTime? get startsAt;

  @BuiltValueField(wireName: r'team')
  String? get team;

  @BuiltValueField(wireName: r'video')
  bool? get video;

  CallRequest._();

  factory CallRequest([void updates(CallRequestBuilder b)]) = _$CallRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CallRequest> get serializer => _$CallRequestSerializer();
}

class _$CallRequestSerializer implements PrimitiveSerializer<CallRequest> {
  @override
  final Iterable<Type> types = const [CallRequest, _$CallRequest];

  @override
  final String wireName = r'CallRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.channelCid != null) {
      yield r'channel_cid';
      yield serializers.serialize(
        object.channelCid,
        specifiedType: const FullType(String),
      );
    }
    if (object.custom != null) {
      yield r'custom';
      yield serializers.serialize(
        object.custom,
        specifiedType: const FullType(
            BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.members != null) {
      yield r'members';
      yield serializers.serialize(
        object.members,
        specifiedType: const FullType(BuiltList, [FullType(MemberRequest)]),
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
    if (object.team != null) {
      yield r'team';
      yield serializers.serialize(
        object.team,
        specifiedType: const FullType(String),
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
    CallRequest object, {
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
    required CallRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'channel_cid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.channelCid = valueDes;
          break;
        case r'custom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.custom.replace(valueDes);
          break;
        case r'members':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MemberRequest)]),
          ) as BuiltList<MemberRequest>;
          result.members.replace(valueDes);
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
        case r'team':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.team = valueDes;
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
  CallRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallRequestBuilder();
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
