import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../screens/call_route_page.dart';
import '../screens/home_screen.dart';
import '../screens/livestream_demo_screen.dart';
import '../screens/login_screen.dart';
import '../utils/consts.dart';

part 'routes.g.dart';

@immutable
@TypedGoRoute<HomeRoute>(
  path: '/',
  name: 'home',
  routes: [TypedGoRoute<JoinRoute>(path: 'join/:callId', name: 'join')],
)
class HomeRoute extends GoRouteData with $HomeRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}

@immutable
@TypedGoRoute<LoginRoute>(path: '/login', name: 'login')
class LoginRoute extends GoRouteData with $LoginRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginScreen();
  }
}

/// The page for one call, `/join/<callId>`.
///
/// It takes the query parameters pronto's links use: `type` for the call type,
/// `encryption_key` for the shared passphrase of an encrypted call, and the
/// codec overrides `video_encoder` (or `video_codec`), `fmtp`, `bitrate`,
/// `max_simulcast_layers`, `video_decoder` and `video_decoder_fmtp`.
@immutable
class JoinRoute extends GoRouteData with $JoinRoute {
  const JoinRoute({required this.callId});

  final String callId;

  /// [location] with the call's type, left out for [kCallType], and the
  /// shared passphrase of an encrypted call.
  String locationFor({StreamCallType? callType, String? encryptionKey}) {
    final type = callType?.value;
    final query = {
      if (type != null && type != kCallType.value) 'type': type,
      if (encryptionKey != null && encryptionKey.isNotEmpty)
        'encryption_key': encryptionKey,
    };
    if (query.isEmpty) return location;

    return Uri(path: location, queryParameters: query).toString();
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final query = state.uri.queryParameters;
    final type = query['type'];

    return CallRoutePage(
      callId: callId,
      callType: type == null || type.isEmpty
          ? kCallType
          : StreamCallType.fromString(type),
      linkHost: state.uri.host,
      encryptionKey: query['encryption_key'],
      publishOptions: _publishOptions(query),
    );
  }
}

/// The codec overrides in [query], null when it has none.
ClientPublishOptions? _publishOptions(Map<String, String> query) {
  PreferredCodec? codec(String? name) =>
      name == null ? null : PreferredCodec.values.asNameMap()[name];
  int? number(String? value) => value == null ? null : int.tryParse(value);

  final preferredCodec = codec(query['video_encoder'] ?? query['video_codec']);
  final fmtpLine = query['fmtp'];
  final preferredBitrate = number(query['bitrate']);
  final maxSimulcastLayers = number(query['max_simulcast_layers']);
  final subscriberCodec = codec(query['video_decoder']);
  final subscriberFmtpLine = query['video_decoder_fmtp'];

  final overrides = [
    preferredCodec,
    fmtpLine,
    preferredBitrate,
    maxSimulcastLayers,
    subscriberCodec,
    subscriberFmtpLine,
  ];
  if (overrides.every((it) => it == null)) return null;

  return ClientPublishOptions(
    preferredCodec: preferredCodec,
    fmtpLine: fmtpLine,
    preferredBitrate: preferredBitrate,
    maxSimulcastLayers: maxSimulcastLayers,
    subscriberCodec: subscriberCodec,
    subscriberFmtpLine: subscriberFmtpLine,
  );
}

@immutable
@TypedGoRoute<LivestreamRoute>(
  path: '/livestream/:callId',
  name: 'livestream',
)
class LivestreamRoute extends GoRouteData with $LivestreamRoute {
  const LivestreamRoute({required this.callId});

  final String callId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LivestreamDemoScreen(callId: callId);
  }
}
