//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TranscriptionSettingsRequest {
  /// Returns a new [TranscriptionSettingsRequest] instance.
  TranscriptionSettingsRequest({
    this.closedCaptionMode,
    this.language,
    required this.mode,
  });

  TranscriptionSettingsRequestClosedCaptionModeEnum? closedCaptionMode;

  TranscriptionSettingsRequestLanguageEnum? language;

  TranscriptionSettingsRequestModeEnum mode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranscriptionSettingsRequest &&
          other.closedCaptionMode == closedCaptionMode &&
          other.language == language &&
          other.mode == mode;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (closedCaptionMode == null ? 0 : closedCaptionMode!.hashCode) +
      (language == null ? 0 : language!.hashCode) +
      (mode.hashCode);

  @override
  String toString() =>
      'TranscriptionSettingsRequest[closedCaptionMode=$closedCaptionMode, language=$language, mode=$mode]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.closedCaptionMode != null) {
      json[r'closed_caption_mode'] = this.closedCaptionMode;
    } else {
      json[r'closed_caption_mode'] = null;
    }
    if (this.language != null) {
      json[r'language'] = this.language;
    } else {
      json[r'language'] = null;
    }
    json[r'mode'] = this.mode;
    return json;
  }

  /// Returns a new [TranscriptionSettingsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TranscriptionSettingsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "TranscriptionSettingsRequest[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "TranscriptionSettingsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return TranscriptionSettingsRequest(
        closedCaptionMode:
            TranscriptionSettingsRequestClosedCaptionModeEnum.fromJson(
                json[r'closed_caption_mode']),
        language: TranscriptionSettingsRequestLanguageEnum.fromJson(
            json[r'language']),
        mode: TranscriptionSettingsRequestModeEnum.fromJson(json[r'mode'])!,
      );
    }
    return null;
  }

  static List<TranscriptionSettingsRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <TranscriptionSettingsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TranscriptionSettingsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TranscriptionSettingsRequest> mapFromJson(dynamic json) {
    final map = <String, TranscriptionSettingsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TranscriptionSettingsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TranscriptionSettingsRequest-objects as value to a dart map
  static Map<String, List<TranscriptionSettingsRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<TranscriptionSettingsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TranscriptionSettingsRequest.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'mode',
  };
}

class TranscriptionSettingsRequestClosedCaptionModeEnum {
  /// Instantiate a new enum with the provided [value].
  const TranscriptionSettingsRequestClosedCaptionModeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const available =
      TranscriptionSettingsRequestClosedCaptionModeEnum._(r'available');
  static const disabled =
      TranscriptionSettingsRequestClosedCaptionModeEnum._(r'disabled');
  static const autoOn =
      TranscriptionSettingsRequestClosedCaptionModeEnum._(r'auto-on');

  /// List of all possible values in this [enum][TranscriptionSettingsRequestClosedCaptionModeEnum].
  static const values = <TranscriptionSettingsRequestClosedCaptionModeEnum>[
    available,
    disabled,
    autoOn,
  ];

  static TranscriptionSettingsRequestClosedCaptionModeEnum? fromJson(
          dynamic value) =>
      TranscriptionSettingsRequestClosedCaptionModeEnumTypeTransformer()
          .decode(value);

  static List<TranscriptionSettingsRequestClosedCaptionModeEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <TranscriptionSettingsRequestClosedCaptionModeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value =
            TranscriptionSettingsRequestClosedCaptionModeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [TranscriptionSettingsRequestClosedCaptionModeEnum] to String,
/// and [decode] dynamic data back to [TranscriptionSettingsRequestClosedCaptionModeEnum].
class TranscriptionSettingsRequestClosedCaptionModeEnumTypeTransformer {
  factory TranscriptionSettingsRequestClosedCaptionModeEnumTypeTransformer() =>
      _instance ??=
          const TranscriptionSettingsRequestClosedCaptionModeEnumTypeTransformer
              ._();

  const TranscriptionSettingsRequestClosedCaptionModeEnumTypeTransformer._();

  String encode(TranscriptionSettingsRequestClosedCaptionModeEnum data) =>
      data.value;

