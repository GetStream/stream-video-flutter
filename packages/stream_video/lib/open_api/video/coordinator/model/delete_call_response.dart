//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class DeleteCallResponse {
  /// Returns a new [DeleteCallResponse] instance.
  DeleteCallResponse({
    required this.call,
    required this.duration,
    this.taskId,
  });

  CallResponse call;

  /// Duration of the request in milliseconds
  String duration;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? taskId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DeleteCallResponse &&
    other.call == call &&
    other.duration == duration &&
    other.taskId == taskId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (call.hashCode) +
    (duration.hashCode) +
    (taskId == null ? 0 : taskId!.hashCode);

  @override
  String toString() => 'DeleteCallResponse[call=$call, duration=$duration, taskId=$taskId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'call'] = this.call;
      json[r'duration'] = this.duration;
    if (this.taskId != null) {
      json[r'task_id'] = this.taskId;
    } else {
      json[r'task_id'] = null;
    }
    return json;
  }

  /// Returns a new [DeleteCallResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DeleteCallResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "DeleteCallResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "DeleteCallResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return DeleteCallResponse(
        call: CallResponse.fromJson(json[r'call'])!,
        duration: mapValueOfType<String>(json, r'duration')!,
        taskId: mapValueOfType<String>(json, r'task_id'),
      );
    }
    return null;
  }

  static List<DeleteCallResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DeleteCallResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DeleteCallResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DeleteCallResponse> mapFromJson(dynamic json) {
    final map = <String, DeleteCallResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DeleteCallResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DeleteCallResponse-objects as value to a dart map
  static Map<String, List<DeleteCallResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DeleteCallResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DeleteCallResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'call',
    'duration',
  };
}

