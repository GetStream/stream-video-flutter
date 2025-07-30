//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_report_response.g.dart';

/// CallReportResponse
///
/// Properties:
/// * [endedAt]
/// * [score]
/// * [startedAt]
@BuiltValue()
abstract class CallReportResponse
    implements Built<CallReportResponse, CallReportResponseBuilder> {
  @BuiltValueField(wireName: r'ended_at')
  DateTime? get endedAt;

  @BuiltValueField(wireName: r'score')
  double get score;

  @BuiltValueField(wireName: r'started_at')
  DateTime? get startedAt;

  CallReportResponse._();

  factory CallReportResponse([void updates(CallReportResponseBuilder b)]) =
      _$CallReportResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallReportResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CallReportResponse> get serializer =>
      _$CallReportResponseSerializer();
}

class _$CallReportResponseSerializer
    implements PrimitiveSerializer<CallReportResponse> {
  @override
  final Iterable<Type> types = const [CallReportResponse, _$CallReportResponse];

  @override
  final String wireName = r'CallReportResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallReportResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.endedAt != null) {
      yield r'ended_at';
      yield serializers.serialize(
        object.endedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'score';
    yield serializers.serialize(
      object.score,
      specifiedType: const FullType(double),
    );
    if (object.startedAt != null) {
      yield r'started_at';
      yield serializers.serialize(
        object.startedAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CallReportResponse object, {
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
    required CallReportResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ended_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.endedAt = valueDes;
          break;
        case r'score':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.score = valueDes;
          break;
        case r'started_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CallReportResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallReportResponseBuilder();
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
