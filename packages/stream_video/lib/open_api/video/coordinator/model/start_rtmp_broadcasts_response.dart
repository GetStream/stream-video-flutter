//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'start_rtmp_broadcasts_response.g.dart';

/// StartRTMPBroadcastsResponse is the payload for starting an RTMP broadcast.
///
/// Properties:
/// * [duration] - Duration of the request in milliseconds
@BuiltValue()
abstract class StartRTMPBroadcastsResponse
    implements
        Built<StartRTMPBroadcastsResponse, StartRTMPBroadcastsResponseBuilder> {
  /// Duration of the request in milliseconds
  @BuiltValueField(wireName: r'duration')
  String get duration;

  StartRTMPBroadcastsResponse._();

  factory StartRTMPBroadcastsResponse(
          [void updates(StartRTMPBroadcastsResponseBuilder b)]) =
      _$StartRTMPBroadcastsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StartRTMPBroadcastsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StartRTMPBroadcastsResponse> get serializer =>
      _$StartRTMPBroadcastsResponseSerializer();
}

class _$StartRTMPBroadcastsResponseSerializer
    implements PrimitiveSerializer<StartRTMPBroadcastsResponse> {
  @override
  final Iterable<Type> types = const [
    StartRTMPBroadcastsResponse,
    _$StartRTMPBroadcastsResponse
  ];

  @override
  final String wireName = r'StartRTMPBroadcastsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StartRTMPBroadcastsResponse object, {
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
    StartRTMPBroadcastsResponse object, {
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
    required StartRTMPBroadcastsResponseBuilder result,
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
  StartRTMPBroadcastsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StartRTMPBroadcastsResponseBuilder();
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
