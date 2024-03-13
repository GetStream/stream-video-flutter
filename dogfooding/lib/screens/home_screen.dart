// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/core/repos/app_preferences.dart';
// 🌎 Project imports:
import 'package:flutter_dogfooding/router/routes.dart';
import 'package:flutter_dogfooding/theme/app_palette.dart';
import 'package:flutter_dogfooding/widgets/environment_switcher.dart';
import 'package:flutter_dogfooding/widgets/stream_button.dart';
// 📦 Package imports:
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter_background.dart';

import '../app/user_auth_controller.dart';
import '../di/injector.dart';
import '../utils/assets.dart';
import '../utils/consts.dart';
import '../utils/loading_dialog.dart';

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

  Call? _call;

  @override
  void initState() {
    StreamBackgroundService.init(
      StreamVideo.instance,
      onButtonClick: (call, type, serviceType) async {
        switch (serviceType) {
          case ServiceType.call:
            call.end();
          case ServiceType.screenSharing:
            StreamVideoFlutterBackground.stopService(ServiceType.screenSharing);
            call.setScreenShareEnabled(enabled: false);
        }
      },
    );
    super.initState();
  }

  Future<void> _getOrCreateCall({List<String> memberIds = const []}) async {
    var callId = _callIdController.text;
    if (callId.isEmpty) callId = generateAlphanumericString(12);

    unawaited(showLoadingIndicator(context));
    _call = _streamVideo.makeCall(callType: kCallType, id: callId);

    bool isRinging = memberIds.isNotEmpty;

    try {
      await _call!.getOrCreate(
        memberIds: memberIds,
        ringing: isRinging,
      );
    } catch (e, stk) {
      debugPrint('Error joining or creating call: $e');
      debugPrint(stk.toString());
    }

    if (mounted) {
      hideLoadingIndicator(context);

      if (isRinging) {
        CallRoute($extra: (
          call: _call!,
          connectOptions: const CallConnectOptions(),
        )).push(context);
      } else {
        LobbyRoute($extra: _call!).push(context);
      }
    }
  }

  Future<void> _directCall(BuildContext context) async {
    TextEditingController controller = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Enter the ID of the user you want to call',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(hintText: "User ID"),
                ),
                const SizedBox(
                  height: 16,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 150,
                    child: StreamButton.active(
                      label: 'Call',
                      icon: const Icon(Icons.video_camera_front,
                          color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _getOrCreateCall(memberIds: [controller.text]);
                      },
                    ),
                  ),
                )
              ],
            ),
          );
        });
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
    final name = currentUser!.name;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: StreamUserAvatar(user: currentUser),
        ),
        titleSpacing: 4,
        centerTitle: false,
        title: Text(
          name,
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: EnvironmentBanner(
                    currentEnvironment: _appPreferences.environment),
              ),
              IconButton(
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: _userAuthController.logout,
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Hero(
                tag: 'stream_logo',
                child: Image.asset(
                  streamVideoIconAsset,
                  width: size.width * 0.6,
                ),
              ),
              const SizedBox(height: 24),
              Text('Stream', style: theme.textTheme.headlineMedium),
              Text(
                '[Video Calling]',
                style: theme.textTheme.headlineMedium?.apply(
                  color: AppColorPalette.appGreen,
                ),
              ),
              const SizedBox(height: 48),
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
    );
  }
}

class _JoinForm extends StatelessWidget {
  const _JoinForm({
    required this.callIdController,
    required this.onJoinPressed,
  });

  final TextEditingController callIdController;
  final VoidCallback onJoinPressed;

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
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColorPalette.secondaryText,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(36)),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(36)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  isDense: true,
                  hintText: 'Enter call id',
                  // suffix button to generate a random call id
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.refresh),
                    color: Colors.white,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      // generate a 10 character nanoId for call id
                      final callId = generateAlphanumericString(10);
                      callIdController.value = TextEditingValue(
                        text: callId,
                        selection: TextSelection.collapsed(
                          offset: callId.length,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ValueListenableBuilder(
              valueListenable: callIdController,
              builder: (context, value, __) {
                final hasText = value.text.isNotEmpty;
                return StreamButton.active(
                    label: 'Join call',
                    icon: const Icon(Icons.login, color: Colors.white),
                    onPressed: hasText ? onJoinPressed : () {});
              },
            ),
          ],
        ),
      ],
    );
  }
}
