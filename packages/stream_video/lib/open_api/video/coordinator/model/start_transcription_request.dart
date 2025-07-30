//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'start_transcription_request.g.dart';

/// StartTranscriptionRequest
///
/// Properties:
/// * [enableClosedCaptions] - Enable closed captions along with transcriptions
/// * [language] - The spoken language in the call, if not provided the language defined in the transcription settings will be used
/// * [transcriptionExternalStorage] - Store transcriptions in this external storage
@BuiltValue()
abstract class StartTranscriptionRequest
    implements
        Built<StartTranscriptionRequest, StartTranscriptionRequestBuilder> {
  /// Enable closed captions along with transcriptions
  @BuiltValueField(wireName: r'enable_closed_captions')
  bool? get enableClosedCaptions;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueField(wireName: r'language')
  StartTranscriptionRequestLanguageEnum? get language;
  // enum languageEnum {  auto,  en,  fr,  es,  de,  it,  nl,  pt,  pl,  ca,  cs,  da,  el,  fi,  id,  ja,  ru,  sv,  ta,  th,  tr,  hu,  ro,  zh,  ar,  tl,  he,  hi,  hr,  ko,  ms,  no,  uk,  bg,  et,  sl,  sk,  };

  /// Store transcriptions in this external storage
  @BuiltValueField(wireName: r'transcription_external_storage')
  String? get transcriptionExternalStorage;

  StartTranscriptionRequest._();

  factory StartTranscriptionRequest(
          [void updates(StartTranscriptionRequestBuilder b)]) =
      _$StartTranscriptionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StartTranscriptionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StartTranscriptionRequest> get serializer =>
      _$StartTranscriptionRequestSerializer();
}