  /// Decodes a [dynamic value][data] to a TranscriptionSettingsRequestClosedCaptionModeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  TranscriptionSettingsRequestClosedCaptionModeEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'available':
          return TranscriptionSettingsRequestClosedCaptionModeEnum.available;
        case r'disabled':
          return TranscriptionSettingsRequestClosedCaptionModeEnum.disabled;
        case r'auto-on':
          return TranscriptionSettingsRequestClosedCaptionModeEnum.autoOn;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [TranscriptionSettingsRequestClosedCaptionModeEnumTypeTransformer] instance.
  static TranscriptionSettingsRequestClosedCaptionModeEnumTypeTransformer?
      _instance;
}

class TranscriptionSettingsRequestLanguageEnum {
  /// Instantiate a new enum with the provided [value].
  const TranscriptionSettingsRequestLanguageEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const auto = TranscriptionSettingsRequestLanguageEnum._(r'auto');
  static const en = TranscriptionSettingsRequestLanguageEnum._(r'en');
  static const fr = TranscriptionSettingsRequestLanguageEnum._(r'fr');
  static const es = TranscriptionSettingsRequestLanguageEnum._(r'es');
  static const de = TranscriptionSettingsRequestLanguageEnum._(r'de');
  static const it = TranscriptionSettingsRequestLanguageEnum._(r'it');
  static const nl = TranscriptionSettingsRequestLanguageEnum._(r'nl');
  static const pt = TranscriptionSettingsRequestLanguageEnum._(r'pt');
  static const pl = TranscriptionSettingsRequestLanguageEnum._(r'pl');
  static const ca = TranscriptionSettingsRequestLanguageEnum._(r'ca');
  static const cs = TranscriptionSettingsRequestLanguageEnum._(r'cs');
  static const da = TranscriptionSettingsRequestLanguageEnum._(r'da');
  static const el = TranscriptionSettingsRequestLanguageEnum._(r'el');
  static const fi = TranscriptionSettingsRequestLanguageEnum._(r'fi');
  static const id = TranscriptionSettingsRequestLanguageEnum._(r'id');
  static const ja = TranscriptionSettingsRequestLanguageEnum._(r'ja');
  static const ru = TranscriptionSettingsRequestLanguageEnum._(r'ru');
  static const sv = TranscriptionSettingsRequestLanguageEnum._(r'sv');
  static const ta = TranscriptionSettingsRequestLanguageEnum._(r'ta');
  static const th = TranscriptionSettingsRequestLanguageEnum._(r'th');
  static const tr = TranscriptionSettingsRequestLanguageEnum._(r'tr');
  static const hu = TranscriptionSettingsRequestLanguageEnum._(r'hu');
  static const ro = TranscriptionSettingsRequestLanguageEnum._(r'ro');
  static const zh = TranscriptionSettingsRequestLanguageEnum._(r'zh');
  static const ar = TranscriptionSettingsRequestLanguageEnum._(r'ar');
  static const tl = TranscriptionSettingsRequestLanguageEnum._(r'tl');
  static const he = TranscriptionSettingsRequestLanguageEnum._(r'he');
  static const hi = TranscriptionSettingsRequestLanguageEnum._(r'hi');
  static const hr = TranscriptionSettingsRequestLanguageEnum._(r'hr');
  static const ko = TranscriptionSettingsRequestLanguageEnum._(r'ko');
  static const ms = TranscriptionSettingsRequestLanguageEnum._(r'ms');
  static const no = TranscriptionSettingsRequestLanguageEnum._(r'no');
  static const uk = TranscriptionSettingsRequestLanguageEnum._(r'uk');

