//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AppEventResponse {
  /// Returns a new [AppEventResponse] instance.
  AppEventResponse({
    this.asyncUrlEnrichEnabled,
    required this.autoTranslationEnabled,
    this.fileUploadConfig,
    this.imageUploadConfig,
    required this.name,
  });

  /// boolean
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? asyncUrlEnrichEnabled;

  /// boolean
  bool autoTranslationEnabled;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  FileUploadConfig? fileUploadConfig;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  FileUploadConfig? imageUploadConfig;

  /// string
  String name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppEventResponse &&
          other.asyncUrlEnrichEnabled == asyncUrlEnrichEnabled &&
          other.autoTranslationEnabled == autoTranslationEnabled &&
          other.fileUploadConfig == fileUploadConfig &&
          other.imageUploadConfig == imageUploadConfig &&
          other.name == name;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (asyncUrlEnrichEnabled == null ? 0 : asyncUrlEnrichEnabled!.hashCode) +
      (autoTranslationEnabled.hashCode) +
      (fileUploadConfig == null ? 0 : fileUploadConfig!.hashCode) +
      (imageUploadConfig == null ? 0 : imageUploadConfig!.hashCode) +
      (name.hashCode);

  @override
  String toString() =>
      'AppEventResponse[asyncUrlEnrichEnabled=$asyncUrlEnrichEnabled, autoTranslationEnabled=$autoTranslationEnabled, fileUploadConfig=$fileUploadConfig, imageUploadConfig=$imageUploadConfig, name=$name]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.asyncUrlEnrichEnabled != null) {
      json[r'async_url_enrich_enabled'] = this.asyncUrlEnrichEnabled;
    } else {
      json[r'async_url_enrich_enabled'] = null;
    }
    json[r'auto_translation_enabled'] = this.autoTranslationEnabled;
    if (this.fileUploadConfig != null) {
      json[r'file_upload_config'] = this.fileUploadConfig;
    } else {
      json[r'file_upload_config'] = null;
    }
    if (this.imageUploadConfig != null) {
      json[r'image_upload_config'] = this.imageUploadConfig;
    } else {
      json[r'image_upload_config'] = null;
    }
    json[r'name'] = this.name;
    return json;
  }

  /// Returns a new [AppEventResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AppEventResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "AppEventResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "AppEventResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AppEventResponse(
        asyncUrlEnrichEnabled:
            mapValueOfType<bool>(json, r'async_url_enrich_enabled'),
        autoTranslationEnabled:
            mapValueOfType<bool>(json, r'auto_translation_enabled')!,
        fileUploadConfig:
            FileUploadConfig.fromJson(json[r'file_upload_config']),
        imageUploadConfig:
            FileUploadConfig.fromJson(json[r'image_upload_config']),
        name: mapValueOfType<String>(json, r'name')!,
      );
    }
    return null;
  }

  static List<AppEventResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <AppEventResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AppEventResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AppEventResponse> mapFromJson(dynamic json) {
    final map = <String, AppEventResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AppEventResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AppEventResponse-objects as value to a dart map
  static Map<String, List<AppEventResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<AppEventResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AppEventResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'auto_translation_enabled',
    'name',
  };
}
