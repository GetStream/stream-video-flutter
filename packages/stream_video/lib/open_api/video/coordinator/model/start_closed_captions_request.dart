//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'start_closed_captions_request.g.dart';

/// StartClosedCaptionsRequest
///
/// Properties:
/// * [enableTranscription] - Enable transcriptions along with closed captions
/// * [externalStorage] - Which external storage to use for transcriptions (only applicable if enable_transcription is true)
/// * [language] - The spoken language in the call, if not provided the language defined in the transcription settings will be used
@BuiltValue()
abstract class StartClosedCaptionsRequest
    implements
        Built<StartClosedCaptionsRequest, StartClosedCaptionsRequestBuilder> {
  /// Enable transcriptions along with closed captions
  @BuiltValueField(wireName: r'enable_transcription')
  bool? get enableTranscription;

  /// Which external storage to use for transcriptions (only applicable if enable_transcription is true)
  @BuiltValueField(wireName: r'external_storage')
  String? get externalStorage;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueField(wireName: r'language')
  StartClosedCaptionsRequestLanguageEnum? get language;
  // enum languageEnum {  auto,  en,  fr,  es,  de,  it,  nl,  pt,  pl,  ca,  cs,  da,  el,  fi,  id,  ja,  ru,  sv,  ta,  th,  tr,  hu,  ro,  zh,  ar,  tl,  he,  hi,  hr,  ko,  ms,  no,  uk,  bg,  et,  sl,  sk,  };

  StartClosedCaptionsRequest._();

  factory StartClosedCaptionsRequest(
          [void updates(StartClosedCaptionsRequestBuilder b)]) =
      _$StartClosedCaptionsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StartClosedCaptionsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StartClosedCaptionsRequest> get serializer =>
      _$StartClosedCaptionsRequestSerializer();
}

