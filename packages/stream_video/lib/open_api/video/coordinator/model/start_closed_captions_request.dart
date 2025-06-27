//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class StartClosedCaptionsRequest {
  /// Returns a new [StartClosedCaptionsRequest] instance.
  StartClosedCaptionsRequest({
    this.enableTranscription,
    this.externalStorage,
    this.language,
  });

  /// Enable transcriptions along with closed captions
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? enableTranscription;

  /// Which external storage to use for transcriptions (only applicable if enable_transcription is true)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? externalStorage;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  StartClosedCaptionsRequestLanguageEnum? language;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StartClosedCaptionsRequest &&
          other.enableTranscription == enableTranscription &&
          other.externalStorage == externalStorage &&
          other.language == language;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (enableTranscription == null ? 0 : enableTranscription!.hashCode) +
      (externalStorage == null ? 0 : externalStorage!.hashCode) +
      (language == null ? 0 : language!.hashCode);

  @override
  String toString() =>
      'StartClosedCaptionsRequest[enableTranscription=$enableTranscription, externalStorage=$externalStorage, language=$language]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.enableTranscription != null) {
      json[r'enable_transcription'] = this.enableTranscription;
    } else {
      json[r'enable_transcription'] = null;
    }
    if (this.externalStorage != null) {
      json[r'external_storage'] = this.externalStorage;
    } else {
      json[r'external_storage'] = null;
    }
    if (this.language != null) {
      json[r'language'] = this.language;
    } else {
      json[r'language'] = null;
    }
    return json;
  }

  /// Returns a new [StartClosedCaptionsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static StartClosedCaptionsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "StartClosedCaptionsRequest[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "StartClosedCaptionsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return StartClosedCaptionsRequest(
        enableTranscription:
            mapValueOfType<bool>(json, r'enable_transcription'),
        externalStorage: mapValueOfType<String>(json, r'external_storage'),
        language:
            StartClosedCaptionsRequestLanguageEnum.fromJson(json[r'language']),
      );
    }
    return null;
  }

  static List<StartClosedCaptionsRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <StartClosedCaptionsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = StartClosedCaptionsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, StartClosedCaptionsRequest> mapFromJson(dynamic json) {
    final map = <String, StartClosedCaptionsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = StartClosedCaptionsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of StartClosedCaptionsRequest-objects as value to a dart map
  static Map<String, List<StartClosedCaptionsRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<StartClosedCaptionsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = StartClosedCaptionsRequest.listFromJson(
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
class StartClosedCaptionsRequestLanguageEnum {
  /// Instantiate a new enum with the provided [value].
  const StartClosedCaptionsRequestLanguageEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const auto = StartClosedCaptionsRequestLanguageEnum._(r'auto');
  static const en = StartClosedCaptionsRequestLanguageEnum._(r'en');
  static const fr = StartClosedCaptionsRequestLanguageEnum._(r'fr');
  static const es = StartClosedCaptionsRequestLanguageEnum._(r'es');
  static const de = StartClosedCaptionsRequestLanguageEnum._(r'de');
  static const it = StartClosedCaptionsRequestLanguageEnum._(r'it');
  static const nl = StartClosedCaptionsRequestLanguageEnum._(r'nl');
  static const pt = StartClosedCaptionsRequestLanguageEnum._(r'pt');
  static const pl = StartClosedCaptionsRequestLanguageEnum._(r'pl');
  static const ca = StartClosedCaptionsRequestLanguageEnum._(r'ca');
  static const cs = StartClosedCaptionsRequestLanguageEnum._(r'cs');
  static const da = StartClosedCaptionsRequestLanguageEnum._(r'da');
  static const el = StartClosedCaptionsRequestLanguageEnum._(r'el');
  static const fi = StartClosedCaptionsRequestLanguageEnum._(r'fi');
  static const id = StartClosedCaptionsRequestLanguageEnum._(r'id');
  static const ja = StartClosedCaptionsRequestLanguageEnum._(r'ja');
  static const ru = StartClosedCaptionsRequestLanguageEnum._(r'ru');
  static const sv = StartClosedCaptionsRequestLanguageEnum._(r'sv');
  static const ta = StartClosedCaptionsRequestLanguageEnum._(r'ta');
  static const th = StartClosedCaptionsRequestLanguageEnum._(r'th');
  static const tr = StartClosedCaptionsRequestLanguageEnum._(r'tr');
  static const hu = StartClosedCaptionsRequestLanguageEnum._(r'hu');
  static const ro = StartClosedCaptionsRequestLanguageEnum._(r'ro');
  static const zh = StartClosedCaptionsRequestLanguageEnum._(r'zh');
  static const ar = StartClosedCaptionsRequestLanguageEnum._(r'ar');
  static const tl = StartClosedCaptionsRequestLanguageEnum._(r'tl');
  static const he = StartClosedCaptionsRequestLanguageEnum._(r'he');
  static const hi = StartClosedCaptionsRequestLanguageEnum._(r'hi');
  static const hr = StartClosedCaptionsRequestLanguageEnum._(r'hr');
  static const ko = StartClosedCaptionsRequestLanguageEnum._(r'ko');
  static const ms = StartClosedCaptionsRequestLanguageEnum._(r'ms');
  static const no = StartClosedCaptionsRequestLanguageEnum._(r'no');
  static const uk = StartClosedCaptionsRequestLanguageEnum._(r'uk');
  static const bg = StartClosedCaptionsRequestLanguageEnum._(r'bg');
  static const et = StartClosedCaptionsRequestLanguageEnum._(r'et');
  static const sl = StartClosedCaptionsRequestLanguageEnum._(r'sl');
  static const sk = StartClosedCaptionsRequestLanguageEnum._(r'sk');

  /// List of all possible values in this [enum][StartClosedCaptionsRequestLanguageEnum].
  static const values = <StartClosedCaptionsRequestLanguageEnum>[
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

  static StartClosedCaptionsRequestLanguageEnum? fromJson(dynamic value) =>
      StartClosedCaptionsRequestLanguageEnumTypeTransformer().decode(value);

  static List<StartClosedCaptionsRequestLanguageEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <StartClosedCaptionsRequestLanguageEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = StartClosedCaptionsRequestLanguageEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [StartClosedCaptionsRequestLanguageEnum] to String,
/// and [decode] dynamic data back to [StartClosedCaptionsRequestLanguageEnum].
class StartClosedCaptionsRequestLanguageEnumTypeTransformer {
  factory StartClosedCaptionsRequestLanguageEnumTypeTransformer() =>
      _instance ??=
          const StartClosedCaptionsRequestLanguageEnumTypeTransformer._();

  const StartClosedCaptionsRequestLanguageEnumTypeTransformer._();

  String encode(StartClosedCaptionsRequestLanguageEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a StartClosedCaptionsRequestLanguageEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  StartClosedCaptionsRequestLanguageEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'auto':
          return StartClosedCaptionsRequestLanguageEnum.auto;
        case r'en':
          return StartClosedCaptionsRequestLanguageEnum.en;
        case r'fr':
          return StartClosedCaptionsRequestLanguageEnum.fr;
        case r'es':
          return StartClosedCaptionsRequestLanguageEnum.es;
        case r'de':
          return StartClosedCaptionsRequestLanguageEnum.de;
        case r'it':
          return StartClosedCaptionsRequestLanguageEnum.it;
        case r'nl':
          return StartClosedCaptionsRequestLanguageEnum.nl;
        case r'pt':
          return StartClosedCaptionsRequestLanguageEnum.pt;
        case r'pl':
          return StartClosedCaptionsRequestLanguageEnum.pl;
        case r'ca':
          return StartClosedCaptionsRequestLanguageEnum.ca;
        case r'cs':
          return StartClosedCaptionsRequestLanguageEnum.cs;
        case r'da':
          return StartClosedCaptionsRequestLanguageEnum.da;
        case r'el':
          return StartClosedCaptionsRequestLanguageEnum.el;
        case r'fi':
          return StartClosedCaptionsRequestLanguageEnum.fi;
        case r'id':
          return StartClosedCaptionsRequestLanguageEnum.id;
        case r'ja':
          return StartClosedCaptionsRequestLanguageEnum.ja;
        case r'ru':
          return StartClosedCaptionsRequestLanguageEnum.ru;
        case r'sv':
          return StartClosedCaptionsRequestLanguageEnum.sv;
        case r'ta':
          return StartClosedCaptionsRequestLanguageEnum.ta;
        case r'th':
          return StartClosedCaptionsRequestLanguageEnum.th;
        case r'tr':
          return StartClosedCaptionsRequestLanguageEnum.tr;
        case r'hu':
          return StartClosedCaptionsRequestLanguageEnum.hu;
        case r'ro':
          return StartClosedCaptionsRequestLanguageEnum.ro;
        case r'zh':
          return StartClosedCaptionsRequestLanguageEnum.zh;
        case r'ar':
          return StartClosedCaptionsRequestLanguageEnum.ar;
        case r'tl':
          return StartClosedCaptionsRequestLanguageEnum.tl;
        case r'he':
          return StartClosedCaptionsRequestLanguageEnum.he;
        case r'hi':
          return StartClosedCaptionsRequestLanguageEnum.hi;
        case r'hr':
          return StartClosedCaptionsRequestLanguageEnum.hr;
        case r'ko':
          return StartClosedCaptionsRequestLanguageEnum.ko;
        case r'ms':
          return StartClosedCaptionsRequestLanguageEnum.ms;
        case r'no':
          return StartClosedCaptionsRequestLanguageEnum.no;
        case r'uk':
          return StartClosedCaptionsRequestLanguageEnum.uk;
        case r'bg':
          return StartClosedCaptionsRequestLanguageEnum.bg;
        case r'et':
          return StartClosedCaptionsRequestLanguageEnum.et;
        case r'sl':
          return StartClosedCaptionsRequestLanguageEnum.sl;
        case r'sk':
          return StartClosedCaptionsRequestLanguageEnum.sk;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [StartClosedCaptionsRequestLanguageEnumTypeTransformer] instance.
  static StartClosedCaptionsRequestLanguageEnumTypeTransformer? _instance;
}
