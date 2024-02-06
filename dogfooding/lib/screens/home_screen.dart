// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:stream_video_flutter/stream_video_flutter.dart';

// 🌎 Project imports:
import 'package:flutter_dogfooding/router/routes.dart';
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
  late final _userAuthController = locator.get<UserAuthController>();
  late final _callIdController = TextEditingController();

  Call? _call;

  @override
  void initState() {
    StreamBackgroundService.init(
      StreamVideo.instance,
      onNotificationClick: (call) async {
        final extra = (
          call: call,
          connectOptions: const CallConnectOptions(),
        );

        CallRoute($extra: extra).push(context);
      },
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
    _call = _streamVideo.makeCall(type: kCallType, id: callId);

    try {
      await _call!.getOrCreate(
        memberIds: memberIds,
        ringing: memberIds.isNotEmpty,
      );
    } catch (e, stk) {
      debugPrint('Error joining or creating call: $e');
      debugPrint(stk.toString());
    }

    if (mounted) {
      hideLoadingIndicator(context);
      LobbyRoute($extra: _call!).push(context);
    }
  }

  Future<void> _directCall(BuildContext context) async {
    TextEditingController controller = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter ID of user you want to call'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(hintText: "User id"),
                ),
                const SizedBox(
                  height: 8,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      backgroundColor: const MaterialStatePropertyAll<Color>(
                        Color(0xFF005FFF),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _getOrCreateCall(memberIds: [controller.text]);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        'Call',
                        style: TextStyle(color: Colors.white),
                      ),
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
        title: Text(
          name,
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _userAuthController.logout,
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
                  width: size.width * 0.3,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Stream Video Calling',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Text(
                'Build reliable video calling, audio rooms, '
                'and live streaming with our easy-to-use '
                'SDKs and global edge network',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 36),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Call ID Number',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _JoinForm(
                callIdController: _callIdController,
                onJoinPressed: _getOrCreateCall,
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Don't have a call ID?",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  onPressed: _getOrCreateCall,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text('Start New Call'),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Want to directly call someone?",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  onPressed: () => _directCall(context),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text('Direct Call'),
                  ),
                ),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  isDense: true,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
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
                return ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    backgroundColor: const MaterialStatePropertyAll<Color>(
                      Color(0xFF005FFF),
                    ),
                  ),
                  onPressed: hasText ? onJoinPressed : null,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      'Join call',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
