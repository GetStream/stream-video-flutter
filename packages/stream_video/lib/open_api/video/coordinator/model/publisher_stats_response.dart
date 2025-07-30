//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/track_stats_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'publisher_stats_response.g.dart';

/// PublisherStatsResponse
///
/// Properties:
/// * [byTrack]
/// * [total]
/// * [unique]
@BuiltValue()
abstract class PublisherStatsResponse
    implements Built<PublisherStatsResponse, PublisherStatsResponseBuilder> {
  @BuiltValueField(wireName: r'by_track')
  BuiltList<TrackStatsResponse?>? get byTrack;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'unique')
  int get unique;

  PublisherStatsResponse._();

  factory PublisherStatsResponse(
          [void updates(PublisherStatsResponseBuilder b)]) =
      _$PublisherStatsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublisherStatsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublisherStatsResponse> get serializer =>
      _$PublisherStatsResponseSerializer();
}

class _$PublisherStatsResponseSerializer
    implements PrimitiveSerializer<PublisherStatsResponse> {
  @override
  final Iterable<Type> types = const [
    PublisherStatsResponse,
    _$PublisherStatsResponse
  ];

  @override
  final String wireName = r'PublisherStatsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublisherStatsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.byTrack != null) {
      yield r'by_track';
      yield serializers.serialize(
        object.byTrack,
        specifiedType:
            const FullType(BuiltList, [FullType.nullable(TrackStatsResponse)]),
      );
    }
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'unique';
    yield serializers.serialize(
      object.unique,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublisherStatsResponse object, {
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
    required PublisherStatsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'by_track':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType.nullable(TrackStatsResponse)]),
          ) as BuiltList<TrackStatsResponse?>;
          result.byTrack.replace(valueDes);
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'unique':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unique = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublisherStatsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublisherStatsResponseBuilder();
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
