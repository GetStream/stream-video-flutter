//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SIPInboundRoutingRulePinConfigsResponse {
  /// Returns a new [SIPInboundRoutingRulePinConfigsResponse] instance.
  SIPInboundRoutingRulePinConfigsResponse({
    this.customWebhookUrl,
    this.pinFailedAttemptPrompt,
    this.pinHangupPrompt,
    this.pinPrompt,
    this.pinSuccessPrompt,
  });

  /// Optional webhook URL for custom PIN handling
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? customWebhookUrl;

  /// Prompt message for failed PIN attempts
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? pinFailedAttemptPrompt;

  /// Prompt message for hangup after PIN input
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? pinHangupPrompt;

  /// Prompt message for PIN input
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? pinPrompt;

  /// Prompt message for successful PIN input
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? pinSuccessPrompt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SIPInboundRoutingRulePinConfigsResponse &&
          other.customWebhookUrl == customWebhookUrl &&
          other.pinFailedAttemptPrompt == pinFailedAttemptPrompt &&
          other.pinHangupPrompt == pinHangupPrompt &&
          other.pinPrompt == pinPrompt &&
          other.pinSuccessPrompt == pinSuccessPrompt;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (customWebhookUrl == null ? 0 : customWebhookUrl!.hashCode) +
      (pinFailedAttemptPrompt == null ? 0 : pinFailedAttemptPrompt!.hashCode) +
      (pinHangupPrompt == null ? 0 : pinHangupPrompt!.hashCode) +
      (pinPrompt == null ? 0 : pinPrompt!.hashCode) +
      (pinSuccessPrompt == null ? 0 : pinSuccessPrompt!.hashCode);

  @override
  String toString() =>
      'SIPInboundRoutingRulePinConfigsResponse[customWebhookUrl=$customWebhookUrl, pinFailedAttemptPrompt=$pinFailedAttemptPrompt, pinHangupPrompt=$pinHangupPrompt, pinPrompt=$pinPrompt, pinSuccessPrompt=$pinSuccessPrompt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.customWebhookUrl != null) {
      json[r'custom_webhook_url'] = this.customWebhookUrl;
    } else {
      json[r'custom_webhook_url'] = null;
    }
    if (this.pinFailedAttemptPrompt != null) {
      json[r'pin_failed_attempt_prompt'] = this.pinFailedAttemptPrompt;
    } else {
      json[r'pin_failed_attempt_prompt'] = null;
    }
    if (this.pinHangupPrompt != null) {
      json[r'pin_hangup_prompt'] = this.pinHangupPrompt;
    } else {
      json[r'pin_hangup_prompt'] = null;
    }
    if (this.pinPrompt != null) {
      json[r'pin_prompt'] = this.pinPrompt;
    } else {
      json[r'pin_prompt'] = null;
    }
    if (this.pinSuccessPrompt != null) {
      json[r'pin_success_prompt'] = this.pinSuccessPrompt;
    } else {
      json[r'pin_success_prompt'] = null;
    }
    return json;
  }

  /// Returns a new [SIPInboundRoutingRulePinConfigsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SIPInboundRoutingRulePinConfigsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return SIPInboundRoutingRulePinConfigsResponse(
        customWebhookUrl: mapValueOfType<String>(json, r'custom_webhook_url'),
        pinFailedAttemptPrompt:
            mapValueOfType<String>(json, r'pin_failed_attempt_prompt'),
        pinHangupPrompt: mapValueOfType<String>(json, r'pin_hangup_prompt'),
        pinPrompt: mapValueOfType<String>(json, r'pin_prompt'),
        pinSuccessPrompt: mapValueOfType<String>(json, r'pin_success_prompt'),
      );
    }
    return null;
  }

  static List<SIPInboundRoutingRulePinConfigsResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <SIPInboundRoutingRulePinConfigsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SIPInboundRoutingRulePinConfigsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SIPInboundRoutingRulePinConfigsResponse> mapFromJson(
      dynamic json) {
    final map = <String, SIPInboundRoutingRulePinConfigsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value =
            SIPInboundRoutingRulePinConfigsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SIPInboundRoutingRulePinConfigsResponse-objects as value to a dart map
  static Map<String, List<SIPInboundRoutingRulePinConfigsResponse>>
      mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<SIPInboundRoutingRulePinConfigsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SIPInboundRoutingRulePinConfigsResponse.listFromJson(
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
