import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app/user_auth_controller.dart';
import '../di/injector.dart';
import 'stats_battery_chart.dart';
import 'stats_latency_chart.dart';
import 'stats_thermal_chart.dart';

/// The call's live statistics, as the body of a side panel.
class CallStatsPanelBody extends StatelessWidget {
  /// Creates a stats body for [call].
  const CallStatsPanelBody({super.key, required this.call});

  /// The call whose statistics are reported.
  final Call call;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final currentUser = locator.get<UserAuthController>().currentUser;

    return StreamBuilder<CallMetrics?>(
      stream: call.statsReporter?.stream,
      initialData: call.statsReporter?.currentMetrics,
      builder: (context, snapshot) {
        final state = snapshot.data;

        if (state == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final subscriberBitrate = state.subscriber?.bitrateKbps;
        final publisherBitrate = state.publisher?.bitrateKbps;

        final batteryDrained =
            state.initialBatteryLevel != null &&
                state.batteryLevelHistory.isNotEmpty
            ? state.initialBatteryLevel! - state.batteryLevelHistory.last
            : null;

        return SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                // No avatar rather than a crash if the session has gone.
                leading: currentUser == null
                    ? null
                    : StreamUserAvatar(user: currentUser),
                title: Text(
                  'Call ID',
                  style: TextStyle(color: colorScheme.textPrimary),
                ),
                subtitle: Text(
                  call.callCid.value,
                  style: TextStyle(color: colorScheme.textPrimary),
                ),
              ),
              _StatsSection(
                icon: Icons.network_check,
                title: 'Call latency',
                description:
                    'Very high latency values may reduce call quality, cause lag, and make the call less enjoyable.',
                chart: StatsLatencyChart(latencyHistory: state.latencyHistory),
              ),
              const SizedBox(height: 16),
              _StatsSection(
                icon: Icons.whatshot,
                title: 'Thermal state',
                description:
                    'Device thermal state history. Higher bars indicate more severe states.',
                chart: StatsThermalChart(
                  thermalSeverityHistory: state.thermalStatusHistory,
                ),
              ),
              const SizedBox(height: 16),
              _StatsSection(
                icon: Icons.battery_full,
                title: 'Battery level',
                description: 'Track device battery level throughout the call.',
                chart: StatsBatteryChart(
                  batteryLevelHistory: state.batteryLevelHistory,
                ),
                footer: Text(
                  'Battery percentage consumed during call: ${batteryDrained != null ? "$batteryDrained%" : "N/A"}',
                  style: TextStyle(color: colorScheme.textPrimary),
                ),
              ),
              const SizedBox(height: 16),
              const _StatsSection(
                icon: Icons.bar_chart,
                title: 'Call performance',
                description:
                    'Review the key data points below to assess call performance.',
              ),
              const SizedBox(height: 16),
              LatencyOrJitterItem(
                title: 'Latency',
                value: state.publisher?.latency ?? 0,
              ),
              Row(
                children: [
                  Expanded(
                    child: LatencyOrJitterItem(
                      title: 'Receive jitter',
                      value: state.subscriber?.jitterInMs,
                    ),
                  ),
                  Expanded(
                    child: LatencyOrJitterItem(
                      title: 'Publish jitter',
                      value: state.publisher?.jitterInMs,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: StatsItem(
                      title: 'Publish bitrate',
                      value: publisherBitrate == null
                          ? '--'
                          : '$publisherBitrate Kbps',
                    ),
                  ),
                  Expanded(
                    child: StatsItem(
                      title: 'Receive bitrate',
                      value: subscriberBitrate == null
                          ? '--'
                          : '$subscriberBitrate Kbps',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: StatsItem(
                      title: 'Publish resolution',
                      value:
                          "${state.publisher?.resolution} | ${state.publisher?.videoCodec?.join('+')}",
                    ),
                  ),
                  Expanded(
                    child: StatsItem(
                      title: 'Receive resolution',
                      value:
                          "${state.subscriber?.resolution} | ${state.subscriber?.videoCodec?.join('+')}",
                    ),
                  ),
                ],
              ),
              StatsItem(
                title: 'Region',
                value: state.clientEnvironment.sfu,
              ),
              StatsItem(
                title: 'SDK Version',
                value: state.clientEnvironment.sdkVersion,
              ),
              StatsItem(
                title: 'WebRTC Version',
                value: state.clientEnvironment.webRtcVersion,
              ),
            ],
          ),
        );
      },
    );
  }
}

class LatencyOrJitterItem extends StatelessWidget {
  const LatencyOrJitterItem({
    super.key,
    required this.value,
    required this.title,
  });

  final String title;
  final int? value;

  @override
  Widget build(BuildContext context) {
    return StatsItem(
      title: title,
      value: value == null ? '--' : '$value ms',
      trailing: StatIndicator(value: value),
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
    final colorScheme = context.streamColorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: colorScheme.backgroundSurface,
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
                    color: colorScheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(value ?? '', style: theme.textTheme.title3),
              ],
            ),
          ),
          if (trailing case final trailing?) trailing,
        ],
      ),
    );
  }
}

class StatIndicator extends StatelessWidget {
  const StatIndicator({
    super.key,
    required this.value,
    this.okMin = 75,
    this.okMax = 100,
  });

  final int? value;

  /// Below this the reading is good; above [okMax] it is bad. Between the two
  /// it is merely acceptable.
  final int okMin;
  final int okMax;

  (Color color, String text)? getIndicatorData() => switch (value) {
    null => null,
    final value when value < okMin => (const Color(0xFF00E2A1), 'Good'),
    final value when value <= okMax => (const Color(0xFFFFD646), 'Ok'),
    _ => (const Color(0xFFDC433B), 'Bad'),
  };

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
        // ignore: deprecated_member_use
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

/// One titled block of the stats panel: a heading, a line about what it
/// shows, and optionally a chart under it.
class _StatsSection extends StatelessWidget {
  const _StatsSection({
    required this.icon,
    required this.title,
    required this.description,
    this.chart,
    this.footer,
  });

  final IconData icon;
  final String title;

  /// What the section is for, under the heading.
  final String description;

  /// Charted history, given a fixed height so every section's is the same.
  final Widget? chart;

  /// A closing line below [chart], for a section that summarises itself.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final textTheme = StreamVideoTheme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: colorScheme.textPrimary),
              const SizedBox(width: 8),
              Text(
                title,
                style: textTheme.title3.apply(color: colorScheme.textPrimary),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            description,
            style: TextStyle(color: colorScheme.textPrimary),
          ),
        ),
        if (chart case final chart?) ...[
          const SizedBox(height: 16),
          SizedBox(height: 200, child: chart),
        ],
        if (footer case final footer?) footer,
      ],
    );
  }
}
