//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TranscriptionSettingsResponse {
  /// Returns a new [TranscriptionSettingsResponse] instance.
  TranscriptionSettingsResponse({
    required this.closedCaptionMode,
    required this.language,
    required this.mode,
  });

  TranscriptionSettingsResponseClosedCaptionModeEnum closedCaptionMode;

  TranscriptionSettingsResponseLanguageEnum language;

  TranscriptionSettingsResponseModeEnum mode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranscriptionSettingsResponse &&
          other.closedCaptionMode == closedCaptionMode &&
          other.language == language &&
          other.mode == mode;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (closedCaptionMode.hashCode) + (language.hashCode) + (mode.hashCode);

  @override
  String toString() =>
      'TranscriptionSettingsResponse[closedCaptionMode=$closedCaptionMode, language=$language, mode=$mode]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'closed_caption_mode'] = this.closedCaptionMode;
    json[r'language'] = this.language;
    json[r'mode'] = this.mode;
    return json;
  }

  /// Returns a new [TranscriptionSettingsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TranscriptionSettingsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "TranscriptionSettingsResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "TranscriptionSettingsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return TranscriptionSettingsResponse(
        closedCaptionMode:
            TranscriptionSettingsResponseClosedCaptionModeEnum.fromJson(
                json[r'closed_caption_mode'])!,
        //MANUAL_EDIT: default value added since sometimes language came as an empty string
        language: TranscriptionSettingsResponseLanguageEnum.fromJson(
                json[r'language']) ??
            TranscriptionSettingsResponseLanguageEnum.auto,
        mode: TranscriptionSettingsResponseModeEnum.fromJson(json[r'mode'])!,
      );
    }
    return null;
  }

  static List<TranscriptionSettingsResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <TranscriptionSettingsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TranscriptionSettingsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TranscriptionSettingsResponse> mapFromJson(dynamic json) {
    final map = <String, TranscriptionSettingsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TranscriptionSettingsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TranscriptionSettingsResponse-objects as value to a dart map
  static Map<String, List<TranscriptionSettingsResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<TranscriptionSettingsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TranscriptionSettingsResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'closed_caption_mode',
    'language',
    'mode',
  };
}

class TranscriptionSettingsResponseClosedCaptionModeEnum {
  /// Instantiate a new enum with the provided [value].
  const TranscriptionSettingsResponseClosedCaptionModeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const available =
      TranscriptionSettingsResponseClosedCaptionModeEnum._(r'available');
  static const disabled =
      TranscriptionSettingsResponseClosedCaptionModeEnum._(r'disabled');
  static const autoOn =
      TranscriptionSettingsResponseClosedCaptionModeEnum._(r'auto-on');

  /// List of all possible values in this [enum][TranscriptionSettingsResponseClosedCaptionModeEnum].
  static const values = <TranscriptionSettingsResponseClosedCaptionModeEnum>[
    available,
    disabled,
    autoOn,
  ];

  static TranscriptionSettingsResponseClosedCaptionModeEnum? fromJson(
          dynamic value) =>
      TranscriptionSettingsResponseClosedCaptionModeEnumTypeTransformer()
          .decode(value);

  static List<TranscriptionSettingsResponseClosedCaptionModeEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <TranscriptionSettingsResponseClosedCaptionModeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value =
            TranscriptionSettingsResponseClosedCaptionModeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [TranscriptionSettingsResponseClosedCaptionModeEnum] to String,
/// and [decode] dynamic data back to [TranscriptionSettingsResponseClosedCaptionModeEnum].
class TranscriptionSettingsResponseClosedCaptionModeEnumTypeTransformer {
  factory TranscriptionSettingsResponseClosedCaptionModeEnumTypeTransformer() =>
      _instance ??=
          const TranscriptionSettingsResponseClosedCaptionModeEnumTypeTransformer
              ._();

  const TranscriptionSettingsResponseClosedCaptionModeEnumTypeTransformer._();

  String encode(TranscriptionSettingsResponseClosedCaptionModeEnum data) =>
      data.value;

