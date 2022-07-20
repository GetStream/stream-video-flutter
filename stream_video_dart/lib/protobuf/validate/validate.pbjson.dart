///
//  Generated code. Do not modify.
//  source: validate/validate.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use knownRegexDescriptor instead')
const KnownRegex$json = const {
  '1': 'KnownRegex',
  '2': const [
    const {'1': 'UNKNOWN', '2': 0},
    const {'1': 'HTTP_HEADER_NAME', '2': 1},
    const {'1': 'HTTP_HEADER_VALUE', '2': 2},
  ],
};

/// Descriptor for `KnownRegex`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List knownRegexDescriptor = $convert.base64Decode('CgpLbm93blJlZ2V4EgsKB1VOS05PV04QABIUChBIVFRQX0hFQURFUl9OQU1FEAESFQoRSFRUUF9IRUFERVJfVkFMVUUQAg==');
@$core.Deprecated('Use fieldRulesDescriptor instead')
const FieldRules$json = const {
  '1': 'FieldRules',
  '2': const [
    const {'1': 'message', '3': 17, '4': 1, '5': 11, '6': '.validate.MessageRules', '10': 'message'},
    const {'1': 'float', '3': 1, '4': 1, '5': 11, '6': '.validate.FloatRules', '9': 0, '10': 'float'},
    const {'1': 'double', '3': 2, '4': 1, '5': 11, '6': '.validate.DoubleRules', '9': 0, '10': 'double'},
    const {'1': 'int32', '3': 3, '4': 1, '5': 11, '6': '.validate.Int32Rules', '9': 0, '10': 'int32'},
    const {'1': 'int64', '3': 4, '4': 1, '5': 11, '6': '.validate.Int64Rules', '9': 0, '10': 'int64'},
    const {'1': 'uint32', '3': 5, '4': 1, '5': 11, '6': '.validate.UInt32Rules', '9': 0, '10': 'uint32'},
    const {'1': 'uint64', '3': 6, '4': 1, '5': 11, '6': '.validate.UInt64Rules', '9': 0, '10': 'uint64'},
    const {'1': 'sint32', '3': 7, '4': 1, '5': 11, '6': '.validate.SInt32Rules', '9': 0, '10': 'sint32'},
    const {'1': 'sint64', '3': 8, '4': 1, '5': 11, '6': '.validate.SInt64Rules', '9': 0, '10': 'sint64'},
    const {'1': 'fixed32', '3': 9, '4': 1, '5': 11, '6': '.validate.Fixed32Rules', '9': 0, '10': 'fixed32'},
    const {'1': 'fixed64', '3': 10, '4': 1, '5': 11, '6': '.validate.Fixed64Rules', '9': 0, '10': 'fixed64'},
    const {'1': 'sfixed32', '3': 11, '4': 1, '5': 11, '6': '.validate.SFixed32Rules', '9': 0, '10': 'sfixed32'},
    const {'1': 'sfixed64', '3': 12, '4': 1, '5': 11, '6': '.validate.SFixed64Rules', '9': 0, '10': 'sfixed64'},
    const {'1': 'bool', '3': 13, '4': 1, '5': 11, '6': '.validate.BoolRules', '9': 0, '10': 'bool'},
    const {'1': 'string', '3': 14, '4': 1, '5': 11, '6': '.validate.StringRules', '9': 0, '10': 'string'},
    const {'1': 'bytes', '3': 15, '4': 1, '5': 11, '6': '.validate.BytesRules', '9': 0, '10': 'bytes'},
    const {'1': 'enum', '3': 16, '4': 1, '5': 11, '6': '.validate.EnumRules', '9': 0, '10': 'enum'},
    const {'1': 'repeated', '3': 18, '4': 1, '5': 11, '6': '.validate.RepeatedRules', '9': 0, '10': 'repeated'},
    const {'1': 'map', '3': 19, '4': 1, '5': 11, '6': '.validate.MapRules', '9': 0, '10': 'map'},
    const {'1': 'any', '3': 20, '4': 1, '5': 11, '6': '.validate.AnyRules', '9': 0, '10': 'any'},
    const {'1': 'duration', '3': 21, '4': 1, '5': 11, '6': '.validate.DurationRules', '9': 0, '10': 'duration'},
    const {'1': 'timestamp', '3': 22, '4': 1, '5': 11, '6': '.validate.TimestampRules', '9': 0, '10': 'timestamp'},
  ],
  '8': const [
    const {'1': 'type'},
  ],
};