class _$StartTranscriptionRequestSerializer
    implements PrimitiveSerializer<StartTranscriptionRequest> {
  @override
  final Iterable<Type> types = const [
    StartTranscriptionRequest,
    _$StartTranscriptionRequest
  ];

  @override
  final String wireName = r'StartTranscriptionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StartTranscriptionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.enableClosedCaptions != null) {
      yield r'enable_closed_captions';
      yield serializers.serialize(
        object.enableClosedCaptions,
        specifiedType: const FullType(bool),
      );
    }
    if (object.language != null) {
      yield r'language';
      yield serializers.serialize(
        object.language,
        specifiedType: const FullType(StartTranscriptionRequestLanguageEnum),
      );
    }
    if (object.transcriptionExternalStorage != null) {
      yield r'transcription_external_storage';
      yield serializers.serialize(
        object.transcriptionExternalStorage,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    StartTranscriptionRequest object, {
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
    required StartTranscriptionRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enable_closed_captions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enableClosedCaptions = valueDes;
          break;
        case r'language':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(StartTranscriptionRequestLanguageEnum),
          ) as StartTranscriptionRequestLanguageEnum;
          result.language = valueDes;
          break;
        case r'transcription_external_storage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.transcriptionExternalStorage = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StartTranscriptionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StartTranscriptionRequestBuilder();
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

class StartTranscriptionRequestLanguageEnum extends EnumClass {
  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'auto')
  static const StartTranscriptionRequestLanguageEnum auto =
      _$startTranscriptionRequestLanguageEnum_auto;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'en')
  static const StartTranscriptionRequestLanguageEnum en =
      _$startTranscriptionRequestLanguageEnum_en;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'fr')
  static const StartTranscriptionRequestLanguageEnum fr =
      _$startTranscriptionRequestLanguageEnum_fr;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'es')
  static const StartTranscriptionRequestLanguageEnum es =
      _$startTranscriptionRequestLanguageEnum_es;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'de')
  static const StartTranscriptionRequestLanguageEnum de =
      _$startTranscriptionRequestLanguageEnum_de;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'it')
  static const StartTranscriptionRequestLanguageEnum it =
      _$startTranscriptionRequestLanguageEnum_it;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'nl')
  static const StartTranscriptionRequestLanguageEnum nl =
      _$startTranscriptionRequestLanguageEnum_nl;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'pt')
  static const StartTranscriptionRequestLanguageEnum pt =
      _$startTranscriptionRequestLanguageEnum_pt;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'pl')
  static const StartTranscriptionRequestLanguageEnum pl =
      _$startTranscriptionRequestLanguageEnum_pl;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'ca')
  static const StartTranscriptionRequestLanguageEnum ca =
      _$startTranscriptionRequestLanguageEnum_ca;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'cs')
  static const StartTranscriptionRequestLanguageEnum cs =
      _$startTranscriptionRequestLanguageEnum_cs;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'da')
  static const StartTranscriptionRequestLanguageEnum da =
      _$startTranscriptionRequestLanguageEnum_da;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'el')
  static const StartTranscriptionRequestLanguageEnum el =
      _$startTranscriptionRequestLanguageEnum_el;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'fi')
  static const StartTranscriptionRequestLanguageEnum fi =
      _$startTranscriptionRequestLanguageEnum_fi;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'id')
  static const StartTranscriptionRequestLanguageEnum id =
      _$startTranscriptionRequestLanguageEnum_id;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'ja')
  static const StartTranscriptionRequestLanguageEnum ja =
      _$startTranscriptionRequestLanguageEnum_ja;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'ru')
  static const StartTranscriptionRequestLanguageEnum ru =
      _$startTranscriptionRequestLanguageEnum_ru;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'sv')
  static const StartTranscriptionRequestLanguageEnum sv =
      _$startTranscriptionRequestLanguageEnum_sv;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'ta')
  static const StartTranscriptionRequestLanguageEnum ta =
      _$startTranscriptionRequestLanguageEnum_ta;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'th')
  static const StartTranscriptionRequestLanguageEnum th =
      _$startTranscriptionRequestLanguageEnum_th;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'tr')
  static const StartTranscriptionRequestLanguageEnum tr =
      _$startTranscriptionRequestLanguageEnum_tr;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'hu')
  static const StartTranscriptionRequestLanguageEnum hu =
      _$startTranscriptionRequestLanguageEnum_hu;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'ro')
  static const StartTranscriptionRequestLanguageEnum ro =
      _$startTranscriptionRequestLanguageEnum_ro;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'zh')
  static const StartTranscriptionRequestLanguageEnum zh =
      _$startTranscriptionRequestLanguageEnum_zh;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'ar')
  static const StartTranscriptionRequestLanguageEnum ar =
      _$startTranscriptionRequestLanguageEnum_ar;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'tl')
  static const StartTranscriptionRequestLanguageEnum tl =
      _$startTranscriptionRequestLanguageEnum_tl;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'he')
  static const StartTranscriptionRequestLanguageEnum he =
      _$startTranscriptionRequestLanguageEnum_he;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'hi')
  static const StartTranscriptionRequestLanguageEnum hi =
      _$startTranscriptionRequestLanguageEnum_hi;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'hr')
  static const StartTranscriptionRequestLanguageEnum hr =
      _$startTranscriptionRequestLanguageEnum_hr;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'ko')
  static const StartTranscriptionRequestLanguageEnum ko =
      _$startTranscriptionRequestLanguageEnum_ko;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'ms')
  static const StartTranscriptionRequestLanguageEnum ms =
      _$startTranscriptionRequestLanguageEnum_ms;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'no')
  static const StartTranscriptionRequestLanguageEnum no =
      _$startTranscriptionRequestLanguageEnum_no;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'uk')
  static const StartTranscriptionRequestLanguageEnum uk =
      _$startTranscriptionRequestLanguageEnum_uk;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'bg')
  static const StartTranscriptionRequestLanguageEnum bg =
      _$startTranscriptionRequestLanguageEnum_bg;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'et')
  static const StartTranscriptionRequestLanguageEnum et =
      _$startTranscriptionRequestLanguageEnum_et;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'sl')
  static const StartTranscriptionRequestLanguageEnum sl =
      _$startTranscriptionRequestLanguageEnum_sl;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  @BuiltValueEnumConst(wireName: r'sk')
  static const StartTranscriptionRequestLanguageEnum sk =
      _$startTranscriptionRequestLanguageEnum_sk;

  static Serializer<StartTranscriptionRequestLanguageEnum> get serializer =>
      _$startTranscriptionRequestLanguageEnumSerializer;

  const StartTranscriptionRequestLanguageEnum._(String name) : super(name);

  static BuiltSet<StartTranscriptionRequestLanguageEnum> get values =>
      _$startTranscriptionRequestLanguageEnumValues;
  static StartTranscriptionRequestLanguageEnum valueOf(String name) =>
      _$startTranscriptionRequestLanguageEnumValueOf(name);
}
