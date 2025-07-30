//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stop_rtmp_broadcasts_response.g.dart';

/// Basic response information
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
@BuiltValue()
abstract class StopRTMPBroadcastsResponse
    implements
        Built<StopRTMPBroadcastsResponse, StopRTMPBroadcastsResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  StopRTMPBroadcastsResponse._();

  factory StopRTMPBroadcastsResponse(
          [void updates(StopRTMPBroadcastsResponseBuilder b)]) =
      _$StopRTMPBroadcastsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StopRTMPBroadcastsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StopRTMPBroadcastsResponse> get serializer =>
      _$StopRTMPBroadcastsResponseSerializer();
}

class _$StopRTMPBroadcastsResponseSerializer
    implements PrimitiveSerializer<StopRTMPBroadcastsResponse> {
  @override
  final Iterable<Type> types = const [
    StopRTMPBroadcastsResponse,
    _$StopRTMPBroadcastsResponse
  ];

  @override
  final String wireName = r'StopRTMPBroadcastsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StopRTMPBroadcastsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'duration';
    yield serializers.serialize(
      object.duration,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StopRTMPBroadcastsResponse object, {
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
    required StopRTMPBroadcastsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'duration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.duration = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StopRTMPBroadcastsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StopRTMPBroadcastsResponseBuilder();
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
