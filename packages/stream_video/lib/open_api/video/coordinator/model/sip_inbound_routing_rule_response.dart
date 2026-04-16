//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SIPInboundRoutingRuleResponse {
  /// Returns a new [SIPInboundRoutingRuleResponse] instance.
  SIPInboundRoutingRuleResponse({
    this.callConfigs,
    this.calledNumbers = const [],
    this.callerConfigs,
    this.callerNumbers = const [],
    required this.createdAt,
    this.directRoutingConfigs,
    required this.duration,
    required this.id,
    required this.name,
    this.pinProtectionConfigs,
    this.pinRoutingConfigs,
    this.trunkIds = const [],
    required this.updatedAt,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  SIPCallConfigsResponse? callConfigs;

  /// List of called numbers
  List<String> calledNumbers;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  SIPCallerConfigsResponse? callerConfigs;

  /// List of caller numbers
  List<String> callerNumbers;

  /// Creation timestamp
  DateTime createdAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  SIPDirectRoutingRuleCallConfigsResponse? directRoutingConfigs;

  String duration;

  /// Unique identifier of the SIP Inbound Routing Rule
  String id;

  /// Name of the SIP Inbound Routing Rule
  String name;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  SIPPinProtectionConfigsResponse? pinProtectionConfigs;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  SIPInboundRoutingRulePinConfigsResponse? pinRoutingConfigs;

  /// List of SIP trunk IDs
  List<String> trunkIds;

  /// Last update timestamp
  DateTime updatedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SIPInboundRoutingRuleResponse &&
          other.callConfigs == callConfigs &&
          _deepEquality.equals(other.calledNumbers, calledNumbers) &&
          other.callerConfigs == callerConfigs &&
          _deepEquality.equals(other.callerNumbers, callerNumbers) &&
          other.createdAt == createdAt &&
          other.directRoutingConfigs == directRoutingConfigs &&
          other.duration == duration &&
          other.id == id &&
          other.name == name &&
          other.pinProtectionConfigs == pinProtectionConfigs &&
          other.pinRoutingConfigs == pinRoutingConfigs &&
          _deepEquality.equals(other.trunkIds, trunkIds) &&
          other.updatedAt == updatedAt;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (callConfigs == null ? 0 : callConfigs!.hashCode) +
      (calledNumbers.hashCode) +
      (callerConfigs == null ? 0 : callerConfigs!.hashCode) +
      (callerNumbers.hashCode) +
      (createdAt.hashCode) +
      (directRoutingConfigs == null ? 0 : directRoutingConfigs!.hashCode) +
      (duration.hashCode) +
      (id.hashCode) +
      (name.hashCode) +
      (pinProtectionConfigs == null ? 0 : pinProtectionConfigs!.hashCode) +
      (pinRoutingConfigs == null ? 0 : pinRoutingConfigs!.hashCode) +
      (trunkIds.hashCode) +
      (updatedAt.hashCode);

  @override
  String toString() =>
      'SIPInboundRoutingRuleResponse[callConfigs=$callConfigs, calledNumbers=$calledNumbers, callerConfigs=$callerConfigs, callerNumbers=$callerNumbers, createdAt=$createdAt, directRoutingConfigs=$directRoutingConfigs, duration=$duration, id=$id, name=$name, pinProtectionConfigs=$pinProtectionConfigs, pinRoutingConfigs=$pinRoutingConfigs, trunkIds=$trunkIds, updatedAt=$updatedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.callConfigs != null) {
      json[r'call_configs'] = this.callConfigs;
    } else {
      json[r'call_configs'] = null;
    }
    json[r'called_numbers'] = this.calledNumbers;
    if (this.callerConfigs != null) {
      json[r'caller_configs'] = this.callerConfigs;
    } else {
      json[r'caller_configs'] = null;
    }
    json[r'caller_numbers'] = this.callerNumbers;
    json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    if (this.directRoutingConfigs != null) {
      json[r'direct_routing_configs'] = this.directRoutingConfigs;
    } else {
      json[r'direct_routing_configs'] = null;
    }
    json[r'duration'] = this.duration;
    json[r'id'] = this.id;
    json[r'name'] = this.name;
    if (this.pinProtectionConfigs != null) {
      json[r'pin_protection_configs'] = this.pinProtectionConfigs;
    } else {
      json[r'pin_protection_configs'] = null;
    }
    if (this.pinRoutingConfigs != null) {
      json[r'pin_routing_configs'] = this.pinRoutingConfigs;
    } else {
      json[r'pin_routing_configs'] = null;
    }
    json[r'trunk_ids'] = this.trunkIds;
    json[r'updated_at'] = this.updatedAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [SIPInboundRoutingRuleResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SIPInboundRoutingRuleResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'called_numbers'),
            'Required key "SIPInboundRoutingRuleResponse[called_numbers]" is missing from JSON.');
        assert(json[r'called_numbers'] != null,
            'Required key "SIPInboundRoutingRuleResponse[called_numbers]" has a null value in JSON.');
        assert(json.containsKey(r'created_at'),
            'Required key "SIPInboundRoutingRuleResponse[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null,
            'Required key "SIPInboundRoutingRuleResponse[created_at]" has a null value in JSON.');
        assert(json.containsKey(r'duration'),
            'Required key "SIPInboundRoutingRuleResponse[duration]" is missing from JSON.');
        assert(json[r'duration'] != null,
            'Required key "SIPInboundRoutingRuleResponse[duration]" has a null value in JSON.');
        assert(json.containsKey(r'id'),
            'Required key "SIPInboundRoutingRuleResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null,
            'Required key "SIPInboundRoutingRuleResponse[id]" has a null value in JSON.');
        assert(json.containsKey(r'name'),
            'Required key "SIPInboundRoutingRuleResponse[name]" is missing from JSON.');
        assert(json[r'name'] != null,
            'Required key "SIPInboundRoutingRuleResponse[name]" has a null value in JSON.');
        assert(json.containsKey(r'trunk_ids'),
            'Required key "SIPInboundRoutingRuleResponse[trunk_ids]" is missing from JSON.');
        assert(json[r'trunk_ids'] != null,
            'Required key "SIPInboundRoutingRuleResponse[trunk_ids]" has a null value in JSON.');
        assert(json.containsKey(r'updated_at'),
            'Required key "SIPInboundRoutingRuleResponse[updated_at]" is missing from JSON.');
        assert(json[r'updated_at'] != null,
            'Required key "SIPInboundRoutingRuleResponse[updated_at]" has a null value in JSON.');
        return true;
      }());

      return SIPInboundRoutingRuleResponse(
        callConfigs: SIPCallConfigsResponse.fromJson(json[r'call_configs']),
        calledNumbers: json[r'called_numbers'] is Iterable
            ? (json[r'called_numbers'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        callerConfigs:
            SIPCallerConfigsResponse.fromJson(json[r'caller_configs']),
        callerNumbers: json[r'caller_numbers'] is Iterable
            ? (json[r'caller_numbers'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        createdAt: mapDateTime(json, r'created_at', r'')!,
        directRoutingConfigs: SIPDirectRoutingRuleCallConfigsResponse.fromJson(
            json[r'direct_routing_configs']),
        duration: mapValueOfType<String>(json, r'duration')!,
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        pinProtectionConfigs: SIPPinProtectionConfigsResponse.fromJson(
            json[r'pin_protection_configs']),
        pinRoutingConfigs: SIPInboundRoutingRulePinConfigsResponse.fromJson(
            json[r'pin_routing_configs']),
        trunkIds: json[r'trunk_ids'] is Iterable
            ? (json[r'trunk_ids'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        updatedAt: mapDateTime(json, r'updated_at', r'')!,
      );
    }
    return null;
  }

  static List<SIPInboundRoutingRuleResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <SIPInboundRoutingRuleResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SIPInboundRoutingRuleResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SIPInboundRoutingRuleResponse> mapFromJson(dynamic json) {
    final map = <String, SIPInboundRoutingRuleResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SIPInboundRoutingRuleResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SIPInboundRoutingRuleResponse-objects as value to a dart map
  static Map<String, List<SIPInboundRoutingRuleResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<SIPInboundRoutingRuleResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SIPInboundRoutingRuleResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'called_numbers',
    'created_at',
    'duration',
    'id',
    'name',
    'trunk_ids',
    'updated_at',
  };
}
