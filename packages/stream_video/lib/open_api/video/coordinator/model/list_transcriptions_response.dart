//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/call_transcription.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'list_transcriptions_response.g.dart';

/// ListTranscriptionsResponse
///
/// Properties:
/// * [duration]
/// * [transcriptions] - List of transcriptions for the call
@BuiltValue()
abstract class ListTranscriptionsResponse
    implements
        Built<ListTranscriptionsResponse, ListTranscriptionsResponseBuilder> {
  @BuiltValueField(wireName: r'duration')
  String get duration;

  /// List of transcriptions for the call
  @BuiltValueField(wireName: r'transcriptions')
  BuiltList<CallTranscription> get transcriptions;

  ListTranscriptionsResponse._();

  factory ListTranscriptionsResponse(
          [void updates(ListTranscriptionsResponseBuilder b)]) =
      _$ListTranscriptionsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListTranscriptionsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListTranscriptionsResponse> get serializer =>
      _$ListTranscriptionsResponseSerializer();
}

class _$ListTranscriptionsResponseSerializer
    implements PrimitiveSerializer<ListTranscriptionsResponse> {
  @override
  final Iterable<Type> types = const [
    ListTranscriptionsResponse,
    _$ListTranscriptionsResponse
  ];

  @override
  final String wireName = r'ListTranscriptionsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListTranscriptionsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'duration';
    yield serializers.serialize(
      object.duration,
      specifiedType: const FullType(String),
    );
    yield r'transcriptions';
    yield serializers.serialize(
      object.transcriptions,
      specifiedType: const FullType(BuiltList, [FullType(CallTranscription)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListTranscriptionsResponse object, {
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
    required ListTranscriptionsResponseBuilder result,
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
        case r'transcriptions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(CallTranscription)]),
          ) as BuiltList<CallTranscription>;
          result.transcriptions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListTranscriptionsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListTranscriptionsResponseBuilder();
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
