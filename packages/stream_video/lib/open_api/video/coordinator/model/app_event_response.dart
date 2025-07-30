//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:stream_video/open_api/video/coordinator/model/file_upload_config.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'app_event_response.g.dart';

/// AppEventResponse
///
/// Properties:
/// * [asyncUrlEnrichEnabled] - boolean
/// * [autoTranslationEnabled] - boolean
/// * [fileUploadConfig]
/// * [imageUploadConfig]
/// * [name] - string
@BuiltValue()
abstract class AppEventResponse
    implements Built<AppEventResponse, AppEventResponseBuilder> {
  /// boolean
  @BuiltValueField(wireName: r'async_url_enrich_enabled')
  bool? get asyncUrlEnrichEnabled;

  /// boolean
  @BuiltValueField(wireName: r'auto_translation_enabled')
  bool get autoTranslationEnabled;

  @BuiltValueField(wireName: r'file_upload_config')
  FileUploadConfig? get fileUploadConfig;

  @BuiltValueField(wireName: r'image_upload_config')
  FileUploadConfig? get imageUploadConfig;

  /// string
  @BuiltValueField(wireName: r'name')
  String get name;

  AppEventResponse._();

  factory AppEventResponse([void updates(AppEventResponseBuilder b)]) =
      _$AppEventResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AppEventResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AppEventResponse> get serializer =>
      _$AppEventResponseSerializer();
}

class _$AppEventResponseSerializer
    implements PrimitiveSerializer<AppEventResponse> {
  @override
  final Iterable<Type> types = const [AppEventResponse, _$AppEventResponse];

  @override
  final String wireName = r'AppEventResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AppEventResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.asyncUrlEnrichEnabled != null) {
      yield r'async_url_enrich_enabled';
      yield serializers.serialize(
        object.asyncUrlEnrichEnabled,
        specifiedType: const FullType(bool),
      );
    }
    yield r'auto_translation_enabled';
    yield serializers.serialize(
      object.autoTranslationEnabled,
      specifiedType: const FullType(bool),
    );
    if (object.fileUploadConfig != null) {
      yield r'file_upload_config';
      yield serializers.serialize(
        object.fileUploadConfig,
        specifiedType: const FullType(FileUploadConfig),
      );
    }
    if (object.imageUploadConfig != null) {
      yield r'image_upload_config';
      yield serializers.serialize(
        object.imageUploadConfig,
        specifiedType: const FullType(FileUploadConfig),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AppEventResponse object, {
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
    required AppEventResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'async_url_enrich_enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.asyncUrlEnrichEnabled = valueDes;
          break;
        case r'auto_translation_enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.autoTranslationEnabled = valueDes;
          break;
        case r'file_upload_config':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FileUploadConfig),
          ) as FileUploadConfig;
          result.fileUploadConfig.replace(valueDes);
          break;
        case r'image_upload_config':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FileUploadConfig),
          ) as FileUploadConfig;
          result.imageUploadConfig.replace(valueDes);
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AppEventResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AppEventResponseBuilder();
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
