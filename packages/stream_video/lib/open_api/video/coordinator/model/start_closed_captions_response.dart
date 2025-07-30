//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'start_closed_captions_response.g.dart';

/// StartClosedCaptionsResponse
///
/// Properties:
/// * [duration]
@BuiltValue()
abstract class StartClosedCaptionsResponse
    implements
        Built<StartClosedCaptionsResponse, StartClosedCaptionsResponseBuilder> {
  @BuiltValueField(wireName: r'duration')
  String get duration;

  StartClosedCaptionsResponse._();

  factory StartClosedCaptionsResponse(
          [void updates(StartClosedCaptionsResponseBuilder b)]) =
      _$StartClosedCaptionsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StartClosedCaptionsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StartClosedCaptionsResponse> get serializer =>
      _$StartClosedCaptionsResponseSerializer();
}

class _$StartClosedCaptionsResponseSerializer
    implements PrimitiveSerializer<StartClosedCaptionsResponse> {
  @override
  final Iterable<Type> types = const [
    StartClosedCaptionsResponse,
    _$StartClosedCaptionsResponse
  ];

  @override
  final String wireName = r'StartClosedCaptionsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StartClosedCaptionsResponse object, {
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
    StartClosedCaptionsResponse object, {
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
    required StartClosedCaptionsResponseBuilder result,
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
  StartClosedCaptionsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StartClosedCaptionsResponseBuilder();
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
