//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TranslationSettings {
  /// Returns a new [TranslationSettings] instance.
  TranslationSettings({
    this.enabled,
    this.languages = const [],
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? enabled;

  List<TranslationSettingsLanguagesEnum> languages;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslationSettings &&
          other.enabled == enabled &&
          _deepEquality.equals(other.languages, languages);

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (enabled == null ? 0 : enabled!.hashCode) + (languages.hashCode);

  @override
  String toString() =>
      'TranslationSettings[enabled=$enabled, languages=$languages]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.enabled != null) {
      json[r'enabled'] = this.enabled;
    } else {
      json[r'enabled'] = null;
    }
    json[r'languages'] = this.languages;
    return json;
  }

  /// Returns a new [TranslationSettings] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TranslationSettings? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return TranslationSettings(
        enabled: mapValueOfType<bool>(json, r'enabled'),
        languages:
            TranslationSettingsLanguagesEnum.listFromJson(json[r'languages']),
      );
    }
    return null;
  }

  static List<TranslationSettings> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <TranslationSettings>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TranslationSettings.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TranslationSettings> mapFromJson(dynamic json) {
    final map = <String, TranslationSettings>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TranslationSettings.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TranslationSettings-objects as value to a dart map
  static Map<String, List<TranslationSettings>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<TranslationSettings>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TranslationSettings.listFromJson(
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

class TranslationSettingsLanguagesEnum {
  /// Instantiate a new enum with the provided [value].
  const TranslationSettingsLanguagesEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const en = TranslationSettingsLanguagesEnum._(r'en');
  static const fr = TranslationSettingsLanguagesEnum._(r'fr');
  static const es = TranslationSettingsLanguagesEnum._(r'es');
  static const de = TranslationSettingsLanguagesEnum._(r'de');
  static const it = TranslationSettingsLanguagesEnum._(r'it');
  static const nl = TranslationSettingsLanguagesEnum._(r'nl');
  static const pt = TranslationSettingsLanguagesEnum._(r'pt');
  static const pl = TranslationSettingsLanguagesEnum._(r'pl');
  static const ca = TranslationSettingsLanguagesEnum._(r'ca');
  static const cs = TranslationSettingsLanguagesEnum._(r'cs');
  static const da = TranslationSettingsLanguagesEnum._(r'da');
  static const el = TranslationSettingsLanguagesEnum._(r'el');
  static const fi = TranslationSettingsLanguagesEnum._(r'fi');
  static const id = TranslationSettingsLanguagesEnum._(r'id');
  static const ja = TranslationSettingsLanguagesEnum._(r'ja');
  static const ru = TranslationSettingsLanguagesEnum._(r'ru');
  static const sv = TranslationSettingsLanguagesEnum._(r'sv');
  static const ta = TranslationSettingsLanguagesEnum._(r'ta');
  static const th = TranslationSettingsLanguagesEnum._(r'th');
  static const tr = TranslationSettingsLanguagesEnum._(r'tr');
  static const hu = TranslationSettingsLanguagesEnum._(r'hu');
  static const ro = TranslationSettingsLanguagesEnum._(r'ro');
  static const zh = TranslationSettingsLanguagesEnum._(r'zh');
  static const ar = TranslationSettingsLanguagesEnum._(r'ar');
  static const tl = TranslationSettingsLanguagesEnum._(r'tl');
  static const he = TranslationSettingsLanguagesEnum._(r'he');
  static const hi = TranslationSettingsLanguagesEnum._(r'hi');
  static const hr = TranslationSettingsLanguagesEnum._(r'hr');
  static const ko = TranslationSettingsLanguagesEnum._(r'ko');
  static const ms = TranslationSettingsLanguagesEnum._(r'ms');
  static const no = TranslationSettingsLanguagesEnum._(r'no');
  static const uk = TranslationSettingsLanguagesEnum._(r'uk');

  /// List of all possible values in this [enum][TranslationSettingsLanguagesEnum].
  static const values = <TranslationSettingsLanguagesEnum>[
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

  static TranslationSettingsLanguagesEnum? fromJson(dynamic value) =>
      TranslationSettingsLanguagesEnumTypeTransformer().decode(value);

  static List<TranslationSettingsLanguagesEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <TranslationSettingsLanguagesEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TranslationSettingsLanguagesEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [TranslationSettingsLanguagesEnum] to String,
/// and [decode] dynamic data back to [TranslationSettingsLanguagesEnum].
class TranslationSettingsLanguagesEnumTypeTransformer {
  factory TranslationSettingsLanguagesEnumTypeTransformer() =>
      _instance ??= const TranslationSettingsLanguagesEnumTypeTransformer._();

  const TranslationSettingsLanguagesEnumTypeTransformer._();

  String encode(TranslationSettingsLanguagesEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a TranslationSettingsLanguagesEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  TranslationSettingsLanguagesEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'en':
          return TranslationSettingsLanguagesEnum.en;
        case r'fr':
          return TranslationSettingsLanguagesEnum.fr;
        case r'es':
          return TranslationSettingsLanguagesEnum.es;
        case r'de':
          return TranslationSettingsLanguagesEnum.de;
        case r'it':
          return TranslationSettingsLanguagesEnum.it;
        case r'nl':
          return TranslationSettingsLanguagesEnum.nl;
        case r'pt':
          return TranslationSettingsLanguagesEnum.pt;
        case r'pl':
          return TranslationSettingsLanguagesEnum.pl;
        case r'ca':
          return TranslationSettingsLanguagesEnum.ca;
        case r'cs':
          return TranslationSettingsLanguagesEnum.cs;
        case r'da':
          return TranslationSettingsLanguagesEnum.da;
        case r'el':
          return TranslationSettingsLanguagesEnum.el;
        case r'fi':
          return TranslationSettingsLanguagesEnum.fi;
        case r'id':
          return TranslationSettingsLanguagesEnum.id;
        case r'ja':
          return TranslationSettingsLanguagesEnum.ja;
        case r'ru':
          return TranslationSettingsLanguagesEnum.ru;
        case r'sv':
          return TranslationSettingsLanguagesEnum.sv;
        case r'ta':
          return TranslationSettingsLanguagesEnum.ta;
        case r'th':
          return TranslationSettingsLanguagesEnum.th;
        case r'tr':
          return TranslationSettingsLanguagesEnum.tr;
        case r'hu':
          return TranslationSettingsLanguagesEnum.hu;
        case r'ro':
          return TranslationSettingsLanguagesEnum.ro;
        case r'zh':
          return TranslationSettingsLanguagesEnum.zh;
        case r'ar':
          return TranslationSettingsLanguagesEnum.ar;
        case r'tl':
          return TranslationSettingsLanguagesEnum.tl;
        case r'he':
          return TranslationSettingsLanguagesEnum.he;
        case r'hi':
          return TranslationSettingsLanguagesEnum.hi;
        case r'hr':
          return TranslationSettingsLanguagesEnum.hr;
        case r'ko':
          return TranslationSettingsLanguagesEnum.ko;
        case r'ms':
          return TranslationSettingsLanguagesEnum.ms;
        case r'no':
          return TranslationSettingsLanguagesEnum.no;
        case r'uk':
          return TranslationSettingsLanguagesEnum.uk;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [TranslationSettingsLanguagesEnumTypeTransformer] instance.
  static TranslationSettingsLanguagesEnumTypeTransformer? _instance;
}
