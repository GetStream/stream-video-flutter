//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'transcription_settings_response.g.dart';

/// TranscriptionSettingsResponse
///
/// Properties:
/// * [closedCaptionMode]
/// * [language]
/// * [mode]
@BuiltValue()
abstract class TranscriptionSettingsResponse
    implements
        Built<TranscriptionSettingsResponse,
            TranscriptionSettingsResponseBuilder> {
  @BuiltValueField(wireName: r'closed_caption_mode')
  TranscriptionSettingsResponseClosedCaptionModeEnum get closedCaptionMode;
  // enum closedCaptionModeEnum {  available,  disabled,  auto-on,  };

  @BuiltValueField(wireName: r'language')
  TranscriptionSettingsResponseLanguageEnum get language;
  // enum languageEnum {  auto,  en,  fr,  es,  de,  it,  nl,  pt,  pl,  ca,  cs,  da,  el,  fi,  id,  ja,  ru,  sv,  ta,  th,  tr,  hu,  ro,  zh,  ar,  tl,  he,  hi,  hr,  ko,  ms,  no,  uk,  bg,  et,  sl,  sk,  };

  @BuiltValueField(wireName: r'mode')
  TranscriptionSettingsResponseModeEnum get mode;
  // enum modeEnum {  available,  disabled,  auto-on,  };

  TranscriptionSettingsResponse._();

  factory TranscriptionSettingsResponse(
          [void updates(TranscriptionSettingsResponseBuilder b)]) =
      _$TranscriptionSettingsResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TranscriptionSettingsResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TranscriptionSettingsResponse> get serializer =>
      _$TranscriptionSettingsResponseSerializer();
}

class _$TranscriptionSettingsResponseSerializer
    implements PrimitiveSerializer<TranscriptionSettingsResponse> {
  @override
  final Iterable<Type> types = const [
    TranscriptionSettingsResponse,
    _$TranscriptionSettingsResponse
  ];

  @override
  final String wireName = r'TranscriptionSettingsResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TranscriptionSettingsResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'closed_caption_mode';
    yield serializers.serialize(
      object.closedCaptionMode,
      specifiedType:
          const FullType(TranscriptionSettingsResponseClosedCaptionModeEnum),
    );
    yield r'language';
    yield serializers.serialize(
      object.language,
      specifiedType: const FullType(TranscriptionSettingsResponseLanguageEnum),
    );
    yield r'mode';
    yield serializers.serialize(
      object.mode,
      specifiedType: const FullType(TranscriptionSettingsResponseModeEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TranscriptionSettingsResponse object, {
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
    required TranscriptionSettingsResponseBuilder result,
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
                TranscriptionSettingsResponseClosedCaptionModeEnum),
          ) as TranscriptionSettingsResponseClosedCaptionModeEnum;
          result.closedCaptionMode = valueDes;
          break;
        case r'language':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(TranscriptionSettingsResponseLanguageEnum),
          ) as TranscriptionSettingsResponseLanguageEnum;
          result.language = valueDes;
          break;
        case r'mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(TranscriptionSettingsResponseModeEnum),
          ) as TranscriptionSettingsResponseModeEnum;
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
  TranscriptionSettingsResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TranscriptionSettingsResponseBuilder();
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

class TranscriptionSettingsResponseClosedCaptionModeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'available')
  static const TranscriptionSettingsResponseClosedCaptionModeEnum available =
      _$transcriptionSettingsResponseClosedCaptionModeEnum_available;
  @BuiltValueEnumConst(wireName: r'disabled')
  static const TranscriptionSettingsResponseClosedCaptionModeEnum disabled =
      _$transcriptionSettingsResponseClosedCaptionModeEnum_disabled;
  @BuiltValueEnumConst(wireName: r'auto-on')
  static const TranscriptionSettingsResponseClosedCaptionModeEnum autoOn =
      _$transcriptionSettingsResponseClosedCaptionModeEnum_autoOn;

  static Serializer<TranscriptionSettingsResponseClosedCaptionModeEnum>
      get serializer =>
          _$transcriptionSettingsResponseClosedCaptionModeEnumSerializer;

  const TranscriptionSettingsResponseClosedCaptionModeEnum._(String name)
      : super(name);

  static BuiltSet<TranscriptionSettingsResponseClosedCaptionModeEnum>
      get values => _$transcriptionSettingsResponseClosedCaptionModeEnumValues;
  static TranscriptionSettingsResponseClosedCaptionModeEnum valueOf(
          String name) =>
      _$transcriptionSettingsResponseClosedCaptionModeEnumValueOf(name);
}

class TranscriptionSettingsResponseLanguageEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'auto')
  static const TranscriptionSettingsResponseLanguageEnum auto =
      _$transcriptionSettingsResponseLanguageEnum_auto;
  @BuiltValueEnumConst(wireName: r'en')
  static const TranscriptionSettingsResponseLanguageEnum en =
      _$transcriptionSettingsResponseLanguageEnum_en;
  @BuiltValueEnumConst(wireName: r'fr')
  static const TranscriptionSettingsResponseLanguageEnum fr =
      _$transcriptionSettingsResponseLanguageEnum_fr;
  @BuiltValueEnumConst(wireName: r'es')
  static const TranscriptionSettingsResponseLanguageEnum es =
      _$transcriptionSettingsResponseLanguageEnum_es;
  @BuiltValueEnumConst(wireName: r'de')
  static const TranscriptionSettingsResponseLanguageEnum de =
      _$transcriptionSettingsResponseLanguageEnum_de;
  @BuiltValueEnumConst(wireName: r'it')
  static const TranscriptionSettingsResponseLanguageEnum it =
      _$transcriptionSettingsResponseLanguageEnum_it;
  @BuiltValueEnumConst(wireName: r'nl')
  static const TranscriptionSettingsResponseLanguageEnum nl =
      _$transcriptionSettingsResponseLanguageEnum_nl;
  @BuiltValueEnumConst(wireName: r'pt')
  static const TranscriptionSettingsResponseLanguageEnum pt =
      _$transcriptionSettingsResponseLanguageEnum_pt;
  @BuiltValueEnumConst(wireName: r'pl')
  static const TranscriptionSettingsResponseLanguageEnum pl =
      _$transcriptionSettingsResponseLanguageEnum_pl;
  @BuiltValueEnumConst(wireName: r'ca')
  static const TranscriptionSettingsResponseLanguageEnum ca =
      _$transcriptionSettingsResponseLanguageEnum_ca;
  @BuiltValueEnumConst(wireName: r'cs')
  static const TranscriptionSettingsResponseLanguageEnum cs =
      _$transcriptionSettingsResponseLanguageEnum_cs;
  @BuiltValueEnumConst(wireName: r'da')
  static const TranscriptionSettingsResponseLanguageEnum da =
      _$transcriptionSettingsResponseLanguageEnum_da;
  @BuiltValueEnumConst(wireName: r'el')
  static const TranscriptionSettingsResponseLanguageEnum el =
      _$transcriptionSettingsResponseLanguageEnum_el;
  @BuiltValueEnumConst(wireName: r'fi')
  static const TranscriptionSettingsResponseLanguageEnum fi =
      _$transcriptionSettingsResponseLanguageEnum_fi;
  @BuiltValueEnumConst(wireName: r'id')
  static const TranscriptionSettingsResponseLanguageEnum id =
      _$transcriptionSettingsResponseLanguageEnum_id;
  @BuiltValueEnumConst(wireName: r'ja')
  static const TranscriptionSettingsResponseLanguageEnum ja =
      _$transcriptionSettingsResponseLanguageEnum_ja;
  @BuiltValueEnumConst(wireName: r'ru')
  static const TranscriptionSettingsResponseLanguageEnum ru =
      _$transcriptionSettingsResponseLanguageEnum_ru;
  @BuiltValueEnumConst(wireName: r'sv')
  static const TranscriptionSettingsResponseLanguageEnum sv =
      _$transcriptionSettingsResponseLanguageEnum_sv;
  @BuiltValueEnumConst(wireName: r'ta')
  static const TranscriptionSettingsResponseLanguageEnum ta =
      _$transcriptionSettingsResponseLanguageEnum_ta;
  @BuiltValueEnumConst(wireName: r'th')
  static const TranscriptionSettingsResponseLanguageEnum th =
      _$transcriptionSettingsResponseLanguageEnum_th;
  @BuiltValueEnumConst(wireName: r'tr')
  static const TranscriptionSettingsResponseLanguageEnum tr =
      _$transcriptionSettingsResponseLanguageEnum_tr;
  @BuiltValueEnumConst(wireName: r'hu')
  static const TranscriptionSettingsResponseLanguageEnum hu =
      _$transcriptionSettingsResponseLanguageEnum_hu;
  @BuiltValueEnumConst(wireName: r'ro')
  static const TranscriptionSettingsResponseLanguageEnum ro =
      _$transcriptionSettingsResponseLanguageEnum_ro;
  @BuiltValueEnumConst(wireName: r'zh')
  static const TranscriptionSettingsResponseLanguageEnum zh =
      _$transcriptionSettingsResponseLanguageEnum_zh;
  @BuiltValueEnumConst(wireName: r'ar')
  static const TranscriptionSettingsResponseLanguageEnum ar =
      _$transcriptionSettingsResponseLanguageEnum_ar;
  @BuiltValueEnumConst(wireName: r'tl')
  static const TranscriptionSettingsResponseLanguageEnum tl =
      _$transcriptionSettingsResponseLanguageEnum_tl;
  @BuiltValueEnumConst(wireName: r'he')
  static const TranscriptionSettingsResponseLanguageEnum he =
      _$transcriptionSettingsResponseLanguageEnum_he;
  @BuiltValueEnumConst(wireName: r'hi')
  static const TranscriptionSettingsResponseLanguageEnum hi =
      _$transcriptionSettingsResponseLanguageEnum_hi;
  @BuiltValueEnumConst(wireName: r'hr')
  static const TranscriptionSettingsResponseLanguageEnum hr =
      _$transcriptionSettingsResponseLanguageEnum_hr;
  @BuiltValueEnumConst(wireName: r'ko')
  static const TranscriptionSettingsResponseLanguageEnum ko =
      _$transcriptionSettingsResponseLanguageEnum_ko;
  @BuiltValueEnumConst(wireName: r'ms')
  static const TranscriptionSettingsResponseLanguageEnum ms =
      _$transcriptionSettingsResponseLanguageEnum_ms;
  @BuiltValueEnumConst(wireName: r'no')
  static const TranscriptionSettingsResponseLanguageEnum no =
      _$transcriptionSettingsResponseLanguageEnum_no;
  @BuiltValueEnumConst(wireName: r'uk')
  static const TranscriptionSettingsResponseLanguageEnum uk =
      _$transcriptionSettingsResponseLanguageEnum_uk;
  @BuiltValueEnumConst(wireName: r'bg')
  static const TranscriptionSettingsResponseLanguageEnum bg =
      _$transcriptionSettingsResponseLanguageEnum_bg;
  @BuiltValueEnumConst(wireName: r'et')
  static const TranscriptionSettingsResponseLanguageEnum et =
      _$transcriptionSettingsResponseLanguageEnum_et;
  @BuiltValueEnumConst(wireName: r'sl')
  static const TranscriptionSettingsResponseLanguageEnum sl =
      _$transcriptionSettingsResponseLanguageEnum_sl;
  @BuiltValueEnumConst(wireName: r'sk')
  static const TranscriptionSettingsResponseLanguageEnum sk =
      _$transcriptionSettingsResponseLanguageEnum_sk;

  static Serializer<TranscriptionSettingsResponseLanguageEnum> get serializer =>
      _$transcriptionSettingsResponseLanguageEnumSerializer;

  const TranscriptionSettingsResponseLanguageEnum._(String name) : super(name);

  static BuiltSet<TranscriptionSettingsResponseLanguageEnum> get values =>
      _$transcriptionSettingsResponseLanguageEnumValues;
  static TranscriptionSettingsResponseLanguageEnum valueOf(String name) =>
      _$transcriptionSettingsResponseLanguageEnumValueOf(name);
}

class TranscriptionSettingsResponseModeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'available')
  static const TranscriptionSettingsResponseModeEnum available =
      _$transcriptionSettingsResponseModeEnum_available;
  @BuiltValueEnumConst(wireName: r'disabled')
  static const TranscriptionSettingsResponseModeEnum disabled =
      _$transcriptionSettingsResponseModeEnum_disabled;
  @BuiltValueEnumConst(wireName: r'auto-on')
  static const TranscriptionSettingsResponseModeEnum autoOn =
      _$transcriptionSettingsResponseModeEnum_autoOn;

  static Serializer<TranscriptionSettingsResponseModeEnum> get serializer =>
      _$transcriptionSettingsResponseModeEnumSerializer;

  const TranscriptionSettingsResponseModeEnum._(String name) : super(name);

  static BuiltSet<TranscriptionSettingsResponseModeEnum> get values =>
      _$transcriptionSettingsResponseModeEnumValues;
  static TranscriptionSettingsResponseModeEnum valueOf(String name) =>
      _$transcriptionSettingsResponseModeEnumValueOf(name);
}
