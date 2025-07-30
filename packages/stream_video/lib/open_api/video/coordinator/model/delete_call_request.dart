//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delete_call_request.g.dart';

/// DeleteCallRequest is the payload for deleting a call.
///
/// Properties:
/// * [hard] - if true the call will be hard deleted along with all related data
@BuiltValue()
abstract class DeleteCallRequest
    implements Built<DeleteCallRequest, DeleteCallRequestBuilder> {
  /// if true the call will be hard deleted along with all related data
  @BuiltValueField(wireName: r'hard')
  bool? get hard;

  DeleteCallRequest._();

  factory DeleteCallRequest([void updates(DeleteCallRequestBuilder b)]) =
      _$DeleteCallRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeleteCallRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeleteCallRequest> get serializer =>
      _$DeleteCallRequestSerializer();
}

class _$DeleteCallRequestSerializer
    implements PrimitiveSerializer<DeleteCallRequest> {
  @override
  final Iterable<Type> types = const [DeleteCallRequest, _$DeleteCallRequest];

  @override
  final String wireName = r'DeleteCallRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeleteCallRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.hard != null) {
      yield r'hard';
      yield serializers.serialize(
        object.hard,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DeleteCallRequest object, {
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
    required DeleteCallRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'hard':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hard = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeleteCallRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeleteCallRequestBuilder();
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
