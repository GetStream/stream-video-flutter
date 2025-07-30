//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'transcription_settings_request.g.dart';

/// TranscriptionSettingsRequest
///
/// Properties:
/// * [closedCaptionMode]
/// * [language]
/// * [mode]
@BuiltValue()
abstract class TranscriptionSettingsRequest
    implements
        Built<TranscriptionSettingsRequest,
            TranscriptionSettingsRequestBuilder> {
  @BuiltValueField(wireName: r'closed_caption_mode')
  TranscriptionSettingsRequestClosedCaptionModeEnum? get closedCaptionMode;
  // enum closedCaptionModeEnum {  available,  disabled,  auto-on,  };

  @BuiltValueField(wireName: r'language')
  TranscriptionSettingsRequestLanguageEnum? get language;
  // enum languageEnum {  auto,  en,  fr,  es,  de,  it,  nl,  pt,  pl,  ca,  cs,  da,  el,  fi,  id,  ja,  ru,  sv,  ta,  th,  tr,  hu,  ro,  zh,  ar,  tl,  he,  hi,  hr,  ko,  ms,  no,  uk,  bg,  et,  sl,  sk,  };

  @BuiltValueField(wireName: r'mode')
  TranscriptionSettingsRequestModeEnum get mode;
  // enum modeEnum {  available,  disabled,  auto-on,  };

  TranscriptionSettingsRequest._();

  factory TranscriptionSettingsRequest(
          [void updates(TranscriptionSettingsRequestBuilder b)]) =
      _$TranscriptionSettingsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TranscriptionSettingsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TranscriptionSettingsRequest> get serializer =>
      _$TranscriptionSettingsRequestSerializer();
}

class _$TranscriptionSettingsRequestSerializer
    implements PrimitiveSerializer<TranscriptionSettingsRequest> {
  @override
  final Iterable<Type> types = const [
    TranscriptionSettingsRequest,
    _$TranscriptionSettingsRequest
  ];

  @override
  final String wireName = r'TranscriptionSettingsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TranscriptionSettingsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.closedCaptionMode != null) {
      yield r'closed_caption_mode';
      yield serializers.serialize(
        object.closedCaptionMode,
        specifiedType:
            const FullType(TranscriptionSettingsRequestClosedCaptionModeEnum),
      );
    }
    if (object.language != null) {
      yield r'language';
      yield serializers.serialize(
        object.language,
        specifiedType: const FullType(TranscriptionSettingsRequestLanguageEnum),
      );
    }
    yield r'mode';
    yield serializers.serialize(
      object.mode,
      specifiedType: const FullType(TranscriptionSettingsRequestModeEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TranscriptionSettingsRequest object, {
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
    required TranscriptionSettingsRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'closed_caption_mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                TranscriptionSettingsRequestClosedCaptionModeEnum),
          ) as TranscriptionSettingsRequestClosedCaptionModeEnum;
          result.closedCaptionMode = valueDes;
          break;
        case r'language':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(TranscriptionSettingsRequestLanguageEnum),
          ) as TranscriptionSettingsRequestLanguageEnum;
          result.language = valueDes;
          break;
        case r'mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TranscriptionSettingsRequestModeEnum),
          ) as TranscriptionSettingsRequestModeEnum;
          result.mode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TranscriptionSettingsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TranscriptionSettingsRequestBuilder();
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

class TranscriptionSettingsRequestClosedCaptionModeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'available')
  static const TranscriptionSettingsRequestClosedCaptionModeEnum available =
      _$transcriptionSettingsRequestClosedCaptionModeEnum_available;
  @BuiltValueEnumConst(wireName: r'disabled')
  static const TranscriptionSettingsRequestClosedCaptionModeEnum disabled =
      _$transcriptionSettingsRequestClosedCaptionModeEnum_disabled;
  @BuiltValueEnumConst(wireName: r'auto-on')
  static const TranscriptionSettingsRequestClosedCaptionModeEnum autoOn =
      _$transcriptionSettingsRequestClosedCaptionModeEnum_autoOn;

  static Serializer<TranscriptionSettingsRequestClosedCaptionModeEnum>
      get serializer =>
          _$transcriptionSettingsRequestClosedCaptionModeEnumSerializer;

  const TranscriptionSettingsRequestClosedCaptionModeEnum._(String name)
      : super(name);

  static BuiltSet<TranscriptionSettingsRequestClosedCaptionModeEnum>
      get values => _$transcriptionSettingsRequestClosedCaptionModeEnumValues;
  static TranscriptionSettingsRequestClosedCaptionModeEnum valueOf(
          String name) =>
      _$transcriptionSettingsRequestClosedCaptionModeEnumValueOf(name);
}

class TranscriptionSettingsRequestLanguageEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'auto')
  static const TranscriptionSettingsRequestLanguageEnum auto =
      _$transcriptionSettingsRequestLanguageEnum_auto;
  @BuiltValueEnumConst(wireName: r'en')
  static const TranscriptionSettingsRequestLanguageEnum en =
      _$transcriptionSettingsRequestLanguageEnum_en;
  @BuiltValueEnumConst(wireName: r'fr')
  static const TranscriptionSettingsRequestLanguageEnum fr =
      _$transcriptionSettingsRequestLanguageEnum_fr;
  @BuiltValueEnumConst(wireName: r'es')
  static const TranscriptionSettingsRequestLanguageEnum es =
      _$transcriptionSettingsRequestLanguageEnum_es;
  @BuiltValueEnumConst(wireName: r'de')
  static const TranscriptionSettingsRequestLanguageEnum de =
      _$transcriptionSettingsRequestLanguageEnum_de;
  @BuiltValueEnumConst(wireName: r'it')
  static const TranscriptionSettingsRequestLanguageEnum it =
      _$transcriptionSettingsRequestLanguageEnum_it;
  @BuiltValueEnumConst(wireName: r'nl')
  static const TranscriptionSettingsRequestLanguageEnum nl =
      _$transcriptionSettingsRequestLanguageEnum_nl;
  @BuiltValueEnumConst(wireName: r'pt')
  static const TranscriptionSettingsRequestLanguageEnum pt =
      _$transcriptionSettingsRequestLanguageEnum_pt;
  @BuiltValueEnumConst(wireName: r'pl')
  static const TranscriptionSettingsRequestLanguageEnum pl =
      _$transcriptionSettingsRequestLanguageEnum_pl;
  @BuiltValueEnumConst(wireName: r'ca')
  static const TranscriptionSettingsRequestLanguageEnum ca =
      _$transcriptionSettingsRequestLanguageEnum_ca;
  @BuiltValueEnumConst(wireName: r'cs')
  static const TranscriptionSettingsRequestLanguageEnum cs =
      _$transcriptionSettingsRequestLanguageEnum_cs;
  @BuiltValueEnumConst(wireName: r'da')
  static const TranscriptionSettingsRequestLanguageEnum da =
      _$transcriptionSettingsRequestLanguageEnum_da;
  @BuiltValueEnumConst(wireName: r'el')
  static const TranscriptionSettingsRequestLanguageEnum el =
      _$transcriptionSettingsRequestLanguageEnum_el;
  @BuiltValueEnumConst(wireName: r'fi')
  static const TranscriptionSettingsRequestLanguageEnum fi =
      _$transcriptionSettingsRequestLanguageEnum_fi;
  @BuiltValueEnumConst(wireName: r'id')
  static const TranscriptionSettingsRequestLanguageEnum id =
      _$transcriptionSettingsRequestLanguageEnum_id;
  @BuiltValueEnumConst(wireName: r'ja')
  static const TranscriptionSettingsRequestLanguageEnum ja =
      _$transcriptionSettingsRequestLanguageEnum_ja;
  @BuiltValueEnumConst(wireName: r'ru')
  static const TranscriptionSettingsRequestLanguageEnum ru =
      _$transcriptionSettingsRequestLanguageEnum_ru;
  @BuiltValueEnumConst(wireName: r'sv')
  static const TranscriptionSettingsRequestLanguageEnum sv =
      _$transcriptionSettingsRequestLanguageEnum_sv;
  @BuiltValueEnumConst(wireName: r'ta')
  static const TranscriptionSettingsRequestLanguageEnum ta =
      _$transcriptionSettingsRequestLanguageEnum_ta;
  @BuiltValueEnumConst(wireName: r'th')
  static const TranscriptionSettingsRequestLanguageEnum th =
      _$transcriptionSettingsRequestLanguageEnum_th;
  @BuiltValueEnumConst(wireName: r'tr')
  static const TranscriptionSettingsRequestLanguageEnum tr =
      _$transcriptionSettingsRequestLanguageEnum_tr;
  @BuiltValueEnumConst(wireName: r'hu')
  static const TranscriptionSettingsRequestLanguageEnum hu =
      _$transcriptionSettingsRequestLanguageEnum_hu;
  @BuiltValueEnumConst(wireName: r'ro')
  static const TranscriptionSettingsRequestLanguageEnum ro =
      _$transcriptionSettingsRequestLanguageEnum_ro;
  @BuiltValueEnumConst(wireName: r'zh')
  static const TranscriptionSettingsRequestLanguageEnum zh =
      _$transcriptionSettingsRequestLanguageEnum_zh;
  @BuiltValueEnumConst(wireName: r'ar')
  static const TranscriptionSettingsRequestLanguageEnum ar =
      _$transcriptionSettingsRequestLanguageEnum_ar;
  @BuiltValueEnumConst(wireName: r'tl')
  static const TranscriptionSettingsRequestLanguageEnum tl =
      _$transcriptionSettingsRequestLanguageEnum_tl;
  @BuiltValueEnumConst(wireName: r'he')
  static const TranscriptionSettingsRequestLanguageEnum he =
      _$transcriptionSettingsRequestLanguageEnum_he;
  @BuiltValueEnumConst(wireName: r'hi')
  static const TranscriptionSettingsRequestLanguageEnum hi =
      _$transcriptionSettingsRequestLanguageEnum_hi;
  @BuiltValueEnumConst(wireName: r'hr')
  static const TranscriptionSettingsRequestLanguageEnum hr =
      _$transcriptionSettingsRequestLanguageEnum_hr;
  @BuiltValueEnumConst(wireName: r'ko')
  static const TranscriptionSettingsRequestLanguageEnum ko =
      _$transcriptionSettingsRequestLanguageEnum_ko;
  @BuiltValueEnumConst(wireName: r'ms')
  static const TranscriptionSettingsRequestLanguageEnum ms =
      _$transcriptionSettingsRequestLanguageEnum_ms;
  @BuiltValueEnumConst(wireName: r'no')
  static const TranscriptionSettingsRequestLanguageEnum no =
      _$transcriptionSettingsRequestLanguageEnum_no;
  @BuiltValueEnumConst(wireName: r'uk')
  static const TranscriptionSettingsRequestLanguageEnum uk =
      _$transcriptionSettingsRequestLanguageEnum_uk;
  @BuiltValueEnumConst(wireName: r'bg')
  static const TranscriptionSettingsRequestLanguageEnum bg =
      _$transcriptionSettingsRequestLanguageEnum_bg;
  @BuiltValueEnumConst(wireName: r'et')
  static const TranscriptionSettingsRequestLanguageEnum et =
      _$transcriptionSettingsRequestLanguageEnum_et;
  @BuiltValueEnumConst(wireName: r'sl')
  static const TranscriptionSettingsRequestLanguageEnum sl =
      _$transcriptionSettingsRequestLanguageEnum_sl;
  @BuiltValueEnumConst(wireName: r'sk')
  static const TranscriptionSettingsRequestLanguageEnum sk =
      _$transcriptionSettingsRequestLanguageEnum_sk;

  static Serializer<TranscriptionSettingsRequestLanguageEnum> get serializer =>
      _$transcriptionSettingsRequestLanguageEnumSerializer;

  const TranscriptionSettingsRequestLanguageEnum._(String name) : super(name);

  static BuiltSet<TranscriptionSettingsRequestLanguageEnum> get values =>
      _$transcriptionSettingsRequestLanguageEnumValues;
  static TranscriptionSettingsRequestLanguageEnum valueOf(String name) =>
      _$transcriptionSettingsRequestLanguageEnumValueOf(name);
}

class TranscriptionSettingsRequestModeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'available')
  static const TranscriptionSettingsRequestModeEnum available =
      _$transcriptionSettingsRequestModeEnum_available;
  @BuiltValueEnumConst(wireName: r'disabled')
  static const TranscriptionSettingsRequestModeEnum disabled =
      _$transcriptionSettingsRequestModeEnum_disabled;
  @BuiltValueEnumConst(wireName: r'auto-on')
  static const TranscriptionSettingsRequestModeEnum autoOn =
      _$transcriptionSettingsRequestModeEnum_autoOn;

  static Serializer<TranscriptionSettingsRequestModeEnum> get serializer =>
      _$transcriptionSettingsRequestModeEnumSerializer;

  const TranscriptionSettingsRequestModeEnum._(String name) : super(name);

  static BuiltSet<TranscriptionSettingsRequestModeEnum> get values =>
      _$transcriptionSettingsRequestModeEnumValues;
  static TranscriptionSettingsRequestModeEnum valueOf(String name) =>
      _$transcriptionSettingsRequestModeEnumValueOf(name);
}
