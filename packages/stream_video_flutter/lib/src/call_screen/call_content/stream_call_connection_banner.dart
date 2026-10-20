import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// Says what the call's connection is doing while it is not simply connected.
///
/// Pinned rather than timed, for as long as the call is getting its
/// connection back: waiting for the network, backing off between attempts,
/// joining again, or moving to another SFU. It follows the reconnect through
/// each phase, so a fast reconnect that escalates to a rejoin reads as one
/// banner changing its text, not as one going away and another arriving.
///
/// Says nothing while the call is connected, so it can stay in the tree.
class StreamCallConnectionBanner extends StatelessWidget {
  /// Creates a banner for [call].
  const StreamCallConnectionBanner({super.key, required this.call});

  /// The call whose connection the banner reports.
  final Call call;

  @override
  Widget build(BuildContext context) {
    return PartialCallStateBuilder(
      call: call,
      selector: (state) => state.status,
      builder: (context, status) {
        final notice = _CallConnectionNotice.of(status);

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              alignment: Alignment.topCenter,
              child: child,
            ),
          ),
          child: switch (notice) {
            // A new key per notice, so a change of text cross-fades instead of
            // snapping; the same notice rebuilt keeps its spinner turning.
            final notice? => Padding(
              key: ValueKey(notice),
              padding: EdgeInsets.all(context.streamSpacing.sm),
              child: StreamSnackbar(
                message: Text(notice.message),
                variant: notice.variant,
              ),
            ),
            null => const SizedBox.shrink(),
          },
        );
      },
    );
  }
}

/// What the banner says about one status.
@immutable
class _CallConnectionNotice {
  const _CallConnectionNotice(this.message, this.variant);

  /// The notice for [status], or null when there is nothing to say.
  static _CallConnectionNotice? of(CallStatus status) {
    return switch (status) {
      CallStatusReconnecting(phase: CallReconnectPhase.offline) =>
        const _CallConnectionNotice(
          "You're offline. Waiting for the network…",
          StreamSnackbarVariant.error,
        ),
      CallStatusReconnecting(:final phase, :final attempt) =>
        _CallConnectionNotice(
          _withAttempt(
            phase == CallReconnectPhase.joining ? 'Joining' : 'Reconnecting',
            attempt,
          ),
          StreamSnackbarVariant.loading,
        ),
      CallStatusMigrating() => const _CallConnectionNotice(
        'Moving to another server…',
        StreamSnackbarVariant.loading,
      ),
      // Reached only before the first join lands.
      CallStatusConnecting() => const _CallConnectionNotice(
        'Connecting…',
        StreamSnackbarVariant.loading,
      ),
      _ => null,
    };
  }

  /// Names the attempt once there has been more than one, which is when it
  /// starts to mean something.
  static String _withAttempt(String label, int attempt) {
    return attempt > 1 ? '$label… (attempt $attempt)' : '$label…';
  }

  final String message;
  final StreamSnackbarVariant variant;

  @override
  bool operator ==(Object other) =>
      other is _CallConnectionNotice &&
      other.message == message &&
      other.variant == variant;

  @override
  int get hashCode => Object.hash(message, variant);
}
