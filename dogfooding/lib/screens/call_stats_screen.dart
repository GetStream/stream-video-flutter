import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/app/user_auth_controller.dart';
import 'package:flutter_dogfooding/di/injector.dart';
import 'package:flutter_dogfooding/screens/stats_latency_chart.dart';
import 'package:flutter_dogfooding/theme/app_palette.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class CallStatsScreen extends StatelessWidget {
  CallStatsScreen({
    super.key,
    required this.call,
  });

  final Call call;

  final _userAuthController = locator.get<UserAuthController>();

  @override
  Widget build(BuildContext context) {
    final streamVideoTheme = StreamVideoTheme.of(context);
    final textTheme = streamVideoTheme.textTheme;
    final currentUser = _userAuthController.currentUser;

    return StreamBuilder<CallState>(
        stream: call.state.asStream(),
        builder: (context, snapshot) {
          final state = snapshot.data;
          final subscriberBitrate = state?.subscriberStats?.bitrateKbps;
          final publisherBitrate = state?.publisherStats?.bitrateKbps;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Stats',
                style: textTheme.title3.apply(color: Colors.white),
              ),
              centerTitle: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    leading: StreamUserAvatar(user: currentUser!),
                    title: const Text(
                      'Call ID',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      call.callCid.value,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  if (snapshot.hasData) ...[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.network_check, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Call latency',
                            style: textTheme.title3.apply(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Very high latency values may reduce call quality, cause lag, and make the call less enjoyable.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 200,
                      child: StatsLatencyChart(
                        latencyHistory: state!.latencyHistory,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.bar_chart, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Call performance',
                            style: textTheme.title3.apply(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Review the key data points below to assess call performance.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    LatencyOrJitterItem(
                      title: 'Latency',
                      value: state.publisherStats?.latency ?? 0,
                    ),
                    LatencyOrJitterItem(
                      title: 'Receive jitter',
                      value: state.subscriberStats?.jitterInMs,
                    ),
                    LatencyOrJitterItem(
                      title: 'Publish jitter',
                      value: state.publisherStats?.jitterInMs,
                    ),
                    StatsItem(
                      title: 'Region',
                      value: state.localStats?.sfu,
                    ),
                    StatsItem(
                      title: 'SDK Version',
                      value: state.localStats?.sdkVersion,
                    ),
                    StatsItem(
                      title: 'WebRTC Version',
                      value: state.localStats?.webRtcVersion,
                    ),
                    StatsItem(
                      title: 'Publish bitrate',
                      value: publisherBitrate == null
                          ? '--'
                          : '${state.publisherStats?.bitrateKbps} Kbps',
                    ),
                    StatsItem(
                      title: 'Receive bitrate',
                      value: subscriberBitrate == null
                          ? '--'
                          : '${state.subscriberStats?.bitrateKbps} Kbps',
                    ),
                  ]
                ],
              ),
            ),
          );
        });
  }
}

class LatencyOrJitterItem extends StatelessWidget {
  const LatencyOrJitterItem({
    super.key,
    required this.value,
    required this.title,
    this.okRange,
  });

  final String title;
  final int? value;
  final List<int>? okRange;

  @override
  Widget build(BuildContext context) {
    return StatsItem(
      title: title,
      value: value == null ? '--' : '$value ms',
      trailing: StatIndicator(
        value: value,
        okRange: okRange ?? [for (var i = 75; i <= 100; i++) i],
      ),
    );
  }
}

class StatsItem extends StatelessWidget {
  const StatsItem({
    super.key,
    required this.value,
    required this.title,
    this.trailing,
  });

  final String title;
  final String? value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColorPalette.buttonSecondary,
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.footnote.apply(
                    color: AppColorPalette.secondaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value ?? '',
                  style: theme.textTheme.title3,
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const Spacer(),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class StatIndicator extends StatelessWidget {
  const StatIndicator({
    super.key,
    required this.value,
    required this.okRange,
  });

  final int? value;
  final List<int> okRange;

  (Color color, String text)? getIndicatorData() {
    if (value == null) {
      return null;
    } else if (okRange.contains(value)) {
      return (const Color(0xFFFFD646), "Ok");
    } else if (okRange.first > value!) {
      return (const Color(0xFF00E2A1), "Good");
    } else {
      return (const Color(0xFFDC433B), "Bad");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);
    final indicatorData = getIndicatorData();

    if (indicatorData == null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: indicatorData.$1.withOpacity(0.16),
      ),
      padding: const EdgeInsets.all(8),
      child: Text(
        indicatorData.$2,
        style: theme.textTheme.footnote.apply(color: indicatorData.$1),
      ),
    );
  }
}
