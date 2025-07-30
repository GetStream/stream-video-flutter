//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/rtmp_broadcast_request.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'start_rtmp_broadcasts_request.g.dart';

/// StartRTMPBroadcastsRequest is the payload for starting RTMP broadcasts.
///
/// Properties:
/// * [broadcasts] - List of broadcasts to start
@BuiltValue()
abstract class StartRTMPBroadcastsRequest
    implements
        Built<StartRTMPBroadcastsRequest, StartRTMPBroadcastsRequestBuilder> {
  /// List of broadcasts to start
  @BuiltValueField(wireName: r'broadcasts')
  BuiltList<RTMPBroadcastRequest> get broadcasts;

  StartRTMPBroadcastsRequest._();

  factory StartRTMPBroadcastsRequest(
          [void updates(StartRTMPBroadcastsRequestBuilder b)]) =
      _$StartRTMPBroadcastsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StartRTMPBroadcastsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StartRTMPBroadcastsRequest> get serializer =>
      _$StartRTMPBroadcastsRequestSerializer();
}

class _$StartRTMPBroadcastsRequestSerializer
    implements PrimitiveSerializer<StartRTMPBroadcastsRequest> {
  @override
  final Iterable<Type> types = const [
    StartRTMPBroadcastsRequest,
    _$StartRTMPBroadcastsRequest
  ];

  @override
  final String wireName = r'StartRTMPBroadcastsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StartRTMPBroadcastsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'broadcasts';
    yield serializers.serialize(
      object.broadcasts,
      specifiedType:
          const FullType(BuiltList, [FullType(RTMPBroadcastRequest)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StartRTMPBroadcastsRequest object, {
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
    required StartRTMPBroadcastsRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'broadcasts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(RTMPBroadcastRequest)]),
          ) as BuiltList<RTMPBroadcastRequest>;
          result.broadcasts.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StartRTMPBroadcastsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StartRTMPBroadcastsRequestBuilder();
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
