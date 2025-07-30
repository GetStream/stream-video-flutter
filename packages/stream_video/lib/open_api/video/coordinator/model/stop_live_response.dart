//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/call_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stop_live_response.g.dart';

/// StopLiveResponse
///
/// Properties:
/// * [call]
/// * [duration]
@BuiltValue()
abstract class StopLiveResponse
    implements Built<StopLiveResponse, StopLiveResponseBuilder> {
  @BuiltValueField(wireName: r'call')
  CallResponse get call;

  @BuiltValueField(wireName: r'duration')
  String get duration;

  StopLiveResponse._();

  factory StopLiveResponse([void updates(StopLiveResponseBuilder b)]) =
      _$StopLiveResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StopLiveResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StopLiveResponse> get serializer =>
      _$StopLiveResponseSerializer();
}

class _$StopLiveResponseSerializer
    implements PrimitiveSerializer<StopLiveResponse> {
  @override
  final Iterable<Type> types = const [StopLiveResponse, _$StopLiveResponse];

  @override
  final String wireName = r'StopLiveResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StopLiveResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'call';
    yield serializers.serialize(
      object.call,
      specifiedType: const FullType(CallResponse),
    );
    yield r'duration';
    yield serializers.serialize(
      object.duration,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StopLiveResponse object, {
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
    required StopLiveResponseBuilder result,
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
  StopLiveResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StopLiveResponseBuilder();
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