class _$StartClosedCaptionsRequestSerializer
    implements PrimitiveSerializer<StartClosedCaptionsRequest> {
  @override
  final Iterable<Type> types = const [
    StartClosedCaptionsRequest,
    _$StartClosedCaptionsRequest
  ];

  @override
  final String wireName = r'StartClosedCaptionsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StartClosedCaptionsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.enableTranscription != null) {
      yield r'enable_transcription';
      yield serializers.serialize(
        object.enableTranscription,
        specifiedType: const FullType(bool),
      );
    }
    if (object.externalStorage != null) {
      yield r'external_storage';
      yield serializers.serialize(
        object.externalStorage,
        specifiedType: const FullType(String),
      );
    }
    if (object.language != null) {
      yield r'language';
      yield serializers.serialize(
        object.language,
        specifiedType: const FullType(StartClosedCaptionsRequestLanguageEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    StartClosedCaptionsRequest object, {
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
    required StartClosedCaptionsRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enable_transcription':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enableTranscription = valueDes;
          break;
        case r'external_storage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.externalStorage = valueDes;
          break;
        case r'language':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(StartClosedCaptionsRequestLanguageEnum),
          ) as StartClosedCaptionsRequestLanguageEnum;
          result.language = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StartClosedCaptionsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StartClosedCaptionsRequestBuilder();
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

class StartClosedCaptionsRequestLanguageEnum extends EnumClass {
  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'auto')
  static const StartClosedCaptionsRequestLanguageEnum auto =
      _$startClosedCaptionsRequestLanguageEnum_auto;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'en')
  static const StartClosedCaptionsRequestLanguageEnum en =
      _$startClosedCaptionsRequestLanguageEnum_en;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'fr')
  static const StartClosedCaptionsRequestLanguageEnum fr =
      _$startClosedCaptionsRequestLanguageEnum_fr;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'es')
  static const StartClosedCaptionsRequestLanguageEnum es =
      _$startClosedCaptionsRequestLanguageEnum_es;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'de')
  static const StartClosedCaptionsRequestLanguageEnum de =
      _$startClosedCaptionsRequestLanguageEnum_de;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'it')
  static const StartClosedCaptionsRequestLanguageEnum it =
      _$startClosedCaptionsRequestLanguageEnum_it;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'nl')
  static const StartClosedCaptionsRequestLanguageEnum nl =
      _$startClosedCaptionsRequestLanguageEnum_nl;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'pt')
  static const StartClosedCaptionsRequestLanguageEnum pt =
      _$startClosedCaptionsRequestLanguageEnum_pt;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'pl')
  static const StartClosedCaptionsRequestLanguageEnum pl =
      _$startClosedCaptionsRequestLanguageEnum_pl;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'ca')
  static const StartClosedCaptionsRequestLanguageEnum ca =
      _$startClosedCaptionsRequestLanguageEnum_ca;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'cs')
  static const StartClosedCaptionsRequestLanguageEnum cs =
      _$startClosedCaptionsRequestLanguageEnum_cs;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'da')
  static const StartClosedCaptionsRequestLanguageEnum da =
      _$startClosedCaptionsRequestLanguageEnum_da;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'el')
  static const StartClosedCaptionsRequestLanguageEnum el =
      _$startClosedCaptionsRequestLanguageEnum_el;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'fi')
  static const StartClosedCaptionsRequestLanguageEnum fi =
      _$startClosedCaptionsRequestLanguageEnum_fi;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'id')
  static const StartClosedCaptionsRequestLanguageEnum id =
      _$startClosedCaptionsRequestLanguageEnum_id;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'ja')
  static const StartClosedCaptionsRequestLanguageEnum ja =
      _$startClosedCaptionsRequestLanguageEnum_ja;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'ru')
  static const StartClosedCaptionsRequestLanguageEnum ru =
      _$startClosedCaptionsRequestLanguageEnum_ru;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'sv')
  static const StartClosedCaptionsRequestLanguageEnum sv =
      _$startClosedCaptionsRequestLanguageEnum_sv;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'ta')
  static const StartClosedCaptionsRequestLanguageEnum ta =
      _$startClosedCaptionsRequestLanguageEnum_ta;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'th')
  static const StartClosedCaptionsRequestLanguageEnum th =
      _$startClosedCaptionsRequestLanguageEnum_th;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'tr')
  static const StartClosedCaptionsRequestLanguageEnum tr =
      _$startClosedCaptionsRequestLanguageEnum_tr;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'hu')
  static const StartClosedCaptionsRequestLanguageEnum hu =
      _$startClosedCaptionsRequestLanguageEnum_hu;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'ro')
  static const StartClosedCaptionsRequestLanguageEnum ro =
      _$startClosedCaptionsRequestLanguageEnum_ro;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'zh')
  static const StartClosedCaptionsRequestLanguageEnum zh =
      _$startClosedCaptionsRequestLanguageEnum_zh;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'ar')
  static const StartClosedCaptionsRequestLanguageEnum ar =
      _$startClosedCaptionsRequestLanguageEnum_ar;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'tl')
  static const StartClosedCaptionsRequestLanguageEnum tl =
      _$startClosedCaptionsRequestLanguageEnum_tl;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'he')
  static const StartClosedCaptionsRequestLanguageEnum he =
      _$startClosedCaptionsRequestLanguageEnum_he;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'hi')
  static const StartClosedCaptionsRequestLanguageEnum hi =
      _$startClosedCaptionsRequestLanguageEnum_hi;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'hr')
  static const StartClosedCaptionsRequestLanguageEnum hr =
      _$startClosedCaptionsRequestLanguageEnum_hr;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'ko')
  static const StartClosedCaptionsRequestLanguageEnum ko =
      _$startClosedCaptionsRequestLanguageEnum_ko;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'ms')
  static const StartClosedCaptionsRequestLanguageEnum ms =
      _$startClosedCaptionsRequestLanguageEnum_ms;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'no')
  static const StartClosedCaptionsRequestLanguageEnum no =
      _$startClosedCaptionsRequestLanguageEnum_no;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'uk')
  static const StartClosedCaptionsRequestLanguageEnum uk =
      _$startClosedCaptionsRequestLanguageEnum_uk;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'bg')
  static const StartClosedCaptionsRequestLanguageEnum bg =
      _$startClosedCaptionsRequestLanguageEnum_bg;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'et')
  static const StartClosedCaptionsRequestLanguageEnum et =
      _$startClosedCaptionsRequestLanguageEnum_et;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'sl')
  static const StartClosedCaptionsRequestLanguageEnum sl =
      _$startClosedCaptionsRequestLanguageEnum_sl;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'sk')
  static const StartClosedCaptionsRequestLanguageEnum sk =
      _$startClosedCaptionsRequestLanguageEnum_sk;

  static Serializer<StartClosedCaptionsRequestLanguageEnum> get serializer =>
      _$startClosedCaptionsRequestLanguageEnumSerializer;

  const StartClosedCaptionsRequestLanguageEnum._(String name) : super(name);

  static BuiltSet<StartClosedCaptionsRequestLanguageEnum> get values =>
      _$startClosedCaptionsRequestLanguageEnumValues;
  static StartClosedCaptionsRequestLanguageEnum valueOf(String name) =>
      _$startClosedCaptionsRequestLanguageEnumValueOf(name);
}
