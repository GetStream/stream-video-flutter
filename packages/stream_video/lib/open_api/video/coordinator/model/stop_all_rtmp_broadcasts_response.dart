//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stop_all_rtmp_broadcasts_response.g.dart';

/// StopAllRTMPBroadcastsResponse
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
@BuiltValue()
abstract class StopAllRTMPBroadcastsResponse
    implements
        Built<StopAllRTMPBroadcastsResponse,
            StopAllRTMPBroadcastsResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  StopAllRTMPBroadcastsResponse._();

  factory StopAllRTMPBroadcastsResponse(
          [void updates(StopAllRTMPBroadcastsResponseBuilder b)]) =
      _$StopAllRTMPBroadcastsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StopAllRTMPBroadcastsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StopAllRTMPBroadcastsResponse> get serializer =>
      _$StopAllRTMPBroadcastsResponseSerializer();
}

class _$StopAllRTMPBroadcastsResponseSerializer
    implements PrimitiveSerializer<StopAllRTMPBroadcastsResponse> {
  @override
  final Iterable<Type> types = const [
    StopAllRTMPBroadcastsResponse,
    _$StopAllRTMPBroadcastsResponse
  ];

  @override
  final String wireName = r'StopAllRTMPBroadcastsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StopAllRTMPBroadcastsResponse object, {
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
    StopAllRTMPBroadcastsResponse object, {
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
    required StopAllRTMPBroadcastsResponseBuilder result,
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
  StopAllRTMPBroadcastsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StopAllRTMPBroadcastsResponseBuilder();
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
