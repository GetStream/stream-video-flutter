// 🎯 Dart imports:
import 'dart:async';
import 'dart:math' as math;

// 📦 Package imports:
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter_background.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

// 🌎 Project imports:
import '../app/user_auth_controller.dart';
import '../core/model/environment.dart';
import '../core/repos/app_preferences.dart';
import '../di/injector.dart';
import '../router/routes.dart';
import '../theme/app_palette.dart';
import '../utils/assets.dart';
import '../utils/consts.dart';
import '../utils/loading_dialog.dart';
import '../widgets/environment_switcher.dart';
import '../widgets/stream_button.dart';
import '../widgets/user_actions_avatar.dart';
import 'qr_code_scanner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final _streamVideo = locator.get<StreamVideo>();
  late final _appPreferences = locator.get<AppPreferences>();
  late final _userAuthController = locator.get<UserAuthController>();
  late final _callIdController = TextEditingController();

  late Call _call;

  @override
  void initState() {
    if (CurrentPlatform.isMobile || CurrentPlatform.isWeb) {
      () async {
        await [
          Permission.camera,
          Permission.microphone,
          if (CurrentPlatform.isAndroid) Permission.phone,
          Permission.notification,
        ].request();
      }();

      StreamVideoPushNotificationManager.ensureFullScreenIntentPermission();
    }

    StreamBackgroundService.init(
      StreamVideo.instance,
      onButtonClick: (call, type, serviceType) async {
        switch (serviceType) {
          case ServiceType.call:
            await call.reject(reason: CallRejectReason.cancel());
          case ServiceType.screenSharing:
            await StreamVideoFlutterBackground.stopService(
              ServiceType.screenSharing,
              callCid: call.callCid.value,
            );

            await call.setScreenShareEnabled(enabled: false);
        }
      },
    );

    super.initState();
  }

  Future<void> _getOrCreateCall({List<String> memberIds = const []}) async {
    var callId = _callIdController.text;

    // Always generate a new call id for ringing
    if (callId.isEmpty || memberIds.isNotEmpty) {
      callId = generateAlphanumericString(12);
    }

    unawaited(showLoadingIndicator(context));
    _call = _streamVideo.makeCall(
      callType: kCallType,
      id: callId,
      preferences: DefaultCallPreferences(
        closedCaptionsVisibleCaptions: 3,
        closedCaptionsVisibilityDurationMs: 5000,
        // clientPublishOptions: ClientPublishOptions(
        // preferredCodec: PreferredCodec.h264,
        // fmtpLine: 'a=fmtp:96max-fr=60;max-fs=12288', <-- VP8
        // fmtpLine: 'level-idx=5;profile=0;tier=0', <-- AV1
        // ),
      ),
    );

    final isRinging = memberIds.isNotEmpty;

    try {
      final result = await _call.getOrCreate(
        memberIds: memberIds,
        ringing: isRinging,
        video: true,
      );

      result.fold(
        success: (success) {
          if (mounted) {
            if (isRinging) {
              CallRoute(
                $extra: (
                  call: _call,
                  connectOptions: null,
                  effectsManager: null,
                ),
              ).push<void>(context);
            } else {
              LobbyRoute($extra: _call).push<void>(context);
            }
          }
        },
        failure: (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 20),
              content: Text('Error: ${failure.error.message}'),
            ),
          );
        },
      );
    } catch (e, stk) {
      debugPrint('Error joining or creating call: $e');
      debugPrint(stk.toString());
    } finally {
      if (mounted) {
        hideLoadingIndicator(context);
      }
    }
  }

  Future<void> _directCall(BuildContext context) async {
    final controller = TextEditingController();
    final theme = Theme.of(context);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.scaffoldBackgroundColor,
          title: Text(
            'Enter the IDs of users you want to call (separated by commas)',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'User ID',
                  hintStyle: TextStyle(color: Colors.white30),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 150,
                  child: StreamButton.active(
                    label: 'Call',
                    icon: const Icon(
                      Icons.video_camera_front,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _getOrCreateCall(
                        memberIds: controller.text
                            .split(',')
                            .map((e) => e.trim())
                            .toList(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _callIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _userAuthController.currentUser;
    assert(currentUser != null, 'User must be logged in to access home screen');

    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final isHorizontal = size.width > size.height || size.height < 600;
    final width = math.min(size.width, kMaxWidthRegularScreen);
    final name = currentUser!.name;

    final logo = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 220),
      child: Hero(
        tag: 'stream_logo',
        child: Image.asset(streamVideoIconAsset, width: width * 0.6),
      ),
    );

    final appTitle = [
      Text('Stream', style: theme.textTheme.headlineMedium),
      Text(
        '[Video Calling]',
        style: theme.textTheme.headlineMedium?.apply(
          color: AppColorPalette.appGreen,
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: UserActionsAvatar(currentUser: currentUser),
        titleSpacing: 4,
        centerTitle: false,
        title: Text(name, style: theme.textTheme.bodyMedium),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: EnvironmentBanner(
                  currentEnvironment: _appPreferences.environment,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: _userAuthController.logout,
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kMaxWidthRegularScreen),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isHorizontal) ...[
                  Row(
                    children: [
                      Expanded(child: logo),
                      const SizedBox(width: 24),
                      Column(children: appTitle),
                    ],
                  ),
                  const SizedBox(height: 12),
                ] else ...[
                  logo,
                  const SizedBox(height: 24),
                  ...appTitle,
                  const SizedBox(height: 24),
                ],
                Text(
                  'Start a new call, join a meeting by\n'
                  'entering the call ID or by scanning\n'
                  'a QR code.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.apply(
                    color: AppColorPalette.secondaryText,
                  ),
                ),
                const SizedBox(height: 36),
                const SizedBox(height: 8),
                _JoinForm(
                  callIdController: _callIdController,
                  onJoinPressed: _getOrCreateCall,
                  onLogoutPressed: _userAuthController.logout,
                  currentEnvironment: _appPreferences.environment,
                ),
                const SizedBox(height: 24),
                StreamButton.primary(
                  label: 'Start New Call',
                  icon: const Icon(Icons.video_call, color: Colors.white),
                  onPressed: _getOrCreateCall,
                ),
                const SizedBox(height: 8),
                StreamButton.tertiary(
                  label: 'Direct Call',
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () => _directCall(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _JoinForm extends StatelessWidget {
  const _JoinForm({
    required this.callIdController,
    required this.onJoinPressed,
    required this.onLogoutPressed,
    required this.currentEnvironment,
  });

  final TextEditingController callIdController;
  final VoidCallback onJoinPressed;
  final VoidCallback onLogoutPressed;
  final Environment currentEnvironment;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Flexible(
              child: TextField(
                controller: callIdController,
                style: const TextStyle(color: Colors.white),
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColorPalette.secondaryText,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(36)),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(36)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  isDense: true,
                  hintStyle: const TextStyle(
                    color: AppColorPalette.secondaryText,
                  ),
                  hintText: 'Enter call id',
                  // suffix button to generate a random call id
                  suffixIcon: CurrentPlatform.isMobile
                      ? _scanQRButton(context)
                      : _refreshIconButton(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ValueListenableBuilder(
              valueListenable: callIdController,
              builder: (context, value, _) {
                final hasText = value.text.isNotEmpty;
                return StreamButton.active(
                  label: 'Join call',
                  icon: const Icon(Icons.login, color: Colors.white),
                  onPressed: hasText ? onJoinPressed : () {},
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _refreshIconButton() => IconButton(
    icon: const Icon(Icons.refresh),
    color: Colors.white,
    padding: EdgeInsets.zero,
    onPressed: () {
      // generate a 10 character nanoId for call id
      final callId = generateAlphanumericString(10);
      callIdController.value = TextEditingValue(
        text: callId,
        selection: TextSelection.collapsed(offset: callId.length),
      );
    },
  );

  Widget _scanQRButton(BuildContext context) => IconButton(
    icon: const Icon(Icons.qr_code),
    color: Colors.white,
    padding: EdgeInsets.zero,
    onPressed: () async {
      final result = await QrCodeScanner.scan(context);

      if (context.mounted && result != null) {
        await _handleJoinUrl(context, result);
      }
    },
  );

  Future<void> _handleJoinUrl(BuildContext context, String url) async {
    Uri uri;
    try {
      uri = Uri.parse(url);
    } on FormatException catch (_) {
      return;
    }

    final Environment environment;
    try {
      environment = Environment.fromBaseUrl(uri.origin);
    } on Exception catch (_) {
      return;
    }

    if (environment == Environment.livestream) {
      // Example: https://livestream-react-demo.vercel.app/?id=6G9bxsMaFbMiGvLWWP85d&type=livestream
      final callId = uri.queryParameters['id'];
      if (callId != null) {
        await LivestreamRoute($extra: callId).push<void>(context);
      }
      return;
    }

    if (environment != currentEnvironment) {
      if (!kIsProd) {
        await showDialog<void>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Invalid environment'),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              content: Text(
                'To join this call you have to switch to "${environment.displayName}" environment',
              ),
              buttonPadding: const EdgeInsets.all(16),
              actions: [
                StreamButton.tertiary(
                  label: 'Cancel',
                  onPressed: Navigator.of(context).pop,
                ),
                const SizedBox(height: 8),
                StreamButton.active(
                  label: 'Logout',
                  onPressed: onLogoutPressed,
                ),
              ],
            );
          },
        );
      }
      return;
    }

    // Fetch the callId from the path components
    // e.g https://getstream.io/join/path-call-id
    final pathSegmentsLength = uri.pathSegments.length;
    final callPathId =
        pathSegmentsLength >= 2 &&
            uri.pathSegments[pathSegmentsLength - 2] == 'join'
        ? uri.pathSegments.last
        : null;

    // Fetch the callId from the query parameters
    // e.g https://getstream.io/video/demos?id=parameter-call-id
    final callParameterId = uri.queryParameters['id'];

    final callId = callPathId ?? callParameterId;

    if (callId != null) {
      callIdController.value = TextEditingValue(
        text: callId,
        selection: TextSelection.collapsed(offset: callId.length),
      );
    }
  }
}
