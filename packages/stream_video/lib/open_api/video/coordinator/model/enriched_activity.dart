//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EnrichedActivity {
  /// Returns a new [EnrichedActivity] instance.
  EnrichedActivity({
    this.actor,
    this.foreignId,
    this.id,
    this.latestReactions = const {},
    this.object,
    this.origin,
    this.ownReactions = const {},
    this.reactionCounts = const {},
    this.score,
    this.target,
    this.time,
    this.to = const [],
    this.verb,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Data? actor;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? foreignId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? id;

  Map<String, List<EnrichedReaction>> latestReactions;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Data? object;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Data? origin;

  Map<String, List<EnrichedReaction>> ownReactions;

  Map<String, int> reactionCounts;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? score;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Data? target;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? time;

  List<String> to;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? verb;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EnrichedActivity &&
    other.actor == actor &&
    other.foreignId == foreignId &&
    other.id == id &&
    _deepEquality.equals(other.latestReactions, latestReactions) &&
    other.object == object &&
    other.origin == origin &&
    _deepEquality.equals(other.ownReactions, ownReactions) &&
    _deepEquality.equals(other.reactionCounts, reactionCounts) &&
    other.score == score &&
    other.target == target &&
    other.time == time &&
    _deepEquality.equals(other.to, to) &&
    other.verb == verb;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (actor == null ? 0 : actor!.hashCode) +
    (foreignId == null ? 0 : foreignId!.hashCode) +
    (id == null ? 0 : id!.hashCode) +
    (latestReactions.hashCode) +
    (object == null ? 0 : object!.hashCode) +
    (origin == null ? 0 : origin!.hashCode) +
    (ownReactions.hashCode) +
    (reactionCounts.hashCode) +
    (score == null ? 0 : score!.hashCode) +
    (target == null ? 0 : target!.hashCode) +
    (time == null ? 0 : time!.hashCode) +
    (to.hashCode) +
    (verb == null ? 0 : verb!.hashCode);

  @override
  String toString() => 'EnrichedActivity[actor=$actor, foreignId=$foreignId, id=$id, latestReactions=$latestReactions, object=$object, origin=$origin, ownReactions=$ownReactions, reactionCounts=$reactionCounts, score=$score, target=$target, time=$time, to=$to, verb=$verb]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.actor != null) {
      json[r'actor'] = this.actor;
    } else {
      json[r'actor'] = null;
    }
    if (this.foreignId != null) {
      json[r'foreign_id'] = this.foreignId;
    } else {
      json[r'foreign_id'] = null;
    }
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
      json[r'latest_reactions'] = this.latestReactions;
    if (this.object != null) {
      json[r'object'] = this.object;
    } else {
      json[r'object'] = null;
    }
    if (this.origin != null) {
      json[r'origin'] = this.origin;
    } else {
      json[r'origin'] = null;
    }
      json[r'own_reactions'] = this.ownReactions;
      json[r'reaction_counts'] = this.reactionCounts;
    if (this.score != null) {
      json[r'score'] = this.score;
    } else {
      json[r'score'] = null;
    }
    if (this.target != null) {
      json[r'target'] = this.target;
    } else {
      json[r'target'] = null;
    }
    if (this.time != null) {
      json[r'time'] = this.time;
    } else {
      json[r'time'] = null;
    }
      json[r'to'] = this.to;
    if (this.verb != null) {
      json[r'verb'] = this.verb;
    } else {
      json[r'verb'] = null;
    }
    return json;
  }

  /// Returns a new [EnrichedActivity] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EnrichedActivity? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EnrichedActivity[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EnrichedActivity[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EnrichedActivity(
        actor: Data.fromJson(json[r'actor']),
        foreignId: mapValueOfType<String>(json, r'foreign_id'),
        id: mapValueOfType<String>(json, r'id'),
        latestReactions: json[r'latest_reactions'] == null
          ? const {}
            : EnrichedReaction.mapListFromJson(json[r'latest_reactions']),
        object: Data.fromJson(json[r'object']),
        origin: Data.fromJson(json[r'origin']),
        ownReactions: json[r'own_reactions'] == null
          ? const {}
            : EnrichedReaction.mapListFromJson(json[r'own_reactions']),
        reactionCounts: mapCastOfType<String, int>(json, r'reaction_counts') ?? const {},
        score: mapValueOfType<double>(json, r'score'),
        target: Data.fromJson(json[r'target']),
        time: mapValueOfType<Object>(json, r'time'),
        to: json[r'to'] is Iterable
            ? (json[r'to'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        verb: mapValueOfType<String>(json, r'verb'),
      );
    }
    return null;
  }

  static List<EnrichedActivity> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EnrichedActivity>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EnrichedActivity.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EnrichedActivity> mapFromJson(dynamic json) {
    final map = <String, EnrichedActivity>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EnrichedActivity.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EnrichedActivity-objects as value to a dart map
  static Map<String, List<EnrichedActivity>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EnrichedActivity>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EnrichedActivity.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

