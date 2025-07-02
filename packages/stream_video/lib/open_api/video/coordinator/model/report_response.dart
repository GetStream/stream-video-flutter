//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ReportResponse {
  /// Returns a new [ReportResponse] instance.
  ReportResponse({
    required this.call,
    required this.participants,
    required this.userRatings,
  });

  CallReportResponse call;

  ParticipantReportResponse participants;

  UserRatingReportResponse userRatings;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportResponse &&
          other.call == call &&
          other.participants == participants &&
          other.userRatings == userRatings;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (call.hashCode) + (participants.hashCode) + (userRatings.hashCode);

  @override
  String toString() =>
      'ReportResponse[call=$call, participants=$participants, userRatings=$userRatings]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'call'] = this.call;
    json[r'participants'] = this.participants;
    json[r'user_ratings'] = this.userRatings;
    return json;
  }

  /// Returns a new [ReportResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReportResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "ReportResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "ReportResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ReportResponse(
        call: CallReportResponse.fromJson(json[r'call'])!,
        participants:
            ParticipantReportResponse.fromJson(json[r'participants'])!,
        userRatings: UserRatingReportResponse.fromJson(json[r'user_ratings'])!,
      );
    }
    return null;
  }

  static List<ReportResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ReportResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReportResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReportResponse> mapFromJson(dynamic json) {
    final map = <String, ReportResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReportResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReportResponse-objects as value to a dart map
  static Map<String, List<ReportResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<ReportResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReportResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'call',
    'participants',
    'user_ratings',
  };
}