/// Descriptor for `FieldRules`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fieldRulesDescriptor = $convert.base64Decode('CgpGaWVsZFJ1bGVzEjAKB21lc3NhZ2UYESABKAsyFi52YWxpZGF0ZS5NZXNzYWdlUnVsZXNSB21lc3NhZ2USLAoFZmxvYXQYASABKAsyFC52YWxpZGF0ZS5GbG9hdFJ1bGVzSABSBWZsb2F0Ei8KBmRvdWJsZRgCIAEoCzIVLnZhbGlkYXRlLkRvdWJsZVJ1bGVzSABSBmRvdWJsZRIsCgVpbnQzMhgDIAEoCzIULnZhbGlkYXRlLkludDMyUnVsZXNIAFIFaW50MzISLAoFaW50NjQYBCABKAsyFC52YWxpZGF0ZS5JbnQ2NFJ1bGVzSABSBWludDY0Ei8KBnVpbnQzMhgFIAEoCzIVLnZhbGlkYXRlLlVJbnQzMlJ1bGVzSABSBnVpbnQzMhIvCgZ1aW50NjQYBiABKAsyFS52YWxpZGF0ZS5VSW50NjRSdWxlc0gAUgZ1aW50NjQSLwoGc2ludDMyGAcgASgLMhUudmFsaWRhdGUuU0ludDMyUnVsZXNIAFIGc2ludDMyEi8KBnNpbnQ2NBgIIAEoCzIVLnZhbGlkYXRlLlNJbnQ2NFJ1bGVzSABSBnNpbnQ2NBIyCgdmaXhlZDMyGAkgASgLMhYudmFsaWRhdGUuRml4ZWQzMlJ1bGVzSABSB2ZpeGVkMzISMgoHZml4ZWQ2NBgKIAEoCzIWLnZhbGlkYXRlLkZpeGVkNjRSdWxlc0gAUgdmaXhlZDY0EjUKCHNmaXhlZDMyGAsgASgLMhcudmFsaWRhdGUuU0ZpeGVkMzJSdWxlc0gAUghzZml4ZWQzMhI1CghzZml4ZWQ2NBgMIAEoCzIXLnZhbGlkYXRlLlNGaXhlZDY0UnVsZXNIAFIIc2ZpeGVkNjQSKQoEYm9vbBgNIAEoCzITLnZhbGlkYXRlLkJvb2xSdWxlc0gAUgRib29sEi8KBnN0cmluZxgOIAEoCzIVLnZhbGlkYXRlLlN0cmluZ1J1bGVzSABSBnN0cmluZxIsCgVieXRlcxgPIAEoCzIULnZhbGlkYXRlLkJ5dGVzUnVsZXNIAFIFYnl0ZXMSKQoEZW51bRgQIAEoCzITLnZhbGlkYXRlLkVudW1SdWxlc0gAUgRlbnVtEjUKCHJlcGVhdGVkGBIgASgLMhcudmFsaWRhdGUuUmVwZWF0ZWRSdWxlc0gAUghyZXBlYXRlZBImCgNtYXAYEyABKAsyEi52YWxpZGF0ZS5NYXBSdWxlc0gAUgNtYXASJgoDYW55GBQgASgLMhIudmFsaWRhdGUuQW55UnVsZXNIAFIDYW55EjUKCGR1cmF0aW9uGBUgASgLMhcudmFsaWRhdGUuRHVyYXRpb25SdWxlc0gAUghkdXJhdGlvbhI4Cgl0aW1lc3RhbXAYFiABKAsyGC52YWxpZGF0ZS5UaW1lc3RhbXBSdWxlc0gAUgl0aW1lc3RhbXBCBgoEdHlwZQ==');
@$core.Deprecated('Use floatRulesDescriptor instead')
const FloatRules$json = const {
  '1': 'FloatRules',
  '2': const [
    const {'1': 'const', '3': 1, '4': 1, '5': 2, '10': 'const'},
    const {'1': 'lt', '3': 2, '4': 1, '5': 2, '10': 'lt'},
    const {'1': 'lte', '3': 3, '4': 1, '5': 2, '10': 'lte'},
    const {'1': 'gt', '3': 4, '4': 1, '5': 2, '10': 'gt'},
    const {'1': 'gte', '3': 5, '4': 1, '5': 2, '10': 'gte'},
    const {'1': 'in', '3': 6, '4': 3, '5': 2, '10': 'in'},
    const {'1': 'not_in', '3': 7, '4': 3, '5': 2, '10': 'notIn'},
    const {'1': 'ignore_empty', '3': 8, '4': 1, '5': 8, '10': 'ignoreEmpty'},
  ],
};

/// Descriptor for `FloatRules`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List floatRulesDescriptor = $convert.base64Decode('CgpGbG9hdFJ1bGVzEhQKBWNvbnN0GAEgASgCUgVjb25zdBIOCgJsdBgCIAEoAlICbHQSEAoDbHRlGAMgASgCUgNsdGUSDgoCZ3QYBCABKAJSAmd0EhAKA2d0ZRgFIAEoAlIDZ3RlEg4KAmluGAYgAygCUgJpbhIVCgZub3RfaW4YByADKAJSBW5vdEluEiEKDGlnbm9yZV9lbXB0eRgIIAEoCFILaWdub3JlRW1wdHk=');
@$core.Deprecated('Use doubleRulesDescriptor instead')
const DoubleRules$json = const {
  '1': 'DoubleRules',
  '2': const [
    const {'1': 'const', '3': 1, '4': 1, '5': 1, '10': 'const'},
    const {'1': 'lt', '3': 2, '4': 1, '5': 1, '10': 'lt'},
    const {'1': 'lte', '3': 3, '4': 1, '5': 1, '10': 'lte'},
    const {'1': 'gt', '3': 4, '4': 1, '5': 1, '10': 'gt'},
    const {'1': 'gte', '3': 5, '4': 1, '5': 1, '10': 'gte'},
    const {'1': 'in', '3': 6, '4': 3, '5': 1, '10': 'in'},
    const {'1': 'not_in', '3': 7, '4': 3, '5': 1, '10': 'notIn'},
    const {'1': 'ignore_empty', '3': 8, '4': 1, '5': 8, '10': 'ignoreEmpty'},
  ],
};

