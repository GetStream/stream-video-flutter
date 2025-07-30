//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_feedback_report.g.dart';

/// UserFeedbackReport
///
/// Properties:
/// * [countByRating]
/// * [unreportedCount]
@BuiltValue()
abstract class UserFeedbackReport
    implements Built<UserFeedbackReport, UserFeedbackReportBuilder> {
  @BuiltValueField(wireName: r'count_by_rating')
  BuiltMap<String, int> get countByRating;

  @BuiltValueField(wireName: r'unreported_count')
  int get unreportedCount;

  UserFeedbackReport._();

  factory UserFeedbackReport([void updates(UserFeedbackReportBuilder b)]) =
      _$UserFeedbackReport;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserFeedbackReportBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserFeedbackReport> get serializer =>
      _$UserFeedbackReportSerializer();
}

class _$UserFeedbackReportSerializer
    implements PrimitiveSerializer<UserFeedbackReport> {
  @override
  final Iterable<Type> types = const [UserFeedbackReport, _$UserFeedbackReport];

  @override
  final String wireName = r'UserFeedbackReport';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserFeedbackReport object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'count_by_rating';
    yield serializers.serialize(
      object.countByRating,
      specifiedType:
          const FullType(BuiltMap, [FullType(String), FullType(int)]),
    );
    yield r'unreported_count';
    yield serializers.serialize(
      object.unreportedCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserFeedbackReport object, {
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
    required UserFeedbackReportBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'count_by_rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltMap, [FullType(String), FullType(int)]),
          ) as BuiltMap<String, int>;
          result.countByRating.replace(valueDes);
          break;
        case r'unreported_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unreportedCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserFeedbackReport deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserFeedbackReportBuilder();
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