  /// List of all possible values in this [enum][TranscriptionSettingsRequestLanguageEnum].
  static const values = <TranscriptionSettingsRequestLanguageEnum>[
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

  static TranscriptionSettingsRequestLanguageEnum? fromJson(dynamic value) =>
      TranscriptionSettingsRequestLanguageEnumTypeTransformer().decode(value);

  static List<TranscriptionSettingsRequestLanguageEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <TranscriptionSettingsRequestLanguageEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TranscriptionSettingsRequestLanguageEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [TranscriptionSettingsRequestLanguageEnum] to String,
/// and [decode] dynamic data back to [TranscriptionSettingsRequestLanguageEnum].
class TranscriptionSettingsRequestLanguageEnumTypeTransformer {
  factory TranscriptionSettingsRequestLanguageEnumTypeTransformer() =>
      _instance ??=
          const TranscriptionSettingsRequestLanguageEnumTypeTransformer._();

  const TranscriptionSettingsRequestLanguageEnumTypeTransformer._();

  String encode(TranscriptionSettingsRequestLanguageEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a TranscriptionSettingsRequestLanguageEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  TranscriptionSettingsRequestLanguageEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'auto':
          return TranscriptionSettingsRequestLanguageEnum.auto;
        case r'en':
          return TranscriptionSettingsRequestLanguageEnum.en;
        case r'fr':
          return TranscriptionSettingsRequestLanguageEnum.fr;
        case r'es':
          return TranscriptionSettingsRequestLanguageEnum.es;
        case r'de':
          return TranscriptionSettingsRequestLanguageEnum.de;
        case r'it':
          return TranscriptionSettingsRequestLanguageEnum.it;
        case r'nl':
          return TranscriptionSettingsRequestLanguageEnum.nl;
        case r'pt':
          return TranscriptionSettingsRequestLanguageEnum.pt;
        case r'pl':
          return TranscriptionSettingsRequestLanguageEnum.pl;
        case r'ca':
          return TranscriptionSettingsRequestLanguageEnum.ca;
        case r'cs':
          return TranscriptionSettingsRequestLanguageEnum.cs;
        case r'da':
          return TranscriptionSettingsRequestLanguageEnum.da;
        case r'el':
          return TranscriptionSettingsRequestLanguageEnum.el;
        case r'fi':
          return TranscriptionSettingsRequestLanguageEnum.fi;
        case r'id':
          return TranscriptionSettingsRequestLanguageEnum.id;
        case r'ja':
          return TranscriptionSettingsRequestLanguageEnum.ja;
        case r'ru':
          return TranscriptionSettingsRequestLanguageEnum.ru;
        case r'sv':
          return TranscriptionSettingsRequestLanguageEnum.sv;
        case r'ta':
          return TranscriptionSettingsRequestLanguageEnum.ta;
        case r'th':
          return TranscriptionSettingsRequestLanguageEnum.th;
        case r'tr':
          return TranscriptionSettingsRequestLanguageEnum.tr;
        case r'hu':
          return TranscriptionSettingsRequestLanguageEnum.hu;
        case r'ro':
          return TranscriptionSettingsRequestLanguageEnum.ro;
        case r'zh':
          return TranscriptionSettingsRequestLanguageEnum.zh;
        case r'ar':
          return TranscriptionSettingsRequestLanguageEnum.ar;
        case r'tl':
          return TranscriptionSettingsRequestLanguageEnum.tl;
        case r'he':
          return TranscriptionSettingsRequestLanguageEnum.he;
        case r'hi':
          return TranscriptionSettingsRequestLanguageEnum.hi;
        case r'hr':
          return TranscriptionSettingsRequestLanguageEnum.hr;
        case r'ko':
          return TranscriptionSettingsRequestLanguageEnum.ko;
        case r'ms':
          return TranscriptionSettingsRequestLanguageEnum.ms;
        case r'no':
          return TranscriptionSettingsRequestLanguageEnum.no;
        case r'uk':
          return TranscriptionSettingsRequestLanguageEnum.uk;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [TranscriptionSettingsRequestLanguageEnumTypeTransformer] instance.
  static TranscriptionSettingsRequestLanguageEnumTypeTransformer? _instance;
}

class TranscriptionSettingsRequestModeEnum {
  /// Instantiate a new enum with the provided [value].
  const TranscriptionSettingsRequestModeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const available = TranscriptionSettingsRequestModeEnum._(r'available');
  static const disabled = TranscriptionSettingsRequestModeEnum._(r'disabled');
  static const autoOn = TranscriptionSettingsRequestModeEnum._(r'auto-on');

  /// List of all possible values in this [enum][TranscriptionSettingsRequestModeEnum].
  static const values = <TranscriptionSettingsRequestModeEnum>[
    available,
    disabled,
    autoOn,
  ];

  static TranscriptionSettingsRequestModeEnum? fromJson(dynamic value) =>
      TranscriptionSettingsRequestModeEnumTypeTransformer().decode(value);

  static List<TranscriptionSettingsRequestModeEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <TranscriptionSettingsRequestModeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TranscriptionSettingsRequestModeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [TranscriptionSettingsRequestModeEnum] to String,
/// and [decode] dynamic data back to [TranscriptionSettingsRequestModeEnum].
class TranscriptionSettingsRequestModeEnumTypeTransformer {
  factory TranscriptionSettingsRequestModeEnumTypeTransformer() => _instance ??=
      const TranscriptionSettingsRequestModeEnumTypeTransformer._();

  const TranscriptionSettingsRequestModeEnumTypeTransformer._();

  String encode(TranscriptionSettingsRequestModeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a TranscriptionSettingsRequestModeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  TranscriptionSettingsRequestModeEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'available':
          return TranscriptionSettingsRequestModeEnum.available;
        case r'disabled':
          return TranscriptionSettingsRequestModeEnum.disabled;
        case r'auto-on':
          return TranscriptionSettingsRequestModeEnum.autoOn;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [TranscriptionSettingsRequestModeEnumTypeTransformer] instance.
  static TranscriptionSettingsRequestModeEnumTypeTransformer? _instance;
}
