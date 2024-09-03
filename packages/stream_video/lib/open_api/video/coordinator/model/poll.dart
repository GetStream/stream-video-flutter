//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Poll {
  /// Returns a new [Poll] instance.
  Poll({
    this.custom = const {},
    required this.allowAnswers,
    required this.allowUserSuggestedOptions,
    required this.answersCount,
    required this.createdAt,
    this.createdBy,
    required this.createdById,
    required this.description,
    required this.enforceUniqueVote,
    required this.id,
    this.isClosed,
    this.latestAnswers = const [],
    this.latestVotesByOption = const {},
    this.maxVotesAllowed,
    required this.name,
    this.options = const [],
    this.ownVotes = const [],
    required this.updatedAt,
    required this.voteCount,
    this.voteCountsByOption = const {},
    this.votingVisibility,
  });

  Map<String, Object> custom;

  bool allowAnswers;

  bool allowUserSuggestedOptions;

  int answersCount;

  DateTime createdAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserObject? createdBy;

  String createdById;

  String description;

  bool enforceUniqueVote;

  String id;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isClosed;

  List<PollVote> latestAnswers;

  Map<String, List<PollVote>> latestVotesByOption;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? maxVotesAllowed;

  String name;

  List<PollOption> options;

  List<PollVote> ownVotes;

  DateTime updatedAt;

  int voteCount;

  Map<String, int> voteCountsByOption;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? votingVisibility;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Poll &&
    _deepEquality.equals(other.custom, custom) &&
    other.allowAnswers == allowAnswers &&
    other.allowUserSuggestedOptions == allowUserSuggestedOptions &&
    other.answersCount == answersCount &&
    other.createdAt == createdAt &&
    other.createdBy == createdBy &&
    other.createdById == createdById &&
    other.description == description &&
    other.enforceUniqueVote == enforceUniqueVote &&
    other.id == id &&
    other.isClosed == isClosed &&
    _deepEquality.equals(other.latestAnswers, latestAnswers) &&
    _deepEquality.equals(other.latestVotesByOption, latestVotesByOption) &&
    other.maxVotesAllowed == maxVotesAllowed &&
    other.name == name &&
    _deepEquality.equals(other.options, options) &&
    _deepEquality.equals(other.ownVotes, ownVotes) &&
    other.updatedAt == updatedAt &&
    other.voteCount == voteCount &&
    _deepEquality.equals(other.voteCountsByOption, voteCountsByOption) &&
    other.votingVisibility == votingVisibility;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (custom.hashCode) +
    (allowAnswers.hashCode) +
    (allowUserSuggestedOptions.hashCode) +
    (answersCount.hashCode) +
    (createdAt.hashCode) +
    (createdBy == null ? 0 : createdBy!.hashCode) +
    (createdById.hashCode) +
    (description.hashCode) +
    (enforceUniqueVote.hashCode) +
    (id.hashCode) +
    (isClosed == null ? 0 : isClosed!.hashCode) +
    (latestAnswers.hashCode) +
    (latestVotesByOption.hashCode) +
    (maxVotesAllowed == null ? 0 : maxVotesAllowed!.hashCode) +
    (name.hashCode) +
    (options.hashCode) +
    (ownVotes.hashCode) +
    (updatedAt.hashCode) +
    (voteCount.hashCode) +
    (voteCountsByOption.hashCode) +
    (votingVisibility == null ? 0 : votingVisibility!.hashCode);

  @override
  String toString() => 'Poll[custom=$custom, allowAnswers=$allowAnswers, allowUserSuggestedOptions=$allowUserSuggestedOptions, answersCount=$answersCount, createdAt=$createdAt, createdBy=$createdBy, createdById=$createdById, description=$description, enforceUniqueVote=$enforceUniqueVote, id=$id, isClosed=$isClosed, latestAnswers=$latestAnswers, latestVotesByOption=$latestVotesByOption, maxVotesAllowed=$maxVotesAllowed, name=$name, options=$options, ownVotes=$ownVotes, updatedAt=$updatedAt, voteCount=$voteCount, voteCountsByOption=$voteCountsByOption, votingVisibility=$votingVisibility]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'Custom'] = this.custom;
      json[r'allow_answers'] = this.allowAnswers;
      json[r'allow_user_suggested_options'] = this.allowUserSuggestedOptions;
      json[r'answers_count'] = this.answersCount;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    if (this.createdBy != null) {
      json[r'created_by'] = this.createdBy;
    } else {
      json[r'created_by'] = null;
    }
      json[r'created_by_id'] = this.createdById;
      json[r'description'] = this.description;
      json[r'enforce_unique_vote'] = this.enforceUniqueVote;
      json[r'id'] = this.id;
    if (this.isClosed != null) {
      json[r'is_closed'] = this.isClosed;
    } else {
      json[r'is_closed'] = null;
    }
      json[r'latest_answers'] = this.latestAnswers;
      json[r'latest_votes_by_option'] = this.latestVotesByOption;
    if (this.maxVotesAllowed != null) {
      json[r'max_votes_allowed'] = this.maxVotesAllowed;
    } else {
      json[r'max_votes_allowed'] = null;
    }
      json[r'name'] = this.name;
      json[r'options'] = this.options;
      json[r'own_votes'] = this.ownVotes;
      json[r'updated_at'] = this.updatedAt.toUtc().toIso8601String();
      json[r'vote_count'] = this.voteCount;
      json[r'vote_counts_by_option'] = this.voteCountsByOption;
    if (this.votingVisibility != null) {
      json[r'voting_visibility'] = this.votingVisibility;
    } else {
      json[r'voting_visibility'] = null;
    }
    return json;
  }

  /// Returns a new [Poll] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Poll? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "Poll[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "Poll[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return Poll(
        custom: mapCastOfType<String, Object>(json, r'Custom')!,
        allowAnswers: mapValueOfType<bool>(json, r'allow_answers')!,
        allowUserSuggestedOptions: mapValueOfType<bool>(json, r'allow_user_suggested_options')!,
        answersCount: mapValueOfType<int>(json, r'answers_count')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        createdBy: UserObject.fromJson(json[r'created_by']),
        createdById: mapValueOfType<String>(json, r'created_by_id')!,
        description: mapValueOfType<String>(json, r'description')!,
        enforceUniqueVote: mapValueOfType<bool>(json, r'enforce_unique_vote')!,
        id: mapValueOfType<String>(json, r'id')!,
        isClosed: mapValueOfType<bool>(json, r'is_closed'),
        latestAnswers: PollVote.listFromJson(json[r'latest_answers']),
        latestVotesByOption: json[r'latest_votes_by_option'] == null
          ? const {}
            : PollVote.mapListFromJson(json[r'latest_votes_by_option']),
        maxVotesAllowed: mapValueOfType<int>(json, r'max_votes_allowed'),
        name: mapValueOfType<String>(json, r'name')!,
        options: PollOption.listFromJson(json[r'options']),
        ownVotes: PollVote.listFromJson(json[r'own_votes']),
        updatedAt: mapDateTime(json, r'updated_at', r'')!,
        voteCount: mapValueOfType<int>(json, r'vote_count')!,
        voteCountsByOption: mapCastOfType<String, int>(json, r'vote_counts_by_option')!,
        votingVisibility: mapValueOfType<String>(json, r'voting_visibility'),
      );
    }
    return null;
  }

  static List<Poll> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Poll>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Poll.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Poll> mapFromJson(dynamic json) {
    final map = <String, Poll>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Poll.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Poll-objects as value to a dart map
  static Map<String, List<Poll>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Poll>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Poll.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'Custom',
    'allow_answers',
    'allow_user_suggested_options',
    'answers_count',
    'created_at',
    'created_by_id',
    'description',
    'enforce_unique_vote',
    'id',
    'latest_answers',
    'latest_votes_by_option',
    'name',
    'options',
    'own_votes',
    'updated_at',
    'vote_count',
    'vote_counts_by_option',
  };
}

