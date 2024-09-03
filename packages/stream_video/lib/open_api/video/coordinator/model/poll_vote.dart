//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PollVote {
  /// Returns a new [PollVote] instance.
  PollVote({
    this.answerText,
    required this.createdAt,
    required this.id,
    this.isAnswer,
    required this.optionId,
    required this.pollId,
    required this.updatedAt,
    this.user,
    this.userId,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? answerText;

  DateTime createdAt;

  String id;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isAnswer;

  String optionId;

  String pollId;

  DateTime updatedAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserObject? user;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? userId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PollVote &&
    other.answerText == answerText &&
    other.createdAt == createdAt &&
    other.id == id &&
    other.isAnswer == isAnswer &&
    other.optionId == optionId &&
    other.pollId == pollId &&
    other.updatedAt == updatedAt &&
    other.user == user &&
    other.userId == userId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (answerText == null ? 0 : answerText!.hashCode) +
    (createdAt.hashCode) +
    (id.hashCode) +
    (isAnswer == null ? 0 : isAnswer!.hashCode) +
    (optionId.hashCode) +
    (pollId.hashCode) +
    (updatedAt.hashCode) +
    (user == null ? 0 : user!.hashCode) +
    (userId == null ? 0 : userId!.hashCode);

  @override
  String toString() => 'PollVote[answerText=$answerText, createdAt=$createdAt, id=$id, isAnswer=$isAnswer, optionId=$optionId, pollId=$pollId, updatedAt=$updatedAt, user=$user, userId=$userId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.answerText != null) {
      json[r'answer_text'] = this.answerText;
    } else {
      json[r'answer_text'] = null;
    }
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'id'] = this.id;
    if (this.isAnswer != null) {
      json[r'is_answer'] = this.isAnswer;
    } else {
      json[r'is_answer'] = null;
    }
      json[r'option_id'] = this.optionId;
      json[r'poll_id'] = this.pollId;
      json[r'updated_at'] = this.updatedAt.toUtc().toIso8601String();
    if (this.user != null) {
      json[r'user'] = this.user;
    } else {
      json[r'user'] = null;
    }
    if (this.userId != null) {
      json[r'user_id'] = this.userId;
    } else {
      json[r'user_id'] = null;
    }
    return json;
  }

  /// Returns a new [PollVote] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PollVote? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PollVote[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PollVote[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PollVote(
        answerText: mapValueOfType<String>(json, r'answer_text'),
        createdAt: mapDateTime(json, r'created_at', r'')!,
        id: mapValueOfType<String>(json, r'id')!,
        isAnswer: mapValueOfType<bool>(json, r'is_answer'),
        optionId: mapValueOfType<String>(json, r'option_id')!,
        pollId: mapValueOfType<String>(json, r'poll_id')!,
        updatedAt: mapDateTime(json, r'updated_at', r'')!,
        user: UserObject.fromJson(json[r'user']),
        userId: mapValueOfType<String>(json, r'user_id'),
      );
    }
    return null;
  }

  static List<PollVote> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PollVote>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PollVote.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PollVote> mapFromJson(dynamic json) {
    final map = <String, PollVote>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PollVote.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PollVote-objects as value to a dart map
  static Map<String, List<PollVote>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PollVote>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PollVote.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'created_at',
    'id',
    'option_id',
    'poll_id',
    'updated_at',
  };
}

