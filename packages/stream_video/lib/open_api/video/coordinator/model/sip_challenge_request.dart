//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SIPChallengeRequest {
  /// Returns a new [SIPChallengeRequest] instance.
  SIPChallengeRequest({
    this.a1,
    this.algorithm,
    this.charset,
    this.cnonce,
    this.domain = const [],
    this.method,
    this.nc,
    this.nonce,
    this.opaque,
    this.qop = const [],
    this.realm,
    this.response,
    this.stale,
    this.uri,
    this.userhash,
    this.username,
  });

  /// Deprecated: A1 hash for backward compatibility
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? a1;

  /// Hash algorithm (e.g., MD5, SHA-256)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? algorithm;

  /// Character set
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? charset;

  /// Client nonce for qop=auth
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? cnonce;

  /// Domain list
  List<String> domain;

  /// SIP method (e.g., INVITE)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? method;

  /// Nonce count for qop=auth
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? nc;

  /// Server nonce
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? nonce;

  /// Opaque value
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? opaque;

  /// Quality of protection options
  List<String> qop;

  /// Authentication realm
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? realm;

  /// Digest response hash from client
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? response;

  /// Whether the nonce is stale
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? stale;

  /// Request URI
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? uri;

  /// Whether to hash the username
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? userhash;

  /// Username for authentication
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? username;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SIPChallengeRequest &&
          other.a1 == a1 &&
          other.algorithm == algorithm &&
          other.charset == charset &&
          other.cnonce == cnonce &&
          _deepEquality.equals(other.domain, domain) &&
          other.method == method &&
          other.nc == nc &&
          other.nonce == nonce &&
          other.opaque == opaque &&
          _deepEquality.equals(other.qop, qop) &&
          other.realm == realm &&
          other.response == response &&
          other.stale == stale &&
          other.uri == uri &&
          other.userhash == userhash &&
          other.username == username;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (a1 == null ? 0 : a1!.hashCode) +
      (algorithm == null ? 0 : algorithm!.hashCode) +
      (charset == null ? 0 : charset!.hashCode) +
      (cnonce == null ? 0 : cnonce!.hashCode) +
      (domain.hashCode) +
      (method == null ? 0 : method!.hashCode) +
      (nc == null ? 0 : nc!.hashCode) +
      (nonce == null ? 0 : nonce!.hashCode) +
      (opaque == null ? 0 : opaque!.hashCode) +
      (qop.hashCode) +
      (realm == null ? 0 : realm!.hashCode) +
      (response == null ? 0 : response!.hashCode) +
      (stale == null ? 0 : stale!.hashCode) +
      (uri == null ? 0 : uri!.hashCode) +
      (userhash == null ? 0 : userhash!.hashCode) +
      (username == null ? 0 : username!.hashCode);

  @override
  String toString() =>
      'SIPChallengeRequest[a1=$a1, algorithm=$algorithm, charset=$charset, cnonce=$cnonce, domain=$domain, method=$method, nc=$nc, nonce=$nonce, opaque=$opaque, qop=$qop, realm=$realm, response=$response, stale=$stale, uri=$uri, userhash=$userhash, username=$username]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.a1 != null) {
      json[r'a1'] = this.a1;
    } else {
      json[r'a1'] = null;
    }
    if (this.algorithm != null) {
      json[r'algorithm'] = this.algorithm;
    } else {
      json[r'algorithm'] = null;
    }
    if (this.charset != null) {
      json[r'charset'] = this.charset;
    } else {
      json[r'charset'] = null;
    }
    if (this.cnonce != null) {
      json[r'cnonce'] = this.cnonce;
    } else {
      json[r'cnonce'] = null;
    }
    json[r'domain'] = this.domain;
    if (this.method != null) {
      json[r'method'] = this.method;
    } else {
      json[r'method'] = null;
    }
    if (this.nc != null) {
      json[r'nc'] = this.nc;
    } else {
      json[r'nc'] = null;
    }
    if (this.nonce != null) {
      json[r'nonce'] = this.nonce;
    } else {
      json[r'nonce'] = null;
    }
    if (this.opaque != null) {
      json[r'opaque'] = this.opaque;
    } else {
      json[r'opaque'] = null;
    }
    json[r'qop'] = this.qop;
    if (this.realm != null) {
      json[r'realm'] = this.realm;
    } else {
      json[r'realm'] = null;
    }
    if (this.response != null) {
      json[r'response'] = this.response;
    } else {
      json[r'response'] = null;
    }
    if (this.stale != null) {
      json[r'stale'] = this.stale;
    } else {
      json[r'stale'] = null;
    }
    if (this.uri != null) {
      json[r'uri'] = this.uri;
    } else {
      json[r'uri'] = null;
    }
    if (this.userhash != null) {
      json[r'userhash'] = this.userhash;
    } else {
      json[r'userhash'] = null;
    }
    if (this.username != null) {
      json[r'username'] = this.username;
    } else {
      json[r'username'] = null;
    }
    return json;
  }

  /// Returns a new [SIPChallengeRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SIPChallengeRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return SIPChallengeRequest(
        a1: mapValueOfType<String>(json, r'a1'),
        algorithm: mapValueOfType<String>(json, r'algorithm'),
        charset: mapValueOfType<String>(json, r'charset'),
        cnonce: mapValueOfType<String>(json, r'cnonce'),
        domain: json[r'domain'] is Iterable
            ? (json[r'domain'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        method: mapValueOfType<String>(json, r'method'),
        nc: mapValueOfType<String>(json, r'nc'),
        nonce: mapValueOfType<String>(json, r'nonce'),
        opaque: mapValueOfType<String>(json, r'opaque'),
        qop: json[r'qop'] is Iterable
            ? (json[r'qop'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        realm: mapValueOfType<String>(json, r'realm'),
        response: mapValueOfType<String>(json, r'response'),
        stale: mapValueOfType<bool>(json, r'stale'),
        uri: mapValueOfType<String>(json, r'uri'),
        userhash: mapValueOfType<bool>(json, r'userhash'),
        username: mapValueOfType<String>(json, r'username'),
      );
    }
    return null;
  }

  static List<SIPChallengeRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <SIPChallengeRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SIPChallengeRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SIPChallengeRequest> mapFromJson(dynamic json) {
    final map = <String, SIPChallengeRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SIPChallengeRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SIPChallengeRequest-objects as value to a dart map
  static Map<String, List<SIPChallengeRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<SIPChallengeRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SIPChallengeRequest.listFromJson(
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
