//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PaginationParamsRequest {
  /// Returns a new [PaginationParamsRequest] instance.
  PaginationParamsRequest({
    this.idGt,
    this.idGte,
    this.idLt,
    this.idLte,
    this.limit,
    this.offset,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? idGt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? idGte;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? idLt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? idLte;

  /// Minimum value: 0
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? limit;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? offset;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PaginationParamsRequest &&
     other.idGt == idGt &&
     other.idGte == idGte &&
     other.idLt == idLt &&
     other.idLte == idLte &&
     other.limit == limit &&
     other.offset == offset;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (idGt == null ? 0 : idGt!.hashCode) +
    (idGte == null ? 0 : idGte!.hashCode) +
    (idLt == null ? 0 : idLt!.hashCode) +
    (idLte == null ? 0 : idLte!.hashCode) +
    (limit == null ? 0 : limit!.hashCode) +
    (offset == null ? 0 : offset!.hashCode);

  @override
  String toString() => 'PaginationParamsRequest[idGt=$idGt, idGte=$idGte, idLt=$idLt, idLte=$idLte, limit=$limit, offset=$offset]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.idGt != null) {
      json[r'id_gt'] = this.idGt;
    } else {
      json[r'id_gt'] = null;
    }
    if (this.idGte != null) {
      json[r'id_gte'] = this.idGte;
    } else {
      json[r'id_gte'] = null;
    }
    if (this.idLt != null) {
      json[r'id_lt'] = this.idLt;
    } else {
      json[r'id_lt'] = null;
    }
    if (this.idLte != null) {
      json[r'id_lte'] = this.idLte;
    } else {
      json[r'id_lte'] = null;
    }
    if (this.limit != null) {
      json[r'limit'] = this.limit;
    } else {
      json[r'limit'] = null;
    }
    if (this.offset != null) {
      json[r'offset'] = this.offset;
    } else {
      json[r'offset'] = null;
    }
    return json;
  }

  /// Returns a new [PaginationParamsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PaginationParamsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PaginationParamsRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PaginationParamsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PaginationParamsRequest(
        idGt: mapValueOfType<int>(json, r'id_gt'),
        idGte: mapValueOfType<int>(json, r'id_gte'),
        idLt: mapValueOfType<int>(json, r'id_lt'),
        idLte: mapValueOfType<int>(json, r'id_lte'),
        limit: mapValueOfType<int>(json, r'limit'),
        offset: mapValueOfType<int>(json, r'offset'),
      );
    }
    return null;
  }

  static List<PaginationParamsRequest>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PaginationParamsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PaginationParamsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PaginationParamsRequest> mapFromJson(dynamic json) {
    final map = <String, PaginationParamsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PaginationParamsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PaginationParamsRequest-objects as value to a dart map
  static Map<String, List<PaginationParamsRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PaginationParamsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PaginationParamsRequest.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

