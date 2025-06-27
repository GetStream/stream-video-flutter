//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class StartTranscriptionRequest {
  /// Returns a new [StartTranscriptionRequest] instance.
  StartTranscriptionRequest({
    this.enableClosedCaptions,
    this.language,
    this.transcriptionExternalStorage,
  });

  /// Enable closed captions along with transcriptions
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? enableClosedCaptions;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  StartTranscriptionRequestLanguageEnum? language;

  /// Store transcriptions in this external storage
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? transcriptionExternalStorage;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StartTranscriptionRequest &&
          other.enableClosedCaptions == enableClosedCaptions &&
          other.language == language &&
          other.transcriptionExternalStorage == transcriptionExternalStorage;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (enableClosedCaptions == null ? 0 : enableClosedCaptions!.hashCode) +
      (language == null ? 0 : language!.hashCode) +
      (transcriptionExternalStorage == null
          ? 0
          : transcriptionExternalStorage!.hashCode);

  @override
  String toString() =>
      'StartTranscriptionRequest[enableClosedCaptions=$enableClosedCaptions, language=$language, transcriptionExternalStorage=$transcriptionExternalStorage]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.enableClosedCaptions != null) {
      json[r'enable_closed_captions'] = this.enableClosedCaptions;
    } else {
      json[r'enable_closed_captions'] = null;
    }
    if (this.language != null) {
      json[r'language'] = this.language;
    } else {
      json[r'language'] = null;
    }
    if (this.transcriptionExternalStorage != null) {
      json[r'transcription_external_storage'] =
          this.transcriptionExternalStorage;
    } else {
      json[r'transcription_external_storage'] = null;
    }
    return json;
  }

  /// Returns a new [StartTranscriptionRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static StartTranscriptionRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "StartTranscriptionRequest[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "StartTranscriptionRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return StartTranscriptionRequest(
        enableClosedCaptions:
            mapValueOfType<bool>(json, r'enable_closed_captions'),
        language:
            StartTranscriptionRequestLanguageEnum.fromJson(json[r'language']),
        transcriptionExternalStorage:
            mapValueOfType<String>(json, r'transcription_external_storage'),
      );
    }
    return null;
  }

  static List<StartTranscriptionRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <StartTranscriptionRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = StartTranscriptionRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, StartTranscriptionRequest> mapFromJson(dynamic json) {
    final map = <String, StartTranscriptionRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = StartTranscriptionRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of StartTranscriptionRequest-objects as value to a dart map
  static Map<String, List<StartTranscriptionRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<StartTranscriptionRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = StartTranscriptionRequest.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{};
}

/// The spoken language in the call, if not provided the language defined in the transcription settings will be used
class StartTranscriptionRequestLanguageEnum {
  /// Instantiate a new enum with the provided [value].
  const StartTranscriptionRequestLanguageEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const auto = StartTranscriptionRequestLanguageEnum._(r'auto');
  static const en = StartTranscriptionRequestLanguageEnum._(r'en');
  static const fr = StartTranscriptionRequestLanguageEnum._(r'fr');
  static const es = StartTranscriptionRequestLanguageEnum._(r'es');
  static const de = StartTranscriptionRequestLanguageEnum._(r'de');
  static const it = StartTranscriptionRequestLanguageEnum._(r'it');
  static const nl = StartTranscriptionRequestLanguageEnum._(r'nl');
  static const pt = StartTranscriptionRequestLanguageEnum._(r'pt');
  static const pl = StartTranscriptionRequestLanguageEnum._(r'pl');
  static const ca = StartTranscriptionRequestLanguageEnum._(r'ca');
  static const cs = StartTranscriptionRequestLanguageEnum._(r'cs');
  static const da = StartTranscriptionRequestLanguageEnum._(r'da');
  static const el = StartTranscriptionRequestLanguageEnum._(r'el');
  static const fi = StartTranscriptionRequestLanguageEnum._(r'fi');
  static const id = StartTranscriptionRequestLanguageEnum._(r'id');
  static const ja = StartTranscriptionRequestLanguageEnum._(r'ja');
  static const ru = StartTranscriptionRequestLanguageEnum._(r'ru');
  static const sv = StartTranscriptionRequestLanguageEnum._(r'sv');
  static const ta = StartTranscriptionRequestLanguageEnum._(r'ta');
  static const th = StartTranscriptionRequestLanguageEnum._(r'th');
  static const tr = StartTranscriptionRequestLanguageEnum._(r'tr');
  static const hu = StartTranscriptionRequestLanguageEnum._(r'hu');
  static const ro = StartTranscriptionRequestLanguageEnum._(r'ro');
  static const zh = StartTranscriptionRequestLanguageEnum._(r'zh');
  static const ar = StartTranscriptionRequestLanguageEnum._(r'ar');
  static const tl = StartTranscriptionRequestLanguageEnum._(r'tl');
  static const he = StartTranscriptionRequestLanguageEnum._(r'he');
  static const hi = StartTranscriptionRequestLanguageEnum._(r'hi');
  static const hr = StartTranscriptionRequestLanguageEnum._(r'hr');
  static const ko = StartTranscriptionRequestLanguageEnum._(r'ko');
  static const ms = StartTranscriptionRequestLanguageEnum._(r'ms');
  static const no = StartTranscriptionRequestLanguageEnum._(r'no');
  static const uk = StartTranscriptionRequestLanguageEnum._(r'uk');
  static const bg = StartTranscriptionRequestLanguageEnum._(r'bg');
  static const et = StartTranscriptionRequestLanguageEnum._(r'et');
  static const sl = StartTranscriptionRequestLanguageEnum._(r'sl');
  static const sk = StartTranscriptionRequestLanguageEnum._(r'sk');

