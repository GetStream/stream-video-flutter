import 'package:equatable/equatable.dart';

import '../sdp.dart';

/// Represents 'fmtp' attribute
/// Reference: https://www.rfc-editor.org/rfc/rfc4566#section-6.
/// Format: a=fmtp:<format> <format specific parameters>
class Fmtp with EquatableMixin {
  const Fmtp({
    required this.payloadType,
    required this.parameters,
  });

  final String payloadType;
  final Map<String, String> parameters;

  Fmtp copyWith({
    String? payloadType,
    Map<String, String>? parameters,
  }) {
    return Fmtp(
      payloadType: payloadType ?? this.payloadType,
      parameters: parameters ?? this.parameters,
    );
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [payloadType, parameters];
}

extension FmtpSdpUtils on SdpLine {
  bool get isFmtp => startsWith('a=fmtp');
}

class FmtpParser {
  final _regex = RegExp(r'^a=fmtp:(\d+) ([^;\r\n]+(?:;[^;\r\n]+)*)?$');
  final _mapRegexp = RegExp(r'([\w-]+)=(.*)');
  final _groupPayloadType = 1;
  final _groupFormatParameters = 2;

  Fmtp? parse(SdpLine sdpLine) {
    final match = _regex.firstMatch(sdpLine);
    if (match == null) {
      return null;
    }
    final payloadType = match.group(_groupPayloadType);
    final formatParameters = match.group(_groupFormatParameters);
    if (payloadType == null || formatParameters == null) {
      return null;
    }
    final parameters = <String, String>{};
    final pairs = formatParameters.split(';');
    for (final pair in pairs) {
      final keyValue = _mapRegexp.firstMatch(pair);
      //final keyValue = pair.split('=');
      final key = keyValue?[1]?.trim();
      final value = keyValue?[2]?.trim();
      if (key != null && value != null) {
        parameters[key] = value;
      }
    }
    return Fmtp(
      payloadType: payloadType,
      parameters: Map.unmodifiable(parameters),
    );
  }
}

extension FmtpLineComposer on Fmtp {
  SdpLine toSdpLine() {
    final buffer = StringBuffer()
      ..write('a=fmtp:')
      ..write(payloadType)
      ..write(' ');
    if (parameters.isNotEmpty) {
      final entries = parameters.entries.map((it) => '${it.key}=${it.value}');
      buffer.writeAll(entries, ';');
    }
    return buffer.toString();
  }
}
