//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'layout_settings_request.g.dart';

/// LayoutSettingsRequest
///
/// Properties:
/// * [detectOrientation]
/// * [externalAppUrl]
/// * [externalCssUrl]
/// * [name]
/// * [options]
@BuiltValue()
abstract class LayoutSettingsRequest
    implements Built<LayoutSettingsRequest, LayoutSettingsRequestBuilder> {
  @BuiltValueField(wireName: r'detect_orientation')
  bool? get detectOrientation;

  @BuiltValueField(wireName: r'external_app_url')
  String? get externalAppUrl;

  @BuiltValueField(wireName: r'external_css_url')
  String? get externalCssUrl;

  @BuiltValueField(wireName: r'name')
  LayoutSettingsRequestNameEnum get name;
  // enum nameEnum {  spotlight,  grid,  single-participant,  mobile,  custom,  };

  @BuiltValueField(wireName: r'options')
  BuiltMap<String, JsonObject?>? get options;

  LayoutSettingsRequest._();

  factory LayoutSettingsRequest(
      [void updates(LayoutSettingsRequestBuilder b)]) = _$LayoutSettingsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LayoutSettingsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LayoutSettingsRequest> get serializer =>
      _$LayoutSettingsRequestSerializer();
}

class _$LayoutSettingsRequestSerializer
    implements PrimitiveSerializer<LayoutSettingsRequest> {
  @override
  final Iterable<Type> types = const [
    LayoutSettingsRequest,
    _$LayoutSettingsRequest
  ];

  @override
  final String wireName = r'LayoutSettingsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LayoutSettingsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.detectOrientation != null) {
      yield r'detect_orientation';
      yield serializers.serialize(
        object.detectOrientation,
        specifiedType: const FullType(bool),
      );
    }
    if (object.externalAppUrl != null) {
      yield r'external_app_url';
      yield serializers.serialize(
        object.externalAppUrl,
        specifiedType: const FullType(String),
      );
    }
    if (object.externalCssUrl != null) {
      yield r'external_css_url';
      yield serializers.serialize(
        object.externalCssUrl,
        specifiedType: const FullType(String),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(LayoutSettingsRequestNameEnum),
    );
    if (object.options != null) {
      yield r'options';
      yield serializers.serialize(
        object.options,
        specifiedType: const FullType(
            BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    LayoutSettingsRequest object, {
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
    required LayoutSettingsRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'detect_orientation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.detectOrientation = valueDes;
          break;
        case r'external_app_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.externalAppUrl = valueDes;
          break;
        case r'external_css_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.externalCssUrl = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LayoutSettingsRequestNameEnum),
          ) as LayoutSettingsRequestNameEnum;
          result.name = valueDes;
          break;
        case r'options':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.options.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LayoutSettingsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LayoutSettingsRequestBuilder();
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

class LayoutSettingsRequestNameEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'spotlight')
  static const LayoutSettingsRequestNameEnum spotlight =
      _$layoutSettingsRequestNameEnum_spotlight;
  @BuiltValueEnumConst(wireName: r'grid')
  static const LayoutSettingsRequestNameEnum grid =
      _$layoutSettingsRequestNameEnum_grid;
  @BuiltValueEnumConst(wireName: r'single-participant')
  static const LayoutSettingsRequestNameEnum singleParticipant =
      _$layoutSettingsRequestNameEnum_singleParticipant;
  @BuiltValueEnumConst(wireName: r'mobile')
  static const LayoutSettingsRequestNameEnum mobile =
      _$layoutSettingsRequestNameEnum_mobile;
  @BuiltValueEnumConst(wireName: r'custom')
  static const LayoutSettingsRequestNameEnum custom =
      _$layoutSettingsRequestNameEnum_custom;

  static Serializer<LayoutSettingsRequestNameEnum> get serializer =>
      _$layoutSettingsRequestNameEnumSerializer;

  const LayoutSettingsRequestNameEnum._(String name) : super(name);

  static BuiltSet<LayoutSettingsRequestNameEnum> get values =>
      _$layoutSettingsRequestNameEnumValues;
  static LayoutSettingsRequestNameEnum valueOf(String name) =>
      _$layoutSettingsRequestNameEnumValueOf(name);
}