  /// Decodes a [dynamic value][data] to a TranscriptionSettingsResponseClosedCaptionModeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  TranscriptionSettingsResponseClosedCaptionModeEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'available':
          return TranscriptionSettingsResponseClosedCaptionModeEnum.available;
        case r'disabled':
          return TranscriptionSettingsResponseClosedCaptionModeEnum.disabled;
        case r'auto-on':
          return TranscriptionSettingsResponseClosedCaptionModeEnum.autoOn;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [TranscriptionSettingsResponseClosedCaptionModeEnumTypeTransformer] instance.
  static TranscriptionSettingsResponseClosedCaptionModeEnumTypeTransformer?
      _instance;
}

class TranscriptionSettingsResponseLanguageEnum {
  /// Instantiate a new enum with the provided [value].
  const TranscriptionSettingsResponseLanguageEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const auto = TranscriptionSettingsResponseLanguageEnum._(r'auto');
  static const en = TranscriptionSettingsResponseLanguageEnum._(r'en');
  static const fr = TranscriptionSettingsResponseLanguageEnum._(r'fr');
  static const es = TranscriptionSettingsResponseLanguageEnum._(r'es');
  static const de = TranscriptionSettingsResponseLanguageEnum._(r'de');
  static const it = TranscriptionSettingsResponseLanguageEnum._(r'it');
  static const nl = TranscriptionSettingsResponseLanguageEnum._(r'nl');
  static const pt = TranscriptionSettingsResponseLanguageEnum._(r'pt');
  static const pl = TranscriptionSettingsResponseLanguageEnum._(r'pl');
  static const ca = TranscriptionSettingsResponseLanguageEnum._(r'ca');
  static const cs = TranscriptionSettingsResponseLanguageEnum._(r'cs');
  static const da = TranscriptionSettingsResponseLanguageEnum._(r'da');
  static const el = TranscriptionSettingsResponseLanguageEnum._(r'el');
  static const fi = TranscriptionSettingsResponseLanguageEnum._(r'fi');
  static const id = TranscriptionSettingsResponseLanguageEnum._(r'id');
  static const ja = TranscriptionSettingsResponseLanguageEnum._(r'ja');
  static const ru = TranscriptionSettingsResponseLanguageEnum._(r'ru');
  static const sv = TranscriptionSettingsResponseLanguageEnum._(r'sv');
  static const ta = TranscriptionSettingsResponseLanguageEnum._(r'ta');
  static const th = TranscriptionSettingsResponseLanguageEnum._(r'th');
  static const tr = TranscriptionSettingsResponseLanguageEnum._(r'tr');
  static const hu = TranscriptionSettingsResponseLanguageEnum._(r'hu');
  static const ro = TranscriptionSettingsResponseLanguageEnum._(r'ro');
  static const zh = TranscriptionSettingsResponseLanguageEnum._(r'zh');
  static const ar = TranscriptionSettingsResponseLanguageEnum._(r'ar');
  static const tl = TranscriptionSettingsResponseLanguageEnum._(r'tl');
  static const he = TranscriptionSettingsResponseLanguageEnum._(r'he');
  static const hi = TranscriptionSettingsResponseLanguageEnum._(r'hi');
  static const hr = TranscriptionSettingsResponseLanguageEnum._(r'hr');
  static const ko = TranscriptionSettingsResponseLanguageEnum._(r'ko');
  static const ms = TranscriptionSettingsResponseLanguageEnum._(r'ms');
  static const no = TranscriptionSettingsResponseLanguageEnum._(r'no');
  static const uk = TranscriptionSettingsResponseLanguageEnum._(r'uk');

  /// List of all possible values in this [enum][TranscriptionSettingsResponseLanguageEnum].
  static const values = <TranscriptionSettingsResponseLanguageEnum>[
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
  ];

  static TranscriptionSettingsResponseLanguageEnum? fromJson(dynamic value) =>
      TranscriptionSettingsResponseLanguageEnumTypeTransformer().decode(value);

  static List<TranscriptionSettingsResponseLanguageEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <TranscriptionSettingsResponseLanguageEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TranscriptionSettingsResponseLanguageEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [TranscriptionSettingsResponseLanguageEnum] to String,
/// and [decode] dynamic data back to [TranscriptionSettingsResponseLanguageEnum].
class TranscriptionSettingsResponseLanguageEnumTypeTransformer {
  factory TranscriptionSettingsResponseLanguageEnumTypeTransformer() =>
      _instance ??=
          const TranscriptionSettingsResponseLanguageEnumTypeTransformer._();

  const TranscriptionSettingsResponseLanguageEnumTypeTransformer._();

  String encode(TranscriptionSettingsResponseLanguageEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a TranscriptionSettingsResponseLanguageEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  TranscriptionSettingsResponseLanguageEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'auto':
          return TranscriptionSettingsResponseLanguageEnum.auto;
        case r'en':
          return TranscriptionSettingsResponseLanguageEnum.en;
        case r'fr':
          return TranscriptionSettingsResponseLanguageEnum.fr;
        case r'es':
          return TranscriptionSettingsResponseLanguageEnum.es;
        case r'de':
          return TranscriptionSettingsResponseLanguageEnum.de;
        case r'it':
          return TranscriptionSettingsResponseLanguageEnum.it;
        case r'nl':
          return TranscriptionSettingsResponseLanguageEnum.nl;
        case r'pt':
          return TranscriptionSettingsResponseLanguageEnum.pt;
        case r'pl':
          return TranscriptionSettingsResponseLanguageEnum.pl;
        case r'ca':
          return TranscriptionSettingsResponseLanguageEnum.ca;
        case r'cs':
          return TranscriptionSettingsResponseLanguageEnum.cs;
        case r'da':
          return TranscriptionSettingsResponseLanguageEnum.da;
        case r'el':
          return TranscriptionSettingsResponseLanguageEnum.el;
        case r'fi':
          return TranscriptionSettingsResponseLanguageEnum.fi;
        case r'id':
          return TranscriptionSettingsResponseLanguageEnum.id;
        case r'ja':
          return TranscriptionSettingsResponseLanguageEnum.ja;
        case r'ru':
          return TranscriptionSettingsResponseLanguageEnum.ru;
        case r'sv':
          return TranscriptionSettingsResponseLanguageEnum.sv;
        case r'ta':
          return TranscriptionSettingsResponseLanguageEnum.ta;
        case r'th':
          return TranscriptionSettingsResponseLanguageEnum.th;
        case r'tr':
          return TranscriptionSettingsResponseLanguageEnum.tr;
        case r'hu':
          return TranscriptionSettingsResponseLanguageEnum.hu;
        case r'ro':
          return TranscriptionSettingsResponseLanguageEnum.ro;
        case r'zh':
          return TranscriptionSettingsResponseLanguageEnum.zh;
        case r'ar':
          return TranscriptionSettingsResponseLanguageEnum.ar;
        case r'tl':
          return TranscriptionSettingsResponseLanguageEnum.tl;
        case r'he':
          return TranscriptionSettingsResponseLanguageEnum.he;
        case r'hi':
          return TranscriptionSettingsResponseLanguageEnum.hi;
        case r'hr':
          return TranscriptionSettingsResponseLanguageEnum.hr;
        case r'ko':
          return TranscriptionSettingsResponseLanguageEnum.ko;
        case r'ms':
          return TranscriptionSettingsResponseLanguageEnum.ms;
        case r'no':
          return TranscriptionSettingsResponseLanguageEnum.no;
        case r'uk':
          return TranscriptionSettingsResponseLanguageEnum.uk;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [TranscriptionSettingsResponseLanguageEnumTypeTransformer] instance.
  static TranscriptionSettingsResponseLanguageEnumTypeTransformer? _instance;
}

class TranscriptionSettingsResponseModeEnum {
  /// Instantiate a new enum with the provided [value].
  const TranscriptionSettingsResponseModeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const available =
      TranscriptionSettingsResponseModeEnum._(r'available');
  static const disabled = TranscriptionSettingsResponseModeEnum._(r'disabled');
  static const autoOn = TranscriptionSettingsResponseModeEnum._(r'auto-on');

  /// List of all possible values in this [enum][TranscriptionSettingsResponseModeEnum].
  static const values = <TranscriptionSettingsResponseModeEnum>[
    available,
    disabled,
    autoOn,
  ];

  static TranscriptionSettingsResponseModeEnum? fromJson(dynamic value) =>
      TranscriptionSettingsResponseModeEnumTypeTransformer().decode(value);

  static List<TranscriptionSettingsResponseModeEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <TranscriptionSettingsResponseModeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TranscriptionSettingsResponseModeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [TranscriptionSettingsResponseModeEnum] to String,
/// and [decode] dynamic data back to [TranscriptionSettingsResponseModeEnum].
class TranscriptionSettingsResponseModeEnumTypeTransformer {
  factory TranscriptionSettingsResponseModeEnumTypeTransformer() =>
      _instance ??=
          const TranscriptionSettingsResponseModeEnumTypeTransformer._();

  const TranscriptionSettingsResponseModeEnumTypeTransformer._();

  String encode(TranscriptionSettingsResponseModeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a TranscriptionSettingsResponseModeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  TranscriptionSettingsResponseModeEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'available':
          return TranscriptionSettingsResponseModeEnum.available;
        case r'disabled':
          return TranscriptionSettingsResponseModeEnum.disabled;
        case r'auto-on':
          return TranscriptionSettingsResponseModeEnum.autoOn;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [TranscriptionSettingsResponseModeEnumTypeTransformer] instance.
  static TranscriptionSettingsResponseModeEnumTypeTransformer? _instance;
}