  /// List of all possible values in this [enum][StartTranscriptionRequestLanguageEnum].
  static const values = <StartTranscriptionRequestLanguageEnum>[
    auto,
    en,
    fr,
    es,
    de,
    it,
    nl,
    pt,
    pl,
    ca,
    cs,
    da,
    el,
    fi,
    id,
    ja,
    ru,
    sv,
    ta,
    th,
    tr,
    hu,
    ro,
    zh,
    ar,
    tl,
    he,
    hi,
    hr,
    ko,
    ms,
    no,
    uk,
    bg,
    et,
    sl,
    sk,
  ];

  static StartTranscriptionRequestLanguageEnum? fromJson(dynamic value) =>
      StartTranscriptionRequestLanguageEnumTypeTransformer().decode(value);

  static List<StartTranscriptionRequestLanguageEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <StartTranscriptionRequestLanguageEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = StartTranscriptionRequestLanguageEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [StartTranscriptionRequestLanguageEnum] to String,
/// and [decode] dynamic data back to [StartTranscriptionRequestLanguageEnum].
class StartTranscriptionRequestLanguageEnumTypeTransformer {
  factory StartTranscriptionRequestLanguageEnumTypeTransformer() =>
      _instance ??=
          const StartTranscriptionRequestLanguageEnumTypeTransformer._();

  const StartTranscriptionRequestLanguageEnumTypeTransformer._();

  String encode(StartTranscriptionRequestLanguageEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a StartTranscriptionRequestLanguageEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  StartTranscriptionRequestLanguageEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'auto':
          return StartTranscriptionRequestLanguageEnum.auto;
        case r'en':
          return StartTranscriptionRequestLanguageEnum.en;
        case r'fr':
          return StartTranscriptionRequestLanguageEnum.fr;
        case r'es':
          return StartTranscriptionRequestLanguageEnum.es;
        case r'de':
          return StartTranscriptionRequestLanguageEnum.de;
        case r'it':
          return StartTranscriptionRequestLanguageEnum.it;
        case r'nl':
          return StartTranscriptionRequestLanguageEnum.nl;
        case r'pt':
          return StartTranscriptionRequestLanguageEnum.pt;
        case r'pl':
          return StartTranscriptionRequestLanguageEnum.pl;
        case r'ca':
          return StartTranscriptionRequestLanguageEnum.ca;
        case r'cs':
          return StartTranscriptionRequestLanguageEnum.cs;
        case r'da':
          return StartTranscriptionRequestLanguageEnum.da;
        case r'el':
          return StartTranscriptionRequestLanguageEnum.el;
        case r'fi':
          return StartTranscriptionRequestLanguageEnum.fi;
        case r'id':
          return StartTranscriptionRequestLanguageEnum.id;
        case r'ja':
          return StartTranscriptionRequestLanguageEnum.ja;
        case r'ru':
          return StartTranscriptionRequestLanguageEnum.ru;
        case r'sv':
          return StartTranscriptionRequestLanguageEnum.sv;
        case r'ta':
          return StartTranscriptionRequestLanguageEnum.ta;
        case r'th':
          return StartTranscriptionRequestLanguageEnum.th;
        case r'tr':
          return StartTranscriptionRequestLanguageEnum.tr;
        case r'hu':
          return StartTranscriptionRequestLanguageEnum.hu;
        case r'ro':
          return StartTranscriptionRequestLanguageEnum.ro;
        case r'zh':
          return StartTranscriptionRequestLanguageEnum.zh;
        case r'ar':
          return StartTranscriptionRequestLanguageEnum.ar;
        case r'tl':
          return StartTranscriptionRequestLanguageEnum.tl;
        case r'he':
          return StartTranscriptionRequestLanguageEnum.he;
        case r'hi':
          return StartTranscriptionRequestLanguageEnum.hi;
        case r'hr':
          return StartTranscriptionRequestLanguageEnum.hr;
        case r'ko':
          return StartTranscriptionRequestLanguageEnum.ko;
        case r'ms':
          return StartTranscriptionRequestLanguageEnum.ms;
        case r'no':
          return StartTranscriptionRequestLanguageEnum.no;
        case r'uk':
          return StartTranscriptionRequestLanguageEnum.uk;
        case r'bg':
          return StartTranscriptionRequestLanguageEnum.bg;
        case r'et':
          return StartTranscriptionRequestLanguageEnum.et;
        case r'sl':
          return StartTranscriptionRequestLanguageEnum.sl;
        case r'sk':
          return StartTranscriptionRequestLanguageEnum.sk;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [StartTranscriptionRequestLanguageEnumTypeTransformer] instance.
  static StartTranscriptionRequestLanguageEnumTypeTransformer? _instance;
}
