//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'collect_user_feedback_request.g.dart';

/// CollectUserFeedbackRequest
///
/// Properties:
/// * [custom]
/// * [rating]
/// * [reason]
/// * [sdk]
/// * [sdkVersion]
/// * [userSessionId]
@BuiltValue()
abstract class CollectUserFeedbackRequest
    implements
        Built<CollectUserFeedbackRequest, CollectUserFeedbackRequestBuilder> {
  @BuiltValueField(wireName: r'custom')
  BuiltMap<String, JsonObject?>? get custom;

  @BuiltValueField(wireName: r'rating')
  int get rating;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'sdk')
  String get sdk;

  @BuiltValueField(wireName: r'sdk_version')
  String get sdkVersion;

  @BuiltValueField(wireName: r'user_session_id')
  String? get userSessionId;

  CollectUserFeedbackRequest._();

  factory CollectUserFeedbackRequest(
          [void updates(CollectUserFeedbackRequestBuilder b)]) =
      _$CollectUserFeedbackRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CollectUserFeedbackRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CollectUserFeedbackRequest> get serializer =>
      _$CollectUserFeedbackRequestSerializer();
}

class _$CollectUserFeedbackRequestSerializer
    implements PrimitiveSerializer<CollectUserFeedbackRequest> {
  @override
  final Iterable<Type> types = const [
    CollectUserFeedbackRequest,
    _$CollectUserFeedbackRequest
  ];

  @override
  final String wireName = r'CollectUserFeedbackRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CollectUserFeedbackRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.custom != null) {
      yield r'custom';
      yield serializers.serialize(
        object.custom,
        specifiedType: const FullType(
            BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    yield r'rating';
    yield serializers.serialize(
      object.rating,
      specifiedType: const FullType(int),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
    yield r'sdk';
    yield serializers.serialize(
      object.sdk,
      specifiedType: const FullType(String),
    );
    yield r'sdk_version';
    yield serializers.serialize(
      object.sdkVersion,
      specifiedType: const FullType(String),
    );
    if (object.userSessionId != null) {
      yield r'user_session_id';
      yield serializers.serialize(
        object.userSessionId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CollectUserFeedbackRequest object, {
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
    required CollectUserFeedbackRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'custom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.custom.replace(valueDes);
          break;
        case r'rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rating = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'sdk':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sdk = valueDes;
          break;
        case r'sdk_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sdkVersion = valueDes;
          break;
        case r'user_session_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userSessionId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CollectUserFeedbackRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CollectUserFeedbackRequestBuilder();
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
