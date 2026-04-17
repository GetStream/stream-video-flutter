//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallStatsLocation {
  /// Returns a new [CallStatsLocation] instance.
  CallStatsLocation({
    this.accuracyRadiusMeters,
    this.city,
    this.continent,
    this.country,
    this.countryIsoCode,
    this.latitude,
    this.longitude,
    this.subdivision,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? accuracyRadiusMeters;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? city;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? continent;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? country;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? countryIsoCode;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? latitude;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? longitude;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? subdivision;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallStatsLocation &&
          other.accuracyRadiusMeters == accuracyRadiusMeters &&
          other.city == city &&
          other.continent == continent &&
          other.country == country &&
          other.countryIsoCode == countryIsoCode &&
          other.latitude == latitude &&
          other.longitude == longitude &&
          other.subdivision == subdivision;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (accuracyRadiusMeters == null ? 0 : accuracyRadiusMeters!.hashCode) +
      (city == null ? 0 : city!.hashCode) +
      (continent == null ? 0 : continent!.hashCode) +
      (country == null ? 0 : country!.hashCode) +
      (countryIsoCode == null ? 0 : countryIsoCode!.hashCode) +
      (latitude == null ? 0 : latitude!.hashCode) +
      (longitude == null ? 0 : longitude!.hashCode) +
      (subdivision == null ? 0 : subdivision!.hashCode);

  @override
  String toString() =>
      'CallStatsLocation[accuracyRadiusMeters=$accuracyRadiusMeters, city=$city, continent=$continent, country=$country, countryIsoCode=$countryIsoCode, latitude=$latitude, longitude=$longitude, subdivision=$subdivision]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.accuracyRadiusMeters != null) {
      json[r'accuracy_radius_meters'] = this.accuracyRadiusMeters;
    } else {
      json[r'accuracy_radius_meters'] = null;
    }
    if (this.city != null) {
      json[r'city'] = this.city;
    } else {
      json[r'city'] = null;
    }
    if (this.continent != null) {
      json[r'continent'] = this.continent;
    } else {
      json[r'continent'] = null;
    }
    if (this.country != null) {
      json[r'country'] = this.country;
    } else {
      json[r'country'] = null;
    }
    if (this.countryIsoCode != null) {
      json[r'country_iso_code'] = this.countryIsoCode;
    } else {
      json[r'country_iso_code'] = null;
    }
    if (this.latitude != null) {
      json[r'latitude'] = this.latitude;
    } else {
      json[r'latitude'] = null;
    }
    if (this.longitude != null) {
      json[r'longitude'] = this.longitude;
    } else {
      json[r'longitude'] = null;
    }
    if (this.subdivision != null) {
      json[r'subdivision'] = this.subdivision;
    } else {
      json[r'subdivision'] = null;
    }
    return json;
  }

  /// Returns a new [CallStatsLocation] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallStatsLocation? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return CallStatsLocation(
        accuracyRadiusMeters:
            mapValueOfType<int>(json, r'accuracy_radius_meters'),
        city: mapValueOfType<String>(json, r'city'),
        continent: mapValueOfType<String>(json, r'continent'),
        country: mapValueOfType<String>(json, r'country'),
        countryIsoCode: mapValueOfType<String>(json, r'country_iso_code'),
        latitude: mapValueOfType<double>(json, r'latitude'),
        longitude: mapValueOfType<double>(json, r'longitude'),
        subdivision: mapValueOfType<String>(json, r'subdivision'),
      );
    }
    return null;
  }

  static List<CallStatsLocation> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CallStatsLocation>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallStatsLocation.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallStatsLocation> mapFromJson(dynamic json) {
    final map = <String, CallStatsLocation>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallStatsLocation.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallStatsLocation-objects as value to a dart map
  static Map<String, List<CallStatsLocation>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CallStatsLocation>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallStatsLocation.listFromJson(
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
