//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:stream_video/open_api/video/coordinator/model/call_recording.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'list_recordings_response.g.dart';

/// Response for listing recordings
///
/// Properties:
/// * [duration]
/// * [recordings]
@BuiltValue()
abstract class ListRecordingsResponse
    implements Built<ListRecordingsResponse, ListRecordingsResponseBuilder> {
  @BuiltValueField(wireName: r'duration')
  String get duration;

  @BuiltValueField(wireName: r'recordings')
  BuiltList<CallRecording> get recordings;

  ListRecordingsResponse._();

  factory ListRecordingsResponse(
          [void updates(ListRecordingsResponseBuilder b)]) =
      _$ListRecordingsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListRecordingsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListRecordingsResponse> get serializer =>
      _$ListRecordingsResponseSerializer();
}

class _$ListRecordingsResponseSerializer
    implements PrimitiveSerializer<ListRecordingsResponse> {
  @override
  final Iterable<Type> types = const [
    ListRecordingsResponse,
    _$ListRecordingsResponse
  ];

  @override
  final String wireName = r'ListRecordingsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListRecordingsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'duration';
    yield serializers.serialize(
      object.duration,
      specifiedType: const FullType(String),
    );
    yield r'recordings';
    yield serializers.serialize(
      object.recordings,
      specifiedType: const FullType(BuiltList, [FullType(CallRecording)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListRecordingsResponse object, {
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
    required ListRecordingsResponseBuilder result,
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
        case r'recordings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CallRecording)]),
          ) as BuiltList<CallRecording>;
          result.recordings.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListRecordingsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListRecordingsResponseBuilder();
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
