//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SendReactionRequest {
  /// Returns a new [SendReactionRequest] instance.
  SendReactionRequest({
    this.custom = const {},
    this.emojiCode,
    required this.type,
  });

  Map<String, Object> custom;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? emojiCode;

  String type;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SendReactionRequest &&
     other.custom == custom &&
     other.emojiCode == emojiCode &&
     other.type == type;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (custom.hashCode) +
    (emojiCode == null ? 0 : emojiCode!.hashCode) +
    (type.hashCode);

  @override
  String toString() => 'SendReactionRequest[custom=$custom, emojiCode=$emojiCode, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'custom'] = this.custom;
    if (this.emojiCode != null) {
      json[r'emoji_code'] = this.emojiCode;
    } else {
      json[r'emoji_code'] = null;
    }
      json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [SendReactionRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SendReactionRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "SendReactionRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "SendReactionRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return SendReactionRequest(
        custom: mapCastOfType<String, Object>(json, r'custom') ?? const {},
        emojiCode: mapValueOfType<String>(json, r'emoji_code'),
        type: mapValueOfType<String>(json, r'type')!,
      );
    }
    return null;
  }

  static List<SendReactionRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SendReactionRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SendReactionRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SendReactionRequest> mapFromJson(dynamic json) {
    final map = <String, SendReactionRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SendReactionRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SendReactionRequest-objects as value to a dart map
  static Map<String, List<SendReactionRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SendReactionRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SendReactionRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'type',
  };
}

