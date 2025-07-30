//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'track_stats_response.g.dart';

/// TrackStatsResponse
///
/// Properties:
/// * [durationSeconds]
/// * [trackType]
@BuiltValue()
abstract class TrackStatsResponse
    implements Built<TrackStatsResponse, TrackStatsResponseBuilder> {
  @BuiltValueField(wireName: r'duration_seconds')
  int get durationSeconds;

  @BuiltValueField(wireName: r'track_type')
  String get trackType;

  TrackStatsResponse._();

  factory TrackStatsResponse([void updates(TrackStatsResponseBuilder b)]) =
      _$TrackStatsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TrackStatsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TrackStatsResponse> get serializer =>
      _$TrackStatsResponseSerializer();
}

class _$TrackStatsResponseSerializer
    implements PrimitiveSerializer<TrackStatsResponse> {
  @override
  final Iterable<Type> types = const [TrackStatsResponse, _$TrackStatsResponse];

  @override
  final String wireName = r'TrackStatsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TrackStatsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'duration_seconds';
    yield serializers.serialize(
      object.durationSeconds,
      specifiedType: const FullType(int),
    );
    yield r'track_type';
    yield serializers.serialize(
      object.trackType,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TrackStatsResponse object, {
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
    required TrackStatsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'duration_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.durationSeconds = valueDes;
          break;
        case r'track_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.trackType = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TrackStatsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TrackStatsResponseBuilder();
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
