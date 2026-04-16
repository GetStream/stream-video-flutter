//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ChatPreferencesResponse {
  /// Returns a new [ChatPreferencesResponse] instance.
  ChatPreferencesResponse({
    this.channelMentions,
    this.defaultPreference,
    this.directMentions,
    this.groupMentions,
    this.hereMentions,
    this.roleMentions,
    this.threadReplies,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? channelMentions;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? defaultPreference;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? directMentions;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? groupMentions;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? hereMentions;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? roleMentions;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? threadReplies;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatPreferencesResponse &&
          other.channelMentions == channelMentions &&
          other.defaultPreference == defaultPreference &&
          other.directMentions == directMentions &&
          other.groupMentions == groupMentions &&
          other.hereMentions == hereMentions &&
          other.roleMentions == roleMentions &&
          other.threadReplies == threadReplies;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (channelMentions == null ? 0 : channelMentions!.hashCode) +
      (defaultPreference == null ? 0 : defaultPreference!.hashCode) +
      (directMentions == null ? 0 : directMentions!.hashCode) +
      (groupMentions == null ? 0 : groupMentions!.hashCode) +
      (hereMentions == null ? 0 : hereMentions!.hashCode) +
      (roleMentions == null ? 0 : roleMentions!.hashCode) +
      (threadReplies == null ? 0 : threadReplies!.hashCode);

  @override
  String toString() =>
      'ChatPreferencesResponse[channelMentions=$channelMentions, defaultPreference=$defaultPreference, directMentions=$directMentions, groupMentions=$groupMentions, hereMentions=$hereMentions, roleMentions=$roleMentions, threadReplies=$threadReplies]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.channelMentions != null) {
      json[r'channel_mentions'] = this.channelMentions;
    } else {
      json[r'channel_mentions'] = null;
    }
    if (this.defaultPreference != null) {
      json[r'default_preference'] = this.defaultPreference;
    } else {
      json[r'default_preference'] = null;
    }
    if (this.directMentions != null) {
      json[r'direct_mentions'] = this.directMentions;
    } else {
      json[r'direct_mentions'] = null;
    }
    if (this.groupMentions != null) {
      json[r'group_mentions'] = this.groupMentions;
    } else {
      json[r'group_mentions'] = null;
    }
    if (this.hereMentions != null) {
      json[r'here_mentions'] = this.hereMentions;
    } else {
      json[r'here_mentions'] = null;
    }
    if (this.roleMentions != null) {
      json[r'role_mentions'] = this.roleMentions;
    } else {
      json[r'role_mentions'] = null;
    }
    if (this.threadReplies != null) {
      json[r'thread_replies'] = this.threadReplies;
    } else {
      json[r'thread_replies'] = null;
    }
    return json;
  }

  /// Returns a new [ChatPreferencesResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ChatPreferencesResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return ChatPreferencesResponse(
        channelMentions: mapValueOfType<String>(json, r'channel_mentions'),
        defaultPreference: mapValueOfType<String>(json, r'default_preference'),
        directMentions: mapValueOfType<String>(json, r'direct_mentions'),
        groupMentions: mapValueOfType<String>(json, r'group_mentions'),
        hereMentions: mapValueOfType<String>(json, r'here_mentions'),
        roleMentions: mapValueOfType<String>(json, r'role_mentions'),
        threadReplies: mapValueOfType<String>(json, r'thread_replies'),
      );
    }
    return null;
  }

  static List<ChatPreferencesResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ChatPreferencesResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChatPreferencesResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ChatPreferencesResponse> mapFromJson(dynamic json) {
    final map = <String, ChatPreferencesResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ChatPreferencesResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ChatPreferencesResponse-objects as value to a dart map
  static Map<String, List<ChatPreferencesResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<ChatPreferencesResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ChatPreferencesResponse.listFromJson(
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
