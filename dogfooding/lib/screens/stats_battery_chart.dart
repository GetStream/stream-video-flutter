import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class StatsBatteryChart extends StatelessWidget {
  const StatsBatteryChart({super.key, required this.batteryLevelHistory});

  final List<int> batteryLevelHistory;

  @override
  Widget build(BuildContext context) {
    final colorScheme = StreamTheme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: LineChart(
        LineChartData(
          lineTouchData: const LineTouchData(enabled: false),
          gridData: FlGridData(
            drawVerticalLine: false,
            verticalInterval: 1,
            horizontalInterval: 20,
            getDrawingVerticalLine: (value) {
              return const FlLine(
                color: Color(0xff37434d),
                strokeWidth: 1,
              );
            },
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                color: Color(0xff37434d),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: const FlTitlesData(
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 20,
              ),
            ),
            topTitles: AxisTitles(),
            bottomTitles: AxisTitles(),
            leftTitles: AxisTitles(),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          minX: 0,
          maxX: 20,
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: batteryLevelHistory.indexed
                  .map<FlSpot>(
                    (m) => FlSpot(m.$1.toDouble(), m.$2.toDouble()),
                  )
                  .toList(),
              isCurved: true,
              gradient: LinearGradient(
                colors: [
                  ColorTween(
                    begin: colorScheme.accentSuccess,
                    // ignore: deprecated_member_use
                    end: colorScheme.accentSuccess.withOpacity(0.5),
                  ).lerp(0.2)!,
                  ColorTween(
                    begin: colorScheme.accentSuccess,
                    // ignore: deprecated_member_use
                    end: colorScheme.accentSuccess.withOpacity(0.5),
                  ).lerp(0.2)!,
                ],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    ColorTween(
                          begin: colorScheme.accentSuccess,
                          end:
                              // ignore: deprecated_member_use
                              colorScheme.accentSuccess.withOpacity(0.5),
                        )
                        .lerp(0.2)!
                        // ignore: deprecated_member_use
                        .withOpacity(0.1),
                    ColorTween(
                          begin: colorScheme.accentSuccess,
                          end:
                              // ignore: deprecated_member_use
                              colorScheme.accentSuccess.withOpacity(0.5),
                        )
                        .lerp(0.2)!
                        // ignore: deprecated_member_use
                        .withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
