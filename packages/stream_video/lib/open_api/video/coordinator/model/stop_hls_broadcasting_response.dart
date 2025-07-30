//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stop_hls_broadcasting_response.g.dart';

/// Basic response information
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
@BuiltValue()
abstract class StopHLSBroadcastingResponse
    implements
        Built<StopHLSBroadcastingResponse, StopHLSBroadcastingResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  StopHLSBroadcastingResponse._();

  factory StopHLSBroadcastingResponse(
          [void updates(StopHLSBroadcastingResponseBuilder b)]) =
      _$StopHLSBroadcastingResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StopHLSBroadcastingResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StopHLSBroadcastingResponse> get serializer =>
      _$StopHLSBroadcastingResponseSerializer();
}

class _$StopHLSBroadcastingResponseSerializer
    implements PrimitiveSerializer<StopHLSBroadcastingResponse> {
  @override
  final Iterable<Type> types = const [
    StopHLSBroadcastingResponse,
    _$StopHLSBroadcastingResponse
  ];

  @override
  final String wireName = r'StopHLSBroadcastingResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StopHLSBroadcastingResponse object, {
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
    StopHLSBroadcastingResponse object, {
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
    required StopHLSBroadcastingResponseBuilder result,
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
  StopHLSBroadcastingResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StopHLSBroadcastingResponseBuilder();
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
