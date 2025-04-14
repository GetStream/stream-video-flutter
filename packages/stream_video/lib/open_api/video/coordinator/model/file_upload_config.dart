//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FileUploadConfig {
  /// Returns a new [FileUploadConfig] instance.
  FileUploadConfig({
    this.allowedFileExtensions = const [],
    this.allowedMimeTypes = const [],
    this.blockedFileExtensions = const [],
    this.blockedMimeTypes = const [],
    required this.sizeLimit,
  });

  List<String> allowedFileExtensions;

  List<String> allowedMimeTypes;

  List<String> blockedFileExtensions;

  List<String> blockedMimeTypes;

  /// Minimum value: 0
  /// Maximum value: 104857600
  int sizeLimit;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileUploadConfig &&
          _deepEquality.equals(
              other.allowedFileExtensions, allowedFileExtensions) &&
          _deepEquality.equals(other.allowedMimeTypes, allowedMimeTypes) &&
          _deepEquality.equals(
              other.blockedFileExtensions, blockedFileExtensions) &&
          _deepEquality.equals(other.blockedMimeTypes, blockedMimeTypes) &&
          other.sizeLimit == sizeLimit;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (allowedFileExtensions.hashCode) +
      (allowedMimeTypes.hashCode) +
      (blockedFileExtensions.hashCode) +
      (blockedMimeTypes.hashCode) +
      (sizeLimit.hashCode);

  @override
  String toString() =>
      'FileUploadConfig[allowedFileExtensions=$allowedFileExtensions, allowedMimeTypes=$allowedMimeTypes, blockedFileExtensions=$blockedFileExtensions, blockedMimeTypes=$blockedMimeTypes, sizeLimit=$sizeLimit]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'allowed_file_extensions'] = this.allowedFileExtensions;
    json[r'allowed_mime_types'] = this.allowedMimeTypes;
    json[r'blocked_file_extensions'] = this.blockedFileExtensions;
    json[r'blocked_mime_types'] = this.blockedMimeTypes;
    json[r'size_limit'] = this.sizeLimit;
    return json;
  }

  /// Returns a new [FileUploadConfig] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FileUploadConfig? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "FileUploadConfig[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "FileUploadConfig[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return FileUploadConfig(
        allowedFileExtensions: json[r'allowed_file_extensions'] is Iterable
            ? (json[r'allowed_file_extensions'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        allowedMimeTypes: json[r'allowed_mime_types'] is Iterable
            ? (json[r'allowed_mime_types'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        blockedFileExtensions: json[r'blocked_file_extensions'] is Iterable
            ? (json[r'blocked_file_extensions'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        blockedMimeTypes: json[r'blocked_mime_types'] is Iterable
            ? (json[r'blocked_mime_types'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        sizeLimit: mapValueOfType<int>(json, r'size_limit')!,
      );
    }
    return null;
  }

  static List<FileUploadConfig> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <FileUploadConfig>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FileUploadConfig.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FileUploadConfig> mapFromJson(dynamic json) {
    final map = <String, FileUploadConfig>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FileUploadConfig.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FileUploadConfig-objects as value to a dart map
  static Map<String, List<FileUploadConfig>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<FileUploadConfig>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FileUploadConfig.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'allowed_file_extensions',
    'allowed_mime_types',
    'blocked_file_extensions',
    'blocked_mime_types',
    'size_limit',
  };
}
