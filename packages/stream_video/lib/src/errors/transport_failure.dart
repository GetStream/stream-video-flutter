import 'package:meta/meta.dart';

/// Why [error] kept a request from reaching the server, or `null` when it is
/// not a transport failure this platform can read.
///
/// The web reports none: the browser keeps the reason a request failed to
/// itself.
@internal
String? platformTransportFailureOf(Object? error) => null;
