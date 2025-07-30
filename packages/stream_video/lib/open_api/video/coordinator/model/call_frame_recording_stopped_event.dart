//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/call_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_frame_recording_stopped_event.g.dart';

/// This event is sent when frame recording has stopped
///
/// Properties:
/// * [call]
/// * [callCid]
/// * [createdAt]
/// * [egressId]
/// * [type] - The type of event: \"call.frame_recording_stopped\" in this case
@BuiltValue()
abstract class CallFrameRecordingStoppedEvent
    implements
        Built<CallFrameRecordingStoppedEvent,
            CallFrameRecordingStoppedEventBuilder> {
  @BuiltValueField(wireName: r'call')
  CallResponse get call;

  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'egress_id')
  String get egressId;

  /// The type of event: \"call.frame_recording_stopped\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  CallFrameRecordingStoppedEvent._();

  factory CallFrameRecordingStoppedEvent(
          [void updates(CallFrameRecordingStoppedEventBuilder b)]) =
      _$CallFrameRecordingStoppedEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallFrameRecordingStoppedEventBuilder b) =>
      b..type = 'call.frame_recording_stopped';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallFrameRecordingStoppedEvent> get serializer =>
      _$CallFrameRecordingStoppedEventSerializer();
}

class _$CallFrameRecordingStoppedEventSerializer
    implements PrimitiveSerializer<CallFrameRecordingStoppedEvent> {
  @override
  final Iterable<Type> types = const [
    CallFrameRecordingStoppedEvent,
    _$CallFrameRecordingStoppedEvent
  ];

  @override
  final String wireName = r'CallFrameRecordingStoppedEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallFrameRecordingStoppedEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'call';
    yield serializers.serialize(
      object.call,
      specifiedType: const FullType(CallResponse),
    );
    yield r'call_cid';
    yield serializers.serialize(
      object.callCid,
      specifiedType: const FullType(String),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'egress_id';
    yield serializers.serialize(
      object.egressId,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CallFrameRecordingStoppedEvent object, {
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
    required CallFrameRecordingStoppedEventBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'call':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CallResponse),
          ) as CallResponse;
          result.call.replace(valueDes);
          break;
        case r'call_cid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.callCid = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'egress_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.egressId = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.type = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CallFrameRecordingStoppedEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallFrameRecordingStoppedEventBuilder();
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