/// Descriptor for `DoubleRules`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List doubleRulesDescriptor = $convert.base64Decode('CgtEb3VibGVSdWxlcxIUCgVjb25zdBgBIAEoAVIFY29uc3QSDgoCbHQYAiABKAFSAmx0EhAKA2x0ZRgDIAEoAVIDbHRlEg4KAmd0GAQgASgBUgJndBIQCgNndGUYBSABKAFSA2d0ZRIOCgJpbhgGIAMoAVICaW4SFQoGbm90X2luGAcgAygBUgVub3RJbhIhCgxpZ25vcmVfZW1wdHkYCCABKAhSC2lnbm9yZUVtcHR5');
@$core.Deprecated('Use int32RulesDescriptor instead')
const Int32Rules$json = const {
  '1': 'Int32Rules',
  '2': const [
    const {'1': 'const', '3': 1, '4': 1, '5': 5, '10': 'const'},
    const {'1': 'lt', '3': 2, '4': 1, '5': 5, '10': 'lt'},
    const {'1': 'lte', '3': 3, '4': 1, '5': 5, '10': 'lte'},
    const {'1': 'gt', '3': 4, '4': 1, '5': 5, '10': 'gt'},
    const {'1': 'gte', '3': 5, '4': 1, '5': 5, '10': 'gte'},
    const {'1': 'in', '3': 6, '4': 3, '5': 5, '10': 'in'},
    const {'1': 'not_in', '3': 7, '4': 3, '5': 5, '10': 'notIn'},
    const {'1': 'ignore_empty', '3': 8, '4': 1, '5': 8, '10': 'ignoreEmpty'},
  ],
};

/// Descriptor for `Int32Rules`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List int32RulesDescriptor = $convert.base64Decode('CgpJbnQzMlJ1bGVzEhQKBWNvbnN0GAEgASgFUgVjb25zdBIOCgJsdBgCIAEoBVICbHQSEAoDbHRlGAMgASgFUgNsdGUSDgoCZ3QYBCABKAVSAmd0EhAKA2d0ZRgFIAEoBVIDZ3RlEg4KAmluGAYgAygFUgJpbhIVCgZub3RfaW4YByADKAVSBW5vdEluEiEKDGlnbm9yZV9lbXB0eRgIIAEoCFILaWdub3JlRW1wdHk=');
@$core.Deprecated('Use int64RulesDescriptor instead')
const Int64Rules$json = const {
  '1': 'Int64Rules',
  '2': const [
    const {'1': 'const', '3': 1, '4': 1, '5': 3, '10': 'const'},
    const {'1': 'lt', '3': 2, '4': 1, '5': 3, '10': 'lt'},
    const {'1': 'lte', '3': 3, '4': 1, '5': 3, '10': 'lte'},
    const {'1': 'gt', '3': 4, '4': 1, '5': 3, '10': 'gt'},
    const {'1': 'gte', '3': 5, '4': 1, '5': 3, '10': 'gte'},
    const {'1': 'in', '3': 6, '4': 3, '5': 3, '10': 'in'},
    const {'1': 'not_in', '3': 7, '4': 3, '5': 3, '10': 'notIn'},
    const {'1': 'ignore_empty', '3': 8, '4': 1, '5': 8, '10': 'ignoreEmpty'},
  ],
};

/// Descriptor for `Int64Rules`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List int64RulesDescriptor = $convert.base64Decode('CgpJbnQ2NFJ1bGVzEhQKBWNvbnN0GAEgASgDUgVjb25zdBIOCgJsdBgCIAEoA1ICbHQSEAoDbHRlGAMgASgDUgNsdGUSDgoCZ3QYBCABKANSAmd0EhAKA2d0ZRgFIAEoA1IDZ3RlEg4KAmluGAYgAygDUgJpbhIVCgZub3RfaW4YByADKANSBW5vdEluEiEKDGlnbm9yZV9lbXB0eRgIIAEoCFILaWdub3JlRW1wdHk=');
@$core.Deprecated('Use uInt32RulesDescriptor instead')
const UInt32Rules$json = const {
  '1': 'UInt32Rules',
  '2': const [
    const {'1': 'const', '3': 1, '4': 1, '5': 13, '10': 'const'},
    const {'1': 'lt', '3': 2, '4': 1, '5': 13, '10': 'lt'},
    const {'1': 'lte', '3': 3, '4': 1, '5': 13, '10': 'lte'},
    const {'1': 'gt', '3': 4, '4': 1, '5': 13, '10': 'gt'},
    const {'1': 'gte', '3': 5, '4': 1, '5': 13, '10': 'gte'},
    const {'1': 'in', '3': 6, '4': 3, '5': 13, '10': 'in'},
    const {'1': 'not_in', '3': 7, '4': 3, '5': 13, '10': 'notIn'},
    const {'1': 'ignore_empty', '3': 8, '4': 1, '5': 8, '10': 'ignoreEmpty'},
  ],
};

/// Descriptor for `UInt32Rules`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uInt32RulesDescriptor = $convert.base64Decode('CgtVSW50MzJSdWxlcxIUCgVjb25zdBgBIAEoDVIFY29uc3QSDgoCbHQYAiABKA1SAmx0EhAKA2x0ZRgDIAEoDVIDbHRlEg4KAmd0GAQgASgNUgJndBIQCgNndGUYBSABKA1SA2d0ZRIOCgJpbhgGIAMoDVICaW4SFQoGbm90X2luGAcgAygNUgVub3RJbhIhCgxpZ25vcmVfZW1wdHkYCCABKAhSC2lnbm9yZUVtcHR5');
@$core.Deprecated('Use uInt64RulesDescriptor instead')
const UInt64Rules$json = const {
  '1': 'UInt64Rules',
  '2': const [
    const {'1': 'const', '3': 1, '4': 1, '5': 4, '10': 'const'},
    const {'1': 'lt', '3': 2, '4': 1, '5': 4, '10': 'lt'},
    const {'1': 'lte', '3': 3, '4': 1, '5': 4, '10': 'lte'},
    const {'1': 'gt', '3': 4, '4': 1, '5': 4, '10': 'gt'},
    const {'1': 'gte', '3': 5, '4': 1, '5': 4, '10': 'gte'},
    const {'1': 'in', '3': 6, '4': 3, '5': 4, '10': 'in'},
    const {'1': 'not_in', '3': 7, '4': 3, '5': 4, '10': 'notIn'},
    const {'1': 'ignore_empty', '3': 8, '4': 1, '5': 8, '10': 'ignoreEmpty'},
  ],
};

