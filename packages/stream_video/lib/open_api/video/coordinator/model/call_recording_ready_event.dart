//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/call_recording.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_recording_ready_event.g.dart';

/// This event is sent when call recording is ready
///
/// Properties:
/// * [callCid]
/// * [callRecording]
/// * [createdAt]
/// * [egressId]
/// * [type] - The type of event: \"call.recording_ready\" in this case
@BuiltValue()
abstract class CallRecordingReadyEvent
    implements Built<CallRecordingReadyEvent, CallRecordingReadyEventBuilder> {
  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'call_recording')
  CallRecording get callRecording;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'egress_id')
  String get egressId;

  /// The type of event: \"call.recording_ready\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  CallRecordingReadyEvent._();

  factory CallRecordingReadyEvent(
          [void updates(CallRecordingReadyEventBuilder b)]) =
      _$CallRecordingReadyEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallRecordingReadyEventBuilder b) =>
      b..type = 'call.recording_ready';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallRecordingReadyEvent> get serializer =>
      _$CallRecordingReadyEventSerializer();
}

class _$CallRecordingReadyEventSerializer
    implements PrimitiveSerializer<CallRecordingReadyEvent> {
  @override
  final Iterable<Type> types = const [
    CallRecordingReadyEvent,
    _$CallRecordingReadyEvent
  ];

  @override
  final String wireName = r'CallRecordingReadyEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallRecordingReadyEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'call_cid';
    yield serializers.serialize(
      object.callCid,
      specifiedType: const FullType(String),
    );
    yield r'call_recording';
    yield serializers.serialize(
      object.callRecording,
      specifiedType: const FullType(CallRecording),
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
    CallRecordingReadyEvent object, {
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
    required CallRecordingReadyEventBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'call_cid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.callCid = valueDes;
          break;
        case r'call_recording':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CallRecording),
          ) as CallRecording;
          result.callRecording.replace(valueDes);
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
  CallRecordingReadyEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallRecordingReadyEventBuilder();
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
