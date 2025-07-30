//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_stats_report_ready_event.g.dart';

/// This event is sent when the insights report is ready
///
/// Properties:
/// * [callCid]
/// * [createdAt]
/// * [sessionId] - Call session ID
/// * [type] - The type of event, \"call.report_ready\" in this case
@BuiltValue()
abstract class CallStatsReportReadyEvent
    implements
        Built<CallStatsReportReadyEvent, CallStatsReportReadyEventBuilder> {
  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// Call session ID
  @BuiltValueField(wireName: r'session_id')
  String get sessionId;

  /// The type of event, \"call.report_ready\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  CallStatsReportReadyEvent._();

  factory CallStatsReportReadyEvent(
          [void updates(CallStatsReportReadyEventBuilder b)]) =
      _$CallStatsReportReadyEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallStatsReportReadyEventBuilder b) =>
      b..type = 'call.stats_report_ready';

  @BuiltValueSerializer(custom: true)
  static Serializer<CallStatsReportReadyEvent> get serializer =>
      _$CallStatsReportReadyEventSerializer();
}

class _$CallStatsReportReadyEventSerializer
    implements PrimitiveSerializer<CallStatsReportReadyEvent> {
  @override
  final Iterable<Type> types = const [
    CallStatsReportReadyEvent,
    _$CallStatsReportReadyEvent
  ];

  @override
  final String wireName = r'CallStatsReportReadyEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallStatsReportReadyEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'session_id';
    yield serializers.serialize(
      object.sessionId,
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
    CallStatsReportReadyEvent object, {
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
    required CallStatsReportReadyEventBuilder result,
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
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'session_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sessionId = valueDes;
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
  CallStatsReportReadyEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallStatsReportReadyEventBuilder();
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