/// Descriptor for `UInt64Rules`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uInt64RulesDescriptor = $convert.base64Decode('CgtVSW50NjRSdWxlcxIUCgVjb25zdBgBIAEoBFIFY29uc3QSDgoCbHQYAiABKARSAmx0EhAKA2x0ZRgDIAEoBFIDbHRlEg4KAmd0GAQgASgEUgJndBIQCgNndGUYBSABKARSA2d0ZRIOCgJpbhgGIAMoBFICaW4SFQoGbm90X2luGAcgAygEUgVub3RJbhIhCgxpZ25vcmVfZW1wdHkYCCABKAhSC2lnbm9yZUVtcHR5');
@$core.Deprecated('Use sInt32RulesDescriptor instead')
const SInt32Rules$json = const {
  '1': 'SInt32Rules',
  '2': const [
    const {'1': 'const', '3': 1, '4': 1, '5': 17, '10': 'const'},
    const {'1': 'lt', '3': 2, '4': 1, '5': 17, '10': 'lt'},
    const {'1': 'lte', '3': 3, '4': 1, '5': 17, '10': 'lte'},
    const {'1': 'gt', '3': 4, '4': 1, '5': 17, '10': 'gt'},
    const {'1': 'gte', '3': 5, '4': 1, '5': 17, '10': 'gte'},
    const {'1': 'in', '3': 6, '4': 3, '5': 17, '10': 'in'},
    const {'1': 'not_in', '3': 7, '4': 3, '5': 17, '10': 'notIn'},
    const {'1': 'ignore_empty', '3': 8, '4': 1, '5': 8, '10': 'ignoreEmpty'},
  ],
};

/// Descriptor for `SInt32Rules`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sInt32RulesDescriptor = $convert.base64Decode('CgtTSW50MzJSdWxlcxIUCgVjb25zdBgBIAEoEVIFY29uc3QSDgoCbHQYAiABKBFSAmx0EhAKA2x0ZRgDIAEoEVIDbHRlEg4KAmd0GAQgASgRUgJndBIQCgNndGUYBSABKBFSA2d0ZRIOCgJpbhgGIAMoEVICaW4SFQoGbm90X2luGAcgAygRUgVub3RJbhIhCgxpZ25vcmVfZW1wdHkYCCABKAhSC2lnbm9yZUVtcHR5');
@$core.Deprecated('Use sInt64RulesDescriptor instead')
const SInt64Rules$json = const {
  '1': 'SInt64Rules',
  '2': const [
    const {'1': 'const', '3': 1, '4': 1, '5': 18, '10': 'const'},
    const {'1': 'lt', '3': 2, '4': 1, '5': 18, '10': 'lt'},
    const {'1': 'lte', '3': 3, '4': 1, '5': 18, '10': 'lte'},
    const {'1': 'gt', '3': 4, '4': 1, '5': 18, '10': 'gt'},
    const {'1': 'gte', '3': 5, '4': 1, '5': 18, '10': 'gte'},
    const {'1': 'in', '3': 6, '4': 3, '5': 18, '10': 'in'},
    const {'1': 'not_in', '3': 7, '4': 3, '5': 18, '10': 'notIn'},
    const {'1': 'ignore_empty', '3': 8, '4': 1, '5': 8, '10': 'ignoreEmpty'},
  ],
};

/// Descriptor for `SInt64Rules`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sInt64RulesDescriptor = $convert.base64Decode('CgtTSW50NjRSdWxlcxIUCgVjb25zdBgBIAEoElIFY29uc3QSDgoCbHQYAiABKBJSAmx0EhAKA2x0ZRgDIAEoElIDbHRlEg4KAmd0GAQgASgSUgJndBIQCgNndGUYBSABKBJSA2d0ZRIOCgJpbhgGIAMoElICaW4SFQoGbm90X2luGAcgAygSUgVub3RJbhIhCgxpZ25vcmVfZW1wdHkYCCABKAhSC2lnbm9yZUVtcHR5');
@$core.Deprecated('Use fixed32RulesDescriptor instead')
const Fixed32Rules$json = const {
  '1': 'Fixed32Rules',
  '2': const [
    const {'1': 'const', '3': 1, '4': 1, '5': 7, '10': 'const'},
    const {'1': 'lt', '3': 2, '4': 1, '5': 7, '10': 'lt'},
    const {'1': 'lte', '3': 3, '4': 1, '5': 7, '10': 'lte'},
    const {'1': 'gt', '3': 4, '4': 1, '5': 7, '10': 'gt'},
    const {'1': 'gte', '3': 5, '4': 1, '5': 7, '10': 'gte'},
    const {'1': 'in', '3': 6, '4': 3, '5': 7, '10': 'in'},
    const {'1': 'not_in', '3': 7, '4': 3, '5': 7, '10': 'notIn'},
    const {'1': 'ignore_empty', '3': 8, '4': 1, '5': 8, '10': 'ignoreEmpty'},
  ],
};

