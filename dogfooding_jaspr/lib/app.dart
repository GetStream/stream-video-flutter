import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:stream_video/stream_video.dart';

import 'screens/call_screen.dart';
import 'screens/login_screen.dart';
import 'services/token_service.dart';

class App extends StatefulComponent {
  const App({super.key});

  @override
  State<App> createState() => _AppState();

  @css
  static List<StyleRule> get styles => [
    css('html', [
      css('&').styles(
        margin: .zero,
        padding: .zero,
        height: 100.percent,
        boxSizing: .borderBox,
      ),
    ]),
    css('body', [
      css('&').styles(
        margin: .zero,
        padding: .zero,
        height: 100.percent,
        boxSizing: .borderBox,
      ),
    ]),
  ];
}

class _AppState extends State<App> {
  final _tokenService = const TokenService();

  Call? _call;
  String? _error;

  Future<void> _join(String userId, String callId) async {
    setState(() => _error = null);

    try {
      final tokenResponse = await _tokenService.loadToken(userId);

      final streamVideo = StreamVideo(
        tokenResponse.apiKey,
        user: User.regular(userId: userId, name: userId),
        userToken: tokenResponse.token,
        failIfSingletonExists: false,
      );

      await streamVideo.connect();

      final call = streamVideo.makeCall(
        callType: StreamCallType.defaultType(),
        id: callId,
      );
      await call.getOrCreate();
      final result = await call.join(
        connectOptions: CallConnectOptions(
          camera: TrackOption.enabled(),
          microphone: TrackOption.enabled(),
        ),
      );

      if (result.isFailure) {
        final error = (result as Failure).error;
        setState(() => _error = 'Failed to join call: $error');
        return;
      }

      setState(() => _call = call);
    } catch (e) {
      setState(() => _error = 'Failed to join call: $e');
    }
  }

  Future<void> _leave() async {
    final call = _call;
    setState(() => _call = null);
    if (call != null) {
      await call.leave();
    }
    await StreamVideo.reset(disconnect: true);
  }

  @override
  Component build(BuildContext context) {
    final call = _call;
    if (call == null) {
      return LoginScreen(onJoin: _join, error: _error);
    }
    return CallScreen(call: call, onLeave: _leave);
  }
}
