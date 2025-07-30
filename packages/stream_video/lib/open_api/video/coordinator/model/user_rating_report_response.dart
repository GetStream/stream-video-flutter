//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_rating_report_response.g.dart';

/// UserRatingReportResponse
///
/// Properties:
/// * [average]
/// * [count]
@BuiltValue()
abstract class UserRatingReportResponse
    implements
        Built<UserRatingReportResponse, UserRatingReportResponseBuilder> {
  @BuiltValueField(wireName: r'average')
  double get average;

  @BuiltValueField(wireName: r'count')
  int get count;

  UserRatingReportResponse._();

  factory UserRatingReportResponse(
          [void updates(UserRatingReportResponseBuilder b)]) =
      _$UserRatingReportResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserRatingReportResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserRatingReportResponse> get serializer =>
      _$UserRatingReportResponseSerializer();
}

class _$UserRatingReportResponseSerializer
    implements PrimitiveSerializer<UserRatingReportResponse> {
  @override
  final Iterable<Type> types = const [
    UserRatingReportResponse,
    _$UserRatingReportResponse
  ];

  @override
  final String wireName = r'UserRatingReportResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserRatingReportResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'average';
    yield serializers.serialize(
      object.average,
      specifiedType: const FullType(double),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserRatingReportResponse object, {
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
    required UserRatingReportResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'average':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.average = valueDes;
          break;
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserRatingReportResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserRatingReportResponseBuilder();
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