/// Descriptor for `Fixed32Rules`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fixed32RulesDescriptor = $convert.base64Decode('CgxGaXhlZDMyUnVsZXMSFAoFY29uc3QYASABKAdSBWNvbnN0Eg4KAmx0GAIgASgHUgJsdBIQCgNsdGUYAyABKAdSA2x0ZRIOCgJndBgEIAEoB1ICZ3QSEAoDZ3RlGAUgASgHUgNndGUSDgoCaW4YBiADKAdSAmluEhUKBm5vdF9pbhgHIAMoB1IFbm90SW4SIQoMaWdub3JlX2VtcHR5GAggASgIUgtpZ25vcmVFbXB0eQ==');
@$core.Deprecated('Use fixed64RulesDescriptor instead')
const Fixed64Rules$json = const {
  '1': 'Fixed64Rules',
  '2': const [
    const {'1': 'const', '3': 1, '4': 1, '5': 6, '10': 'const'},
    const {'1': 'lt', '3': 2, '4': 1, '5': 6, '10': 'lt'},
    const {'1': 'lte', '3': 3, '4': 1, '5': 6, '10': 'lte'},
    const {'1': 'gt', '3': 4, '4': 1, '5': 6, '10': 'gt'},
    const {'1': 'gte', '3': 5, '4': 1, '5': 6, '10': 'gte'},
    const {'1': 'in', '3': 6, '4': 3, '5': 6, '10': 'in'},
    const {'1': 'not_in', '3': 7, '4': 3, '5': 6, '10': 'notIn'},
    const {'1': 'ignore_empty', '3': 8, '4': 1, '5': 8, '10': 'ignoreEmpty'},
  ],
};

/// Descriptor for `Fixed64Rules`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fixed64RulesDescriptor = $convert.base64Decode('CgxGaXhlZDY0UnVsZXMSFAoFY29uc3QYASABKAZSBWNvbnN0Eg4KAmx0GAIgASgGUgJsdBIQCgNsdGUYAyABKAZSA2x0ZRIOCgJndBgEIAEoBlICZ3QSEAoDZ3RlGAUgASgGUgNndGUSDgoCaW4YBiADKAZSAmluEhUKBm5vdF9pbhgHIAMoBlIFbm90SW4SIQoMaWdub3JlX2VtcHR5GAggASgIUgtpZ25vcmVFbXB0eQ==');
@$core.Deprecated('Use sFixed32RulesDescriptor instead')
const SFixed32Rules$json = const {
  '1': 'SFixed32Rules',
  '2': const [
    const {'1': 'const', '3': 1, '4': 1, '5': 15, '10': 'const'},
    const {'1': 'lt', '3': 2, '4': 1, '5': 15, '10': 'lt'},
    const {'1': 'lte', '3': 3, '4': 1, '5': 15, '10': 'lte'},
    const {'1': 'gt', '3': 4, '4': 1, '5': 15, '10': 'gt'},
    const {'1': 'gte', '3': 5, '4': 1, '5': 15, '10': 'gte'},
    const {'1': 'in', '3': 6, '4': 3, '5': 15, '10': 'in'},
    const {'1': 'not_in', '3': 7, '4': 3, '5': 15, '10': 'notIn'},
    const {'1': 'ignore_empty', '3': 8, '4': 1, '5': 8, '10': 'ignoreEmpty'},
  ],
};

/// Descriptor for `SFixed32Rules`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sFixed32RulesDescriptor = $convert.base64Decode('Cg1TRml4ZWQzMlJ1bGVzEhQKBWNvbnN0GAEgASgPUgVjb25zdBIOCgJsdBgCIAEoD1ICbHQSEAoDbHRlGAMgASgPUgNsdGUSDgoCZ3QYBCABKA9SAmd0EhAKA2d0ZRgFIAEoD1IDZ3RlEg4KAmluGAYgAygPUgJpbhIVCgZub3RfaW4YByADKA9SBW5vdEluEiEKDGlnbm9yZV9lbXB0eRgIIAEoCFILaWdub3JlRW1wdHk=');
@$core.Deprecated('Use sFixed64RulesDescriptor instead')
const SFixed64Rules$json = const {
  '1': 'SFixed64Rules',
  '2': const [
    const {'1': 'const', '3': 1, '4': 1, '5': 16, '10': 'const'},
    const {'1': 'lt', '3': 2, '4': 1, '5': 16, '10': 'lt'},
    const {'1': 'lte', '3': 3, '4': 1, '5': 16, '10': 'lte'},
    const {'1': 'gt', '3': 4, '4': 1, '5': 16, '10': 'gt'},
    const {'1': 'gte', '3': 5, '4': 1, '5': 16, '10': 'gte'},
    const {'1': 'in', '3': 6, '4': 3, '5': 16, '10': 'in'},
    const {'1': 'not_in', '3': 7, '4': 3, '5': 16, '10': 'notIn'},
    const {'1': 'ignore_empty', '3': 8, '4': 1, '5': 8, '10': 'ignoreEmpty'},
  ],
};

/// Descriptor for `SFixed64Rules`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sFixed64RulesDescriptor = $convert.base64Decode('Cg1TRml4ZWQ2NFJ1bGVzEhQKBWNvbnN0GAEgASgQUgVjb25zdBIOCgJsdBgCIAEoEFICbHQSEAoDbHRlGAMgASgQUgNsdGUSDgoCZ3QYBCABKBBSAmd0EhAKA2d0ZRgFIAEoEFIDZ3RlEg4KAmluGAYgAygQUgJpbhIVCgZub3RfaW4YByADKBBSBW5vdEluEiEKDGlnbm9yZV9lbXB0eRgIIAEoCFILaWdub3JlRW1wdHk=');
@$core.Deprecated('Use boolRulesDescriptor instead')
const BoolRules$json = const {
  '1': 'BoolRules',
  '2': const [
    const {'1': 'const', '3': 1, '4': 1, '5': 8, '10': 'const'},
  ],
};

