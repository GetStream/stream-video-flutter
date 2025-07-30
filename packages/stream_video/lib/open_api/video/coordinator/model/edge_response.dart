//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'edge_response.g.dart';

/// EdgeResponse
///
/// Properties:
/// * [continentCode]
/// * [countryIsoCode]
/// * [green]
/// * [id]
/// * [latencyTestUrl]
/// * [latitude]
/// * [longitude]
/// * [red]
/// * [subdivisionIsoCode]
/// * [yellow]
@BuiltValue()
abstract class EdgeResponse
    implements Built<EdgeResponse, EdgeResponseBuilder> {
  @BuiltValueField(wireName: r'continent_code')
  String get continentCode;

  @BuiltValueField(wireName: r'country_iso_code')
  String get countryIsoCode;

  @BuiltValueField(wireName: r'green')
  int get green;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'latency_test_url')
  String get latencyTestUrl;

  @BuiltValueField(wireName: r'latitude')
  double get latitude;

  @BuiltValueField(wireName: r'longitude')
  double get longitude;

  @BuiltValueField(wireName: r'red')
  int get red;

  @BuiltValueField(wireName: r'subdivision_iso_code')
  String get subdivisionIsoCode;

  @BuiltValueField(wireName: r'yellow')
  int get yellow;

  EdgeResponse._();

  factory EdgeResponse([void updates(EdgeResponseBuilder b)]) = _$EdgeResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EdgeResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EdgeResponse> get serializer => _$EdgeResponseSerializer();
}

class _$EdgeResponseSerializer implements PrimitiveSerializer<EdgeResponse> {
  @override
  final Iterable<Type> types = const [EdgeResponse, _$EdgeResponse];

  @override
  final String wireName = r'EdgeResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EdgeResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'continent_code';
    yield serializers.serialize(
      object.continentCode,
      specifiedType: const FullType(String),
    );
    yield r'country_iso_code';
    yield serializers.serialize(
      object.countryIsoCode,
      specifiedType: const FullType(String),
    );
    yield r'green';
    yield serializers.serialize(
      object.green,
      specifiedType: const FullType(int),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'latency_test_url';
    yield serializers.serialize(
      object.latencyTestUrl,
      specifiedType: const FullType(String),
    );
    yield r'latitude';
    yield serializers.serialize(
      object.latitude,
      specifiedType: const FullType(double),
    );
    yield r'longitude';
    yield serializers.serialize(
      object.longitude,
      specifiedType: const FullType(double),
    );
    yield r'red';
    yield serializers.serialize(
      object.red,
      specifiedType: const FullType(int),
    );
    yield r'subdivision_iso_code';
    yield serializers.serialize(
      object.subdivisionIsoCode,
      specifiedType: const FullType(String),
    );
    yield r'yellow';
    yield serializers.serialize(
      object.yellow,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EdgeResponse object, {
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
    required EdgeResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'continent_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.continentCode = valueDes;
          break;
        case r'country_iso_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.countryIsoCode = valueDes;
          break;
        case r'green':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.green = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'latency_test_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.latencyTestUrl = valueDes;
          break;
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.longitude = valueDes;
          break;
        case r'red':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.red = valueDes;
          break;
        case r'subdivision_iso_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subdivisionIsoCode = valueDes;
          break;
        case r'yellow':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.yellow = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EdgeResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EdgeResponseBuilder();
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
