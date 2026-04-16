//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ResolveSipInboundRequest {
  /// Returns a new [ResolveSipInboundRequest] instance.
  ResolveSipInboundRequest({
    this.challenge,
    this.routingNumber,
    required this.sipCallerNumber,
    this.sipHeaders = const {},
    required this.sipTrunkNumber,
    this.trunkId,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  SIPChallengeRequest? challenge;

  /// Optional routing number for routing number-based call routing (10 digits)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? routingNumber;

  /// SIP caller number
  String sipCallerNumber;

  /// Optional SIP headers as key-value pairs
  Map<String, String> sipHeaders;

  /// SIP trunk number to resolve
  String sipTrunkNumber;

  /// Optional pre-authenticated trunk ID (from PreAuth no-auth flow)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? trunkId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResolveSipInboundRequest &&
          other.challenge == challenge &&
          other.routingNumber == routingNumber &&
          other.sipCallerNumber == sipCallerNumber &&
          _deepEquality.equals(other.sipHeaders, sipHeaders) &&
          other.sipTrunkNumber == sipTrunkNumber &&
          other.trunkId == trunkId;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (challenge == null ? 0 : challenge!.hashCode) +
      (routingNumber == null ? 0 : routingNumber!.hashCode) +
      (sipCallerNumber.hashCode) +
      (sipHeaders.hashCode) +
      (sipTrunkNumber.hashCode) +
      (trunkId == null ? 0 : trunkId!.hashCode);

  @override
  String toString() =>
      'ResolveSipInboundRequest[challenge=$challenge, routingNumber=$routingNumber, sipCallerNumber=$sipCallerNumber, sipHeaders=$sipHeaders, sipTrunkNumber=$sipTrunkNumber, trunkId=$trunkId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.challenge != null) {
      json[r'challenge'] = this.challenge;
    } else {
      json[r'challenge'] = null;
    }
    if (this.routingNumber != null) {
      json[r'routing_number'] = this.routingNumber;
    } else {
      json[r'routing_number'] = null;
    }
    json[r'sip_caller_number'] = this.sipCallerNumber;
    json[r'sip_headers'] = this.sipHeaders;
    json[r'sip_trunk_number'] = this.sipTrunkNumber;
    if (this.trunkId != null) {
      json[r'trunk_id'] = this.trunkId;
    } else {
      json[r'trunk_id'] = null;
    }
    return json;
  }

  /// Returns a new [ResolveSipInboundRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ResolveSipInboundRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'sip_caller_number'),
            'Required key "ResolveSipInboundRequest[sip_caller_number]" is missing from JSON.');
        assert(json[r'sip_caller_number'] != null,
            'Required key "ResolveSipInboundRequest[sip_caller_number]" has a null value in JSON.');
        assert(json.containsKey(r'sip_trunk_number'),
            'Required key "ResolveSipInboundRequest[sip_trunk_number]" is missing from JSON.');
        assert(json[r'sip_trunk_number'] != null,
            'Required key "ResolveSipInboundRequest[sip_trunk_number]" has a null value in JSON.');
        return true;
      }());

      return ResolveSipInboundRequest(
        challenge: SIPChallengeRequest.fromJson(json[r'challenge']),
        routingNumber: mapValueOfType<String>(json, r'routing_number'),
        sipCallerNumber: mapValueOfType<String>(json, r'sip_caller_number')!,
        sipHeaders:
            mapCastOfType<String, String>(json, r'sip_headers') ?? const {},
        sipTrunkNumber: mapValueOfType<String>(json, r'sip_trunk_number')!,
        trunkId: mapValueOfType<String>(json, r'trunk_id'),
      );
    }
    return null;
  }

  static List<ResolveSipInboundRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ResolveSipInboundRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ResolveSipInboundRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ResolveSipInboundRequest> mapFromJson(dynamic json) {
    final map = <String, ResolveSipInboundRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ResolveSipInboundRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ResolveSipInboundRequest-objects as value to a dart map
  static Map<String, List<ResolveSipInboundRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<ResolveSipInboundRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ResolveSipInboundRequest.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'sip_caller_number',
    'sip_trunk_number',
  };
}