/// Descriptor for `BoolRules`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List boolRulesDescriptor = $convert.base64Decode('CglCb29sUnVsZXMSFAoFY29uc3QYASABKAhSBWNvbnN0');
@$core.Deprecated('Use stringRulesDescriptor instead')
const StringRules$json = const {
  '1': 'StringRules',
  '2': const [
    const {'1': 'const', '3': 1, '4': 1, '5': 9, '10': 'const'},
    const {'1': 'len', '3': 19, '4': 1, '5': 4, '10': 'len'},
    const {'1': 'min_len', '3': 2, '4': 1, '5': 4, '10': 'minLen'},
    const {'1': 'max_len', '3': 3, '4': 1, '5': 4, '10': 'maxLen'},
    const {'1': 'len_bytes', '3': 20, '4': 1, '5': 4, '10': 'lenBytes'},
    const {'1': 'min_bytes', '3': 4, '4': 1, '5': 4, '10': 'minBytes'},
    const {'1': 'max_bytes', '3': 5, '4': 1, '5': 4, '10': 'maxBytes'},
    const {'1': 'pattern', '3': 6, '4': 1, '5': 9, '10': 'pattern'},
    const {'1': 'prefix', '3': 7, '4': 1, '5': 9, '10': 'prefix'},
    const {'1': 'suffix', '3': 8, '4': 1, '5': 9, '10': 'suffix'},
    const {'1': 'contains', '3': 9, '4': 1, '5': 9, '10': 'contains'},
    const {'1': 'not_contains', '3': 23, '4': 1, '5': 9, '10': 'notContains'},
    const {'1': 'in', '3': 10, '4': 3, '5': 9, '10': 'in'},
    const {'1': 'not_in', '3': 11, '4': 3, '5': 9, '10': 'notIn'},
    const {'1': 'email', '3': 12, '4': 1, '5': 8, '9': 0, '10': 'email'},
    const {'1': 'hostname', '3': 13, '4': 1, '5': 8, '9': 0, '10': 'hostname'},
    const {'1': 'ip', '3': 14, '4': 1, '5': 8, '9': 0, '10': 'ip'},
    const {'1': 'ipv4', '3': 15, '4': 1, '5': 8, '9': 0, '10': 'ipv4'},
    const {'1': 'ipv6', '3': 16, '4': 1, '5': 8, '9': 0, '10': 'ipv6'},
    const {'1': 'uri', '3': 17, '4': 1, '5': 8, '9': 0, '10': 'uri'},
    const {'1': 'uri_ref', '3': 18, '4': 1, '5': 8, '9': 0, '10': 'uriRef'},
    const {'1': 'address', '3': 21, '4': 1, '5': 8, '9': 0, '10': 'address'},
    const {'1': 'uuid', '3': 22, '4': 1, '5': 8, '9': 0, '10': 'uuid'},
    const {'1': 'well_known_regex', '3': 24, '4': 1, '5': 14, '6': '.validate.KnownRegex', '9': 0, '10': 'wellKnownRegex'},
    const {'1': 'strict', '3': 25, '4': 1, '5': 8, '7': 'true', '10': 'strict'},
    const {'1': 'ignore_empty', '3': 26, '4': 1, '5': 8, '10': 'ignoreEmpty'},
  ],
  '8': const [
    const {'1': 'well_known'},
  ],
};

/// Descriptor for `StringRules`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stringRulesDescriptor = $convert.base64Decode('CgtTdHJpbmdSdWxlcxIUCgVjb25zdBgBIAEoCVIFY29uc3QSEAoDbGVuGBMgASgEUgNsZW4SFwoHbWluX2xlbhgCIAEoBFIGbWluTGVuEhcKB21heF9sZW4YAyABKARSBm1heExlbhIbCglsZW5fYnl0ZXMYFCABKARSCGxlbkJ5dGVzEhsKCW1pbl9ieXRlcxgEIAEoBFIIbWluQnl0ZXMSGwoJbWF4X2J5dGVzGAUgASgEUghtYXhCeXRlcxIYCgdwYXR0ZXJuGAYgASgJUgdwYXR0ZXJuEhYKBnByZWZpeBgHIAEoCVIGcHJlZml4EhYKBnN1ZmZpeBgIIAEoCVIGc3VmZml4EhoKCGNvbnRhaW5zGAkgASgJUghjb250YWlucxIhCgxub3RfY29udGFpbnMYFyABKAlSC25vdENvbnRhaW5zEg4KAmluGAogAygJUgJpbhIVCgZub3RfaW4YCyADKAlSBW5vdEluEhYKBWVtYWlsGAwgASgISABSBWVtYWlsEhwKCGhvc3RuYW1lGA0gASgISABSCGhvc3RuYW1lEhAKAmlwGA4gASgISABSAmlwEhQKBGlwdjQYDyABKAhIAFIEaXB2NBIUCgRpcHY2GBAgASgISABSBGlwdjYSEgoDdXJpGBEgASgISABSA3VyaRIZCgd1cmlfcmVmGBIgASgISABSBnVyaVJlZhIaCgdhZGRyZXNzGBUgASgISABSB2FkZHJlc3MSFAoEdXVpZBgWIAEoCEgAUgR1dWlkEkAKEHdlbGxfa25vd25fcmVnZXgYGCABKA4yFC52YWxpZGF0ZS5Lbm93blJlZ2V4SABSDndlbGxLbm93blJlZ2V4EhwKBnN0cmljdBgZIAEoCDoEdHJ1ZVIGc3RyaWN0EiEKDGlnbm9yZV9lbXB0eRgaIAEoCFILaWdub3JlRW1wdHlCDAoKd2VsbF9rbm93bg==');
@$core.Deprecated('Use bytesRulesDescriptor instead')
const BytesRules$json = const {
  '1': 'BytesRules',
  '2': const [
    const {'1': 'const', '3': 1, '4': 1, '5': 12, '10': 'const'},
    const {'1': 'len', '3': 13, '4': 1, '5': 4, '10': 'len'},
    const {'1': 'min_len', '3': 2, '4': 1, '5': 4, '10': 'minLen'},
    const {'1': 'max_len', '3': 3, '4': 1, '5': 4, '10': 'maxLen'},
    const {'1': 'pattern', '3': 4, '4': 1, '5': 9, '10': 'pattern'},
    const {'1': 'prefix', '3': 5, '4': 1, '5': 12, '10': 'prefix'},
    const {'1': 'suffix', '3': 6, '4': 1, '5': 12, '10': 'suffix'},
    const {'1': 'contains', '3': 7, '4': 1, '5': 12, '10': 'contains'},
    const {'1': 'in', '3': 8, '4': 3, '5': 12, '10': 'in'},
    const {'1': 'not_in', '3': 9, '4': 3, '5': 12, '10': 'notIn'},
    const {'1': 'ip', '3': 10, '4': 1, '5': 8, '9': 0, '10': 'ip'},
    const {'1': 'ipv4', '3': 11, '4': 1, '5': 8, '9': 0, '10': 'ipv4'},
    const {'1': 'ipv6', '3': 12, '4': 1, '5': 8, '9': 0, '10': 'ipv6'},
    const {'1': 'ignore_empty', '3': 14, '4': 1, '5': 8, '10': 'ignoreEmpty'},
  ],
  '8': const [
    const {'1': 'well_known'},
  ],
};

