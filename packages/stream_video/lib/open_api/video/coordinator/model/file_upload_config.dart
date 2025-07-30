//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'file_upload_config.g.dart';

/// FileUploadConfig
///
/// Properties:
/// * [allowedFileExtensions]
/// * [allowedMimeTypes]
/// * [blockedFileExtensions]
/// * [blockedMimeTypes]
/// * [sizeLimit]
@BuiltValue()
abstract class FileUploadConfig
    implements Built<FileUploadConfig, FileUploadConfigBuilder> {
  @BuiltValueField(wireName: r'allowed_file_extensions')
  BuiltList<String> get allowedFileExtensions;

  @BuiltValueField(wireName: r'allowed_mime_types')
  BuiltList<String> get allowedMimeTypes;

  @BuiltValueField(wireName: r'blocked_file_extensions')
  BuiltList<String> get blockedFileExtensions;

  @BuiltValueField(wireName: r'blocked_mime_types')
  BuiltList<String> get blockedMimeTypes;

  @BuiltValueField(wireName: r'size_limit')
  int get sizeLimit;

  FileUploadConfig._();

  factory FileUploadConfig([void updates(FileUploadConfigBuilder b)]) =
      _$FileUploadConfig;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FileUploadConfigBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FileUploadConfig> get serializer =>
      _$FileUploadConfigSerializer();
}

class _$FileUploadConfigSerializer
    implements PrimitiveSerializer<FileUploadConfig> {
  @override
  final Iterable<Type> types = const [FileUploadConfig, _$FileUploadConfig];

  @override
  final String wireName = r'FileUploadConfig';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FileUploadConfig object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'allowed_file_extensions';
    yield serializers.serialize(
      object.allowedFileExtensions,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'allowed_mime_types';
    yield serializers.serialize(
      object.allowedMimeTypes,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'blocked_file_extensions';
    yield serializers.serialize(
      object.blockedFileExtensions,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'blocked_mime_types';
    yield serializers.serialize(
      object.blockedMimeTypes,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'size_limit';
    yield serializers.serialize(
      object.sizeLimit,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FileUploadConfig object, {
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
    required FileUploadConfigBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'allowed_file_extensions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.allowedFileExtensions.replace(valueDes);
          break;
        case r'allowed_mime_types':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.allowedMimeTypes.replace(valueDes);
          break;
        case r'blocked_file_extensions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.blockedFileExtensions.replace(valueDes);
          break;
        case r'blocked_mime_types':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.blockedMimeTypes.replace(valueDes);
          break;
        case r'size_limit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sizeLimit = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FileUploadConfig deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FileUploadConfigBuilder();
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
