//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/call_closed_caption.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'closed_caption_event.g.dart';

/// This event is sent when closed captions are being sent in a call, clients should use this to show the closed captions in the call screen
///
/// Properties:
/// * [callCid]
/// * [closedCaption]
/// * [createdAt]
/// * [type] - The type of event: \"call.closed_caption\" in this case
@BuiltValue()
abstract class ClosedCaptionEvent
    implements Built<ClosedCaptionEvent, ClosedCaptionEventBuilder> {
  @BuiltValueField(wireName: r'call_cid')
  String get callCid;

  @BuiltValueField(wireName: r'closed_caption')
  CallClosedCaption get closedCaption;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// The type of event: \"call.closed_caption\" in this case
  @BuiltValueField(wireName: r'type')
  String get type;

  ClosedCaptionEvent._();

  factory ClosedCaptionEvent([void updates(ClosedCaptionEventBuilder b)]) =
      _$ClosedCaptionEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ClosedCaptionEventBuilder b) =>
      b..type = 'call.closed_caption';

  @BuiltValueSerializer(custom: true)
  static Serializer<ClosedCaptionEvent> get serializer =>
      _$ClosedCaptionEventSerializer();
}

class _$ClosedCaptionEventSerializer
    implements PrimitiveSerializer<ClosedCaptionEvent> {
  @override
  final Iterable<Type> types = const [ClosedCaptionEvent, _$ClosedCaptionEvent];

  @override
  final String wireName = r'ClosedCaptionEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ClosedCaptionEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'call_cid';
    yield serializers.serialize(
      object.callCid,
      specifiedType: const FullType(String),
    );
    yield r'closed_caption';
    yield serializers.serialize(
      object.closedCaption,
      specifiedType: const FullType(CallClosedCaption),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
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
    ClosedCaptionEvent object, {
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
    required ClosedCaptionEventBuilder result,
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
        case r'closed_caption':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CallClosedCaption),
          ) as CallClosedCaption;
          result.closedCaption.replace(valueDes);
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
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
  ClosedCaptionEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ClosedCaptionEventBuilder();
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