/// Descriptor for `BytesRules`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bytesRulesDescriptor = $convert.base64Decode('CgpCeXRlc1J1bGVzEhQKBWNvbnN0GAEgASgMUgVjb25zdBIQCgNsZW4YDSABKARSA2xlbhIXCgdtaW5fbGVuGAIgASgEUgZtaW5MZW4SFwoHbWF4X2xlbhgDIAEoBFIGbWF4TGVuEhgKB3BhdHRlcm4YBCABKAlSB3BhdHRlcm4SFgoGcHJlZml4GAUgASgMUgZwcmVmaXgSFgoGc3VmZml4GAYgASgMUgZzdWZmaXgSGgoIY29udGFpbnMYByABKAxSCGNvbnRhaW5zEg4KAmluGAggAygMUgJpbhIVCgZub3RfaW4YCSADKAxSBW5vdEluEhAKAmlwGAogASgISABSAmlwEhQKBGlwdjQYCyABKAhIAFIEaXB2NBIUCgRpcHY2GAwgASgISABSBGlwdjYSIQoMaWdub3JlX2VtcHR5GA4gASgIUgtpZ25vcmVFbXB0eUIMCgp3ZWxsX2tub3du');
@$core.Deprecated('Use enumRulesDescriptor instead')
const EnumRules$json = const {
  '1': 'EnumRules',
  '2': const [
    const {'1': 'const', '3': 1, '4': 1, '5': 5, '10': 'const'},
    const {'1': 'defined_only', '3': 2, '4': 1, '5': 8, '10': 'definedOnly'},
    const {'1': 'in', '3': 3, '4': 3, '5': 5, '10': 'in'},
    const {'1': 'not_in', '3': 4, '4': 3, '5': 5, '10': 'notIn'},
  ],
};

/// Descriptor for `EnumRules`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List enumRulesDescriptor = $convert.base64Decode('CglFbnVtUnVsZXMSFAoFY29uc3QYASABKAVSBWNvbnN0EiEKDGRlZmluZWRfb25seRgCIAEoCFILZGVmaW5lZE9ubHkSDgoCaW4YAyADKAVSAmluEhUKBm5vdF9pbhgEIAMoBVIFbm90SW4=');
@$core.Deprecated('Use messageRulesDescriptor instead')
const MessageRules$json = const {
  '1': 'MessageRules',
  '2': const [
    const {'1': 'skip', '3': 1, '4': 1, '5': 8, '10': 'skip'},
    const {'1': 'required', '3': 2, '4': 1, '5': 8, '10': 'required'},
  ],
};

/// Descriptor for `MessageRules`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageRulesDescriptor = $convert.base64Decode('CgxNZXNzYWdlUnVsZXMSEgoEc2tpcBgBIAEoCFIEc2tpcBIaCghyZXF1aXJlZBgCIAEoCFIIcmVxdWlyZWQ=');
@$core.Deprecated('Use repeatedRulesDescriptor instead')
const RepeatedRules$json = const {
  '1': 'RepeatedRules',
  '2': const [
    const {'1': 'min_items', '3': 1, '4': 1, '5': 4, '10': 'minItems'},
    const {'1': 'max_items', '3': 2, '4': 1, '5': 4, '10': 'maxItems'},
    const {'1': 'unique', '3': 3, '4': 1, '5': 8, '10': 'unique'},
    const {'1': 'items', '3': 4, '4': 1, '5': 11, '6': '.validate.FieldRules', '10': 'items'},
    const {'1': 'ignore_empty', '3': 5, '4': 1, '5': 8, '10': 'ignoreEmpty'},
  ],
};

/// Descriptor for `RepeatedRules`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List repeatedRulesDescriptor = $convert.base64Decode('Cg1SZXBlYXRlZFJ1bGVzEhsKCW1pbl9pdGVtcxgBIAEoBFIIbWluSXRlbXMSGwoJbWF4X2l0ZW1zGAIgASgEUghtYXhJdGVtcxIWCgZ1bmlxdWUYAyABKAhSBnVuaXF1ZRIqCgVpdGVtcxgEIAEoCzIULnZhbGlkYXRlLkZpZWxkUnVsZXNSBWl0ZW1zEiEKDGlnbm9yZV9lbXB0eRgFIAEoCFILaWdub3JlRW1wdHk=');
@$core.Deprecated('Use mapRulesDescriptor instead')
const MapRules$json = const {
  '1': 'MapRules',
  '2': const [
    const {'1': 'min_pairs', '3': 1, '4': 1, '5': 4, '10': 'minPairs'},
    const {'1': 'max_pairs', '3': 2, '4': 1, '5': 4, '10': 'maxPairs'},
    const {'1': 'no_sparse', '3': 3, '4': 1, '5': 8, '10': 'noSparse'},
    const {'1': 'keys', '3': 4, '4': 1, '5': 11, '6': '.validate.FieldRules', '10': 'keys'},
    const {'1': 'values', '3': 5, '4': 1, '5': 11, '6': '.validate.FieldRules', '10': 'values'},
    const {'1': 'ignore_empty', '3': 6, '4': 1, '5': 8, '10': 'ignoreEmpty'},
  ],
};

