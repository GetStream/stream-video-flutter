//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mute_users_request.g.dart';

/// MuteUsersRequest
///
/// Properties:
/// * [audio]
/// * [muteAllUsers]
/// * [screenshare]
/// * [screenshareAudio]
/// * [userIds]
/// * [video]
@BuiltValue()
abstract class MuteUsersRequest
    implements Built<MuteUsersRequest, MuteUsersRequestBuilder> {
  @BuiltValueField(wireName: r'audio')
  bool? get audio;

  @BuiltValueField(wireName: r'mute_all_users')
  bool? get muteAllUsers;

  @BuiltValueField(wireName: r'screenshare')
  bool? get screenshare;

  @BuiltValueField(wireName: r'screenshare_audio')
  bool? get screenshareAudio;

  @BuiltValueField(wireName: r'user_ids')
  BuiltList<String>? get userIds;

  @BuiltValueField(wireName: r'video')
  bool? get video;

  MuteUsersRequest._();

  factory MuteUsersRequest([void updates(MuteUsersRequestBuilder b)]) =
      _$MuteUsersRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MuteUsersRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MuteUsersRequest> get serializer =>
      _$MuteUsersRequestSerializer();
}

class _$MuteUsersRequestSerializer
    implements PrimitiveSerializer<MuteUsersRequest> {
  @override
  final Iterable<Type> types = const [MuteUsersRequest, _$MuteUsersRequest];

  @override
  final String wireName = r'MuteUsersRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MuteUsersRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.audio != null) {
      yield r'audio';
      yield serializers.serialize(
        object.audio,
        specifiedType: const FullType(bool),
      );
    }
    if (object.muteAllUsers != null) {
      yield r'mute_all_users';
      yield serializers.serialize(
        object.muteAllUsers,
        specifiedType: const FullType(bool),
      );
    }
    if (object.screenshare != null) {
      yield r'screenshare';
      yield serializers.serialize(
        object.screenshare,
        specifiedType: const FullType(bool),
      );
    }
    if (object.screenshareAudio != null) {
      yield r'screenshare_audio';
      yield serializers.serialize(
        object.screenshareAudio,
        specifiedType: const FullType(bool),
      );
    }
    if (object.userIds != null) {
      yield r'user_ids';
      yield serializers.serialize(
        object.userIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
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
    MuteUsersRequest object, {
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
    required MuteUsersRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'audio':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.audio = valueDes;
          break;
        case r'mute_all_users':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.muteAllUsers = valueDes;
          break;
        case r'screenshare':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.screenshare = valueDes;
          break;
        case r'screenshare_audio':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.screenshareAudio = valueDes;
          break;
        case r'user_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.userIds.replace(valueDes);
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
  MuteUsersRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MuteUsersRequestBuilder();
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
