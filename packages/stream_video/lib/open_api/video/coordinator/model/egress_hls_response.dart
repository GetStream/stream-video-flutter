//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EgressHLSResponse {
  /// Returns a new [EgressHLSResponse] instance.
  EgressHLSResponse({
    required this.playlistUrl,
  });

  String playlistUrl;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EgressHLSResponse &&
     other.playlistUrl == playlistUrl;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (playlistUrl.hashCode);

  @override
  String toString() => 'EgressHLSResponse[playlistUrl=$playlistUrl]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'playlist_url'] = this.playlistUrl;
    return json;
  }

  /// Returns a new [EgressHLSResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EgressHLSResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EgressHLSResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EgressHLSResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EgressHLSResponse(
        playlistUrl: mapValueOfType<String>(json, r'playlist_url')!,
      );
    }
    return null;
  }

  static List<EgressHLSResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EgressHLSResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EgressHLSResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EgressHLSResponse> mapFromJson(dynamic json) {
    final map = <String, EgressHLSResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EgressHLSResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EgressHLSResponse-objects as value to a dart map
  static Map<String, List<EgressHLSResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EgressHLSResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EgressHLSResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'playlist_url',
  };
}