/// Descriptor for `MapRules`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mapRulesDescriptor = $convert.base64Decode('CghNYXBSdWxlcxIbCgltaW5fcGFpcnMYASABKARSCG1pblBhaXJzEhsKCW1heF9wYWlycxgCIAEoBFIIbWF4UGFpcnMSGwoJbm9fc3BhcnNlGAMgASgIUghub1NwYXJzZRIoCgRrZXlzGAQgASgLMhQudmFsaWRhdGUuRmllbGRSdWxlc1IEa2V5cxIsCgZ2YWx1ZXMYBSABKAsyFC52YWxpZGF0ZS5GaWVsZFJ1bGVzUgZ2YWx1ZXMSIQoMaWdub3JlX2VtcHR5GAYgASgIUgtpZ25vcmVFbXB0eQ==');
@$core.Deprecated('Use anyRulesDescriptor instead')
const AnyRules$json = const {
  '1': 'AnyRules',
  '2': const [
    const {'1': 'required', '3': 1, '4': 1, '5': 8, '10': 'required'},
    const {'1': 'in', '3': 2, '4': 3, '5': 9, '10': 'in'},
    const {'1': 'not_in', '3': 3, '4': 3, '5': 9, '10': 'notIn'},
  ],
};

/// Descriptor for `AnyRules`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List anyRulesDescriptor = $convert.base64Decode('CghBbnlSdWxlcxIaCghyZXF1aXJlZBgBIAEoCFIIcmVxdWlyZWQSDgoCaW4YAiADKAlSAmluEhUKBm5vdF9pbhgDIAMoCVIFbm90SW4=');
@$core.Deprecated('Use durationRulesDescriptor instead')
const DurationRules$json = const {
  '1': 'DurationRules',
  '2': const [
    const {'1': 'required', '3': 1, '4': 1, '5': 8, '10': 'required'},
    const {'1': 'const', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Duration', '10': 'const'},
    const {'1': 'lt', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Duration', '10': 'lt'},
    const {'1': 'lte', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Duration', '10': 'lte'},
    const {'1': 'gt', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Duration', '10': 'gt'},
    const {'1': 'gte', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Duration', '10': 'gte'},
    const {'1': 'in', '3': 7, '4': 3, '5': 11, '6': '.google.protobuf.Duration', '10': 'in'},
    const {'1': 'not_in', '3': 8, '4': 3, '5': 11, '6': '.google.protobuf.Duration', '10': 'notIn'},
  ],
};

/// Descriptor for `DurationRules`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List durationRulesDescriptor = $convert.base64Decode('Cg1EdXJhdGlvblJ1bGVzEhoKCHJlcXVpcmVkGAEgASgIUghyZXF1aXJlZBIvCgVjb25zdBgCIAEoCzIZLmdvb2dsZS5wcm90b2J1Zi5EdXJhdGlvblIFY29uc3QSKQoCbHQYAyABKAsyGS5nb29nbGUucHJvdG9idWYuRHVyYXRpb25SAmx0EisKA2x0ZRgEIAEoCzIZLmdvb2dsZS5wcm90b2J1Zi5EdXJhdGlvblIDbHRlEikKAmd0GAUgASgLMhkuZ29vZ2xlLnByb3RvYnVmLkR1cmF0aW9uUgJndBIrCgNndGUYBiABKAsyGS5nb29nbGUucHJvdG9idWYuRHVyYXRpb25SA2d0ZRIpCgJpbhgHIAMoCzIZLmdvb2dsZS5wcm90b2J1Zi5EdXJhdGlvblICaW4SMAoGbm90X2luGAggAygLMhkuZ29vZ2xlLnByb3RvYnVmLkR1cmF0aW9uUgVub3RJbg==');
@$core.Deprecated('Use timestampRulesDescriptor instead')
const TimestampRules$json = const {
  '1': 'TimestampRules',
  '2': const [
    const {'1': 'required', '3': 1, '4': 1, '5': 8, '10': 'required'},
    const {'1': 'const', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'const'},
    const {'1': 'lt', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'lt'},
    const {'1': 'lte', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'lte'},
    const {'1': 'gt', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'gt'},
    const {'1': 'gte', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'gte'},
    const {'1': 'lt_now', '3': 7, '4': 1, '5': 8, '10': 'ltNow'},
    const {'1': 'gt_now', '3': 8, '4': 1, '5': 8, '10': 'gtNow'},
    const {'1': 'within', '3': 9, '4': 1, '5': 11, '6': '.google.protobuf.Duration', '10': 'within'},
  ],
};

/// Descriptor for `TimestampRules`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timestampRulesDescriptor = $convert.base64Decode('Cg5UaW1lc3RhbXBSdWxlcxIaCghyZXF1aXJlZBgBIAEoCFIIcmVxdWlyZWQSMAoFY29uc3QYAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgVjb25zdBIqCgJsdBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSAmx0EiwKA2x0ZRgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSA2x0ZRIqCgJndBgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSAmd0EiwKA2d0ZRgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSA2d0ZRIVCgZsdF9ub3cYByABKAhSBWx0Tm93EhUKBmd0X25vdxgIIAEoCFIFZ3ROb3cSMQoGd2l0aGluGAkgASgLMhkuZ29vZ2xlLnByb3RvYnVmLkR1cmF0aW9uUgZ3aXRoaW4=');
