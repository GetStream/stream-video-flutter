import 'dart:io';

import 'package:meta/meta.dart';

/// Why [error] ended a request before the server's answer was read, or
/// `null` when it is not a transport failure.
///
/// Reads `normalized reason — platform detail`, as in
/// `DNS lookup failed — Failed host lookup: 'video.stream-io-api.com' (nodename nor servname provided)`.
/// The detail comes from the platform, never from the server.
@internal
String? platformTransportFailureOf(Object? error) {
  return switch (error) {
    SocketException(:final message, :final osError)
        when message.contains('host lookup') =>
      _withDetail('DNS lookup failed', _detail(message, osError)),
    SocketException(:final message, :final osError) => _withDetail(
      'connection failed',
      _detail(message, osError),
    ),
    // HandshakeException and CertificateException are both TlsExceptions. A
    // handshake's own message is only "Handshake error in client"; why it
    // failed — CERTIFICATE_VERIFY_FAILED and the rest — is in the OS error.
    TlsException(:final message, :final osError) => _withDetail(
      'TLS connection failed',
      _detail(message, osError),
    ),
    HttpException(:final message) => _withDetail('connection failed', message),
    _ => null,
  };
}

/// [message] and, when it adds anything, the OS error behind it.
String _detail(String message, OSError? osError) {
  final osMessage = osError?.message.trim() ?? '';
  if (osMessage.isEmpty || message.contains(osMessage)) return message;
  if (message.isEmpty) return osMessage;
  return '$message ($osMessage)';
}

String _withDetail(String reason, String detail) {
  return detail.isEmpty ? reason : '$reason — $detail';
}
