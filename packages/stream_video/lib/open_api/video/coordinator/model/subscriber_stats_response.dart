//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subscriber_stats_response.g.dart';

/// SubscriberStatsResponse
///
/// Properties:
/// * [total]
/// * [totalSubscribedDurationSeconds]
/// * [unique]
@BuiltValue()
abstract class SubscriberStatsResponse
    implements Built<SubscriberStatsResponse, SubscriberStatsResponseBuilder> {
  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'total_subscribed_duration_seconds')
  int get totalSubscribedDurationSeconds;

  @BuiltValueField(wireName: r'unique')
  int get unique;

  SubscriberStatsResponse._();

  factory SubscriberStatsResponse(
          [void updates(SubscriberStatsResponseBuilder b)]) =
      _$SubscriberStatsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubscriberStatsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubscriberStatsResponse> get serializer =>
      _$SubscriberStatsResponseSerializer();
}

class _$SubscriberStatsResponseSerializer
    implements PrimitiveSerializer<SubscriberStatsResponse> {
  @override
  final Iterable<Type> types = const [
    SubscriberStatsResponse,
    _$SubscriberStatsResponse
  ];

  @override
  final String wireName = r'SubscriberStatsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubscriberStatsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'total_subscribed_duration_seconds';
    yield serializers.serialize(
      object.totalSubscribedDurationSeconds,
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
    SubscriberStatsResponse object, {
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
    required SubscriberStatsResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'total_subscribed_duration_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalSubscribedDurationSeconds = valueDes;
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
  SubscriberStatsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubscriberStatsResponseBuilder();
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
