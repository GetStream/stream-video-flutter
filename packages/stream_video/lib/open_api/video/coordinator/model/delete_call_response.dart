//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/call_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delete_call_response.g.dart';

/// DeleteCallResponse is the payload for deleting a call.
///
/// Properties:
/// * [call]
/// * [duration]
/// * [taskId]
@BuiltValue()
abstract class DeleteCallResponse
    implements Built<DeleteCallResponse, DeleteCallResponseBuilder> {
  @BuiltValueField(wireName: r'call')
  CallResponse get call;

  @BuiltValueField(wireName: r'duration')
  String get duration;

  @BuiltValueField(wireName: r'task_id')
  String? get taskId;

  DeleteCallResponse._();

  factory DeleteCallResponse([void updates(DeleteCallResponseBuilder b)]) =
      _$DeleteCallResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeleteCallResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeleteCallResponse> get serializer =>
      _$DeleteCallResponseSerializer();
}

class _$DeleteCallResponseSerializer
    implements PrimitiveSerializer<DeleteCallResponse> {
  @override
  final Iterable<Type> types = const [DeleteCallResponse, _$DeleteCallResponse];

  @override
  final String wireName = r'DeleteCallResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeleteCallResponse object, {
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
    if (object.taskId != null) {
      yield r'task_id';
      yield serializers.serialize(
        object.taskId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DeleteCallResponse object, {
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
    required DeleteCallResponseBuilder result,
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
        case r'task_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.taskId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeleteCallResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeleteCallResponseBuilder();
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
