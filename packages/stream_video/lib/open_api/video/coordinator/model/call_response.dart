//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/call_settings_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/egress_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/user_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_session_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/thumbnail_response.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_ingress_response.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_response.g.dart';

/// Represents a call
///
/// Properties:
/// * [backstage]
/// * [blockedUserIds]
/// * [captioning]
/// * [channelCid]
/// * [cid] - The unique identifier for a call (<type>:<id>)
/// * [createdAt] - Date/time of creation
/// * [createdBy]
/// * [currentSessionId]
/// * [custom] - Custom data for this object
/// * [egress]
/// * [endedAt] - Date/time when the call ended
/// * [id] - Call ID
/// * [ingress]
/// * [joinAheadTimeSeconds]
/// * [recording]
/// * [session]
/// * [settings]
/// * [startsAt] - Date/time when the call will start
/// * [team]
/// * [thumbnails]
/// * [transcribing]
/// * [type] - The type of call
/// * [updatedAt] - Date/time of the last update
@BuiltValue()
abstract class CallResponse
    implements Built<CallResponse, CallResponseBuilder> {
  @BuiltValueField(wireName: r'backstage')
  bool get backstage;

  @BuiltValueField(wireName: r'blocked_user_ids')
  BuiltList<String> get blockedUserIds;

  @BuiltValueField(wireName: r'captioning')
  bool get captioning;

  @BuiltValueField(wireName: r'channel_cid')
  String? get channelCid;

  /// The unique identifier for a call (<type>:<id>)
  @BuiltValueField(wireName: r'cid')
  String get cid;

  /// Date/time of creation
  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'created_by')
  UserResponse get createdBy;

  @BuiltValueField(wireName: r'current_session_id')
  String get currentSessionId;

  /// Custom data for this object
  @BuiltValueField(wireName: r'custom')
  BuiltMap<String, JsonObject?> get custom;

  @BuiltValueField(wireName: r'egress')
  EgressResponse get egress;

  /// Date/time when the call ended
  @BuiltValueField(wireName: r'ended_at')
  DateTime? get endedAt;

  /// Call ID
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'ingress')
  CallIngressResponse get ingress;

  @BuiltValueField(wireName: r'join_ahead_time_seconds')
  int? get joinAheadTimeSeconds;

  @BuiltValueField(wireName: r'recording')
  bool get recording;

  @BuiltValueField(wireName: r'session')
  CallSessionResponse? get session;

  @BuiltValueField(wireName: r'settings')
  CallSettingsResponse get settings;

  /// Date/time when the call will start
  @BuiltValueField(wireName: r'starts_at')
  DateTime? get startsAt;

  @BuiltValueField(wireName: r'team')
  String? get team;

  @BuiltValueField(wireName: r'thumbnails')
  ThumbnailResponse? get thumbnails;

  @BuiltValueField(wireName: r'transcribing')
  bool get transcribing;

  /// The type of call
  @BuiltValueField(wireName: r'type')
  String get type;

  /// Date/time of the last update
  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  CallResponse._();

  factory CallResponse([void updates(CallResponseBuilder b)]) = _$CallResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CallResponse> get serializer => _$CallResponseSerializer();
}

class _$CallResponseSerializer implements PrimitiveSerializer<CallResponse> {
  @override
  final Iterable<Type> types = const [CallResponse, _$CallResponse];

  @override
  final String wireName = r'CallResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'backstage';
    yield serializers.serialize(
      object.backstage,
      specifiedType: const FullType(bool),
    );
    yield r'blocked_user_ids';
    yield serializers.serialize(
      object.blockedUserIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'captioning';
    yield serializers.serialize(
      object.captioning,
      specifiedType: const FullType(bool),
    );
    if (object.channelCid != null) {
      yield r'channel_cid';
      yield serializers.serialize(
        object.channelCid,
        specifiedType: const FullType(String),
      );
    }
    yield r'cid';
    yield serializers.serialize(
      object.cid,
      specifiedType: const FullType(String),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'created_by';
    yield serializers.serialize(
      object.createdBy,
      specifiedType: const FullType(UserResponse),
    );
    yield r'current_session_id';
    yield serializers.serialize(
      object.currentSessionId,
      specifiedType: const FullType(String),
    );
    yield r'custom';
    yield serializers.serialize(
      object.custom,
      specifiedType: const FullType(
          BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'egress';
    yield serializers.serialize(
      object.egress,
      specifiedType: const FullType(EgressResponse),
    );
    if (object.endedAt != null) {
      yield r'ended_at';
      yield serializers.serialize(
        object.endedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'ingress';
    yield serializers.serialize(
      object.ingress,
      specifiedType: const FullType(CallIngressResponse),
    );
    if (object.joinAheadTimeSeconds != null) {
      yield r'join_ahead_time_seconds';
      yield serializers.serialize(
        object.joinAheadTimeSeconds,
        specifiedType: const FullType(int),
      );
    }
    yield r'recording';
    yield serializers.serialize(
      object.recording,
      specifiedType: const FullType(bool),
    );
    if (object.session != null) {
      yield r'session';
      yield serializers.serialize(
        object.session,
        specifiedType: const FullType(CallSessionResponse),
      );
    }
    yield r'settings';
    yield serializers.serialize(
      object.settings,
      specifiedType: const FullType(CallSettingsResponse),
    );
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
    if (object.thumbnails != null) {
      yield r'thumbnails';
      yield serializers.serialize(
        object.thumbnails,
        specifiedType: const FullType(ThumbnailResponse),
      );
    }
    yield r'transcribing';
    yield serializers.serialize(
      object.transcribing,
      specifiedType: const FullType(bool),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
    yield r'updated_at';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CallResponse object, {
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
    required CallResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'backstage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.backstage = valueDes;
          break;
        case r'blocked_user_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.blockedUserIds.replace(valueDes);
          break;
        case r'captioning':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.captioning = valueDes;
          break;
        case r'channel_cid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.channelCid = valueDes;
          break;
        case r'cid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.cid = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'created_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserResponse),
          ) as UserResponse;
          result.createdBy.replace(valueDes);
          break;
        case r'current_session_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.currentSessionId = valueDes;
          break;
        case r'custom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.custom.replace(valueDes);
          break;
        case r'egress':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EgressResponse),
          ) as EgressResponse;
          result.egress.replace(valueDes);
          break;
        case r'ended_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.endedAt = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'ingress':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CallIngressResponse),
          ) as CallIngressResponse;
          result.ingress.replace(valueDes);
          break;
        case r'join_ahead_time_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.joinAheadTimeSeconds = valueDes;
          break;
        case r'recording':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.recording = valueDes;
          break;
        case r'session':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CallSessionResponse),
          ) as CallSessionResponse;
          result.session.replace(valueDes);
          break;
        case r'settings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CallSettingsResponse),
          ) as CallSettingsResponse;
          result.settings.replace(valueDes);
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
        case r'thumbnails':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ThumbnailResponse),
          ) as ThumbnailResponse;
          result.thumbnails.replace(valueDes);
          break;
        case r'transcribing':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.transcribing = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.type = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CallResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallResponseBuilder();
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
