import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// Takes a livestream the host is in from backstage to live and back.
///
/// Shows nothing to a user who may not update the call.
class LivestreamGoLiveButton extends StatefulWidget {
  const LivestreamGoLiveButton({super.key, required this.call});

  final Call call;

  @override
  State<LivestreamGoLiveButton> createState() => _LivestreamGoLiveButtonState();
}

class _LivestreamGoLiveButtonState extends State<LivestreamGoLiveButton> {
  var _busy = false;

  static ({bool isBackstage, bool canUpdate}) _data(CallState state) => (
    isBackstage: state.isBackstage,
    canUpdate: state.ownCapabilities.contains(CallPermission.updateCall),
  );

  Future<void> _toggle({required bool goLive}) async {
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.maybeOf(context);
    final result = goLive
        ? await widget.call.goLive()
        : await widget.call.stopLive();
    if (!mounted) return;
    setState(() => _busy = false);

    if (result case final Failure failure) {
      messenger?.showSnackBar(
        SnackBar(
          content: Text(
            "Couldn't ${goLive ? 'go live' : 'stop the livestream'}: "
            '${failure.videoError.message}',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PartialCallStateBuilder(
      call: widget.call,
      selector: _data,
      builder: (context, data) {
        if (!data.canUpdate) return const SizedBox.shrink();

        final goLive = data.isBackstage;
        return StreamButton(
          size: StreamButtonSize.small,
          style: goLive
              ? StreamButtonStyle.primary
              : StreamButtonStyle.secondary,
          onPressed: _busy ? null : () => unawaited(_toggle(goLive: goLive)),
          child: Text(goLive ? 'Go live' : 'Stop live'),
        );
      },
    );
  }
}
