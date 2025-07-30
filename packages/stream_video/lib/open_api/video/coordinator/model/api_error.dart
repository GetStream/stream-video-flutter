//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_error.g.dart';

/// APIError
///
/// Properties:
/// * [statusCode] - Response HTTP status code
/// * [code] - API error code
/// * [details] - Additional error-specific information
/// * [duration] - Request duration
/// * [exceptionFields] - Additional error info
/// * [message] - Message describing an error
/// * [moreInfo] - URL with additional information
/// * [unrecoverable] - Flag that indicates if the error is unrecoverable, requests that return unrecoverable errors should not be retried, this error only applies to the request that caused it
@BuiltValue()
abstract class APIError implements Built<APIError, APIErrorBuilder> {
  /// Response HTTP status code
  @BuiltValueField(wireName: r'StatusCode')
  int get statusCode;

  /// API error code
  @BuiltValueField(wireName: r'code')
  int get code;

  /// Additional error-specific information
  @BuiltValueField(wireName: r'details')
  BuiltList<int> get details;

  /// Request duration
  @BuiltValueField(wireName: r'duration')
  String get duration;

  /// Additional error info
  @BuiltValueField(wireName: r'exception_fields')
  BuiltMap<String, String>? get exceptionFields;

  /// Message describing an error
  @BuiltValueField(wireName: r'message')
  String get message;

  /// URL with additional information
  @BuiltValueField(wireName: r'more_info')
  String get moreInfo;

  /// Flag that indicates if the error is unrecoverable, requests that return unrecoverable errors should not be retried, this error only applies to the request that caused it
  @BuiltValueField(wireName: r'unrecoverable')
  bool? get unrecoverable;

  APIError._();

  factory APIError([void updates(APIErrorBuilder b)]) = _$APIError;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(APIErrorBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<APIError> get serializer => _$APIErrorSerializer();
}

class _$APIErrorSerializer implements PrimitiveSerializer<APIError> {
  @override
  final Iterable<Type> types = const [APIError, _$APIError];

  @override
  final String wireName = r'APIError';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    APIError object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'StatusCode';
    yield serializers.serialize(
      object.statusCode,
      specifiedType: const FullType(int),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(int),
    );
    yield r'details';
    yield serializers.serialize(
      object.details,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    yield r'duration';
    yield serializers.serialize(
      object.duration,
      specifiedType: const FullType(String),
    );
    if (object.exceptionFields != null) {
      yield r'exception_fields';
      yield serializers.serialize(
        object.exceptionFields,
        specifiedType:
            const FullType(BuiltMap, [FullType(String), FullType(String)]),
      );
    }
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
    yield r'more_info';
    yield serializers.serialize(
      object.moreInfo,
      specifiedType: const FullType(String),
    );
    if (object.unrecoverable != null) {
      yield r'unrecoverable';
      yield serializers.serialize(
        object.unrecoverable,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    APIError object, {
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
    required APIErrorBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'StatusCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.statusCode = valueDes;
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.code = valueDes;
          break;
        case r'details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.details.replace(valueDes);
          break;
        case r'duration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.duration = valueDes;
          break;
        case r'exception_fields':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltMap, [FullType(String), FullType(String)]),
          ) as BuiltMap<String, String>;
          result.exceptionFields.replace(valueDes);
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        case r'more_info':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.moreInfo = valueDes;
          break;
        case r'unrecoverable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.unrecoverable = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  APIError deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = APIErrorBuilder();
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
