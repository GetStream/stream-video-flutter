//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'reject_call_request.g.dart';

/// RejectCallRequest
///
/// Properties:
/// * [reason] - Reason for rejecting the call
@BuiltValue()
abstract class RejectCallRequest
    implements Built<RejectCallRequest, RejectCallRequestBuilder> {
  /// Reason for rejecting the call
  @BuiltValueField(wireName: r'reason')
  String? get reason;

  RejectCallRequest._();

  factory RejectCallRequest([void updates(RejectCallRequestBuilder b)]) =
      _$RejectCallRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RejectCallRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RejectCallRequest> get serializer =>
      _$RejectCallRequestSerializer();
}

class _$RejectCallRequestSerializer
    implements PrimitiveSerializer<RejectCallRequest> {
  @override
  final Iterable<Type> types = const [RejectCallRequest, _$RejectCallRequest];

  @override
  final String wireName = r'RejectCallRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RejectCallRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RejectCallRequest object, {
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
    required RejectCallRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RejectCallRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RejectCallRequestBuilder();
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
