//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/user_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_closed_caption.g.dart';

/// CallClosedCaption represents a closed caption of a call.
///
/// Properties:
/// * [endTime]
/// * [speakerId]
/// * [startTime]
/// * [text]
/// * [user]
@BuiltValue()
abstract class CallClosedCaption
    implements Built<CallClosedCaption, CallClosedCaptionBuilder> {
  @BuiltValueField(wireName: r'end_time')
  DateTime get endTime;

  @BuiltValueField(wireName: r'speaker_id')
  String get speakerId;

  @BuiltValueField(wireName: r'start_time')
  DateTime get startTime;

  @BuiltValueField(wireName: r'text')
  String get text;

  @BuiltValueField(wireName: r'user')
  UserResponse get user;

  CallClosedCaption._();

  factory CallClosedCaption([void updates(CallClosedCaptionBuilder b)]) =
      _$CallClosedCaption;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallClosedCaptionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CallClosedCaption> get serializer =>
      _$CallClosedCaptionSerializer();
}

class _$CallClosedCaptionSerializer
    implements PrimitiveSerializer<CallClosedCaption> {
  @override
  final Iterable<Type> types = const [CallClosedCaption, _$CallClosedCaption];

  @override
  final String wireName = r'CallClosedCaption';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallClosedCaption object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'end_time';
    yield serializers.serialize(
      object.endTime,
      specifiedType: const FullType(DateTime),
    );
    yield r'speaker_id';
    yield serializers.serialize(
      object.speakerId,
      specifiedType: const FullType(String),
    );
    yield r'start_time';
    yield serializers.serialize(
      object.startTime,
      specifiedType: const FullType(DateTime),
    );
    yield r'text';
    yield serializers.serialize(
      object.text,
      specifiedType: const FullType(String),
    );
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(UserResponse),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CallClosedCaption object, {
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
    required CallClosedCaptionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'end_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.endTime = valueDes;
          break;
        case r'speaker_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.speakerId = valueDes;
          break;
        case r'start_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startTime = valueDes;
          break;
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.text = valueDes;
          break;
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserResponse),
          ) as UserResponse;
          result.user.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CallClosedCaption deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallClosedCaptionBuilder();
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
