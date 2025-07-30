//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stop_closed_captions_response.g.dart';

/// Basic response information
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
@BuiltValue()
abstract class StopClosedCaptionsResponse
    implements
        Built<StopClosedCaptionsResponse, StopClosedCaptionsResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  StopClosedCaptionsResponse._();

  factory StopClosedCaptionsResponse(
          [void updates(StopClosedCaptionsResponseBuilder b)]) =
      _$StopClosedCaptionsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StopClosedCaptionsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StopClosedCaptionsResponse> get serializer =>
      _$StopClosedCaptionsResponseSerializer();
}

class _$StopClosedCaptionsResponseSerializer
    implements PrimitiveSerializer<StopClosedCaptionsResponse> {
  @override
  final Iterable<Type> types = const [
    StopClosedCaptionsResponse,
    _$StopClosedCaptionsResponse
  ];

  @override
  final String wireName = r'StopClosedCaptionsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StopClosedCaptionsResponse object, {
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
    StopClosedCaptionsResponse object, {
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
    required StopClosedCaptionsResponseBuilder result,
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
  StopClosedCaptionsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StopClosedCaptionsResponseBuilder();
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
