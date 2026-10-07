import 'package:flutter/material.dart';
import 'package:stream_video/debug.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../di/injector.dart';
import '../../utils/simulated_internet_connection.dart';

/// How long each offline preset holds the network down, and what a call
/// should do about it.
///
/// The durations match `tools/simulate_network_loss.sh`, the results do not
/// quite: here the SFU socket drops at the start and the network monitor
/// reports the outage right away, so even a blip ends in a fast reconnect.
enum _Outage {
  /// A short outage: a fast reconnect once it ends.
  blip('blip', Duration(seconds: 2)),

  /// Inside the SFU's reconnect window: a fast reconnect resumes the session.
  fast('fast', Duration(seconds: 6)),

  /// Past the fast reconnect deadline and the SFU's reconnect window: the call
  /// rejoins.
  rejoin('rejoin', Duration(seconds: 25)),

  /// Past the network availability timeout: the call gives up and leaves.
  giveUp('give up', null);

  const _Outage(this.label, this.duration);

  final String label;

  /// Null for [giveUp], which depends on the call's preferences.
  final Duration? duration;

  Duration durationFor(Call call) =>
      duration ??
      call.state.value.preferences.networkAvailabilityTimeout +
          const Duration(seconds: 10);
}

/// The more menu's section for triggering the call's reconnect paths by hand.
StreamMenuSection connectionFailureSection(BuildContext context, Call call) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  final network = locator.isRegistered<SimulatedInternetConnection>()
      ? locator<SimulatedInternetConnection>()
      : null;

  void simulate(String what, VoidCallback trigger) {
    trigger();
    messenger?.showSnackBar(SnackBar(content: Text('Simulated: $what')));
  }

  return StreamMenuSection(
    heading: 'Simulate connection failure',
    collapsible: true,
    options: [
      if (network != null)
        for (final outage in _Outage.values)
          StreamMenuOption(
            label:
                'Offline: ${outage.label} '
                '(${outage.durationFor(call).inSeconds} s)',
            onSelected: () {
              final duration = outage.durationFor(call);
              simulate('offline for ${duration.inSeconds} s', () {
                // Offline first, so the reconnect the dropped socket asks
                // for waits for the network to come back.
                network.goOffline(duration);
                call.debugDropSfuSocket();
              });
            },
          ),
      StreamMenuOption(
        label: 'SFU socket drop',
        onSelected: () => simulate('SFU socket drop', call.debugDropSfuSocket),
      ),
      StreamMenuOption(
        label: 'Publisher connection failed',
        onSelected: () => simulate(
          'publisher connection failed',
          () => call.debugFailPeerConnection(StreamPeerType.publisher),
        ),
      ),
      StreamMenuOption(
        label: 'Subscriber connection failed',
        onSelected: () => simulate(
          'subscriber connection failed',
          () => call.debugFailPeerConnection(StreamPeerType.subscriber),
        ),
      ),
      StreamMenuOption(
        label: 'SFU GoAway',
        onSelected: () => simulate('SFU GoAway', call.debugReceiveGoAway),
      ),
      for (final strategy in [
        SfuReconnectionStrategy.fast,
        SfuReconnectionStrategy.rejoin,
      ])
        StreamMenuOption(
          label: 'SFU error: ${strategy.name}',
          onSelected: () => simulate(
            'SFU error naming ${strategy.name}',
            () => call.debugReceiveSfuError(strategy),
          ),
        ),
    ],
  );
}
