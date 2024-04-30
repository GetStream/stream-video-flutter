import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_dogfooding/theme/app_palette.dart';

class StatsLatencyChart extends StatelessWidget {
  const StatsLatencyChart({super.key, required this.latencyHistory});

  final List<int> latencyHistory;

  @override
  Widget build(BuildContext context) {
    final sortedLatency = latencyHistory.toList()..sort();
    final maxLatency =
        max(100, ((sortedLatency.lastOrNull ?? 100) / 20).ceil() * 20);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LineChart(
        LineChartData(
          lineTouchData: const LineTouchData(enabled: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            drawHorizontalLine: true,
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
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: maxLatency / 5,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          minX: 0,
          maxX: 20,
          minY: 0,
          maxY: maxLatency.toDouble(),
          lineBarsData: [
            LineChartBarData(
              spots: latencyHistory.indexed
                  .map<FlSpot>(
                    (m) => FlSpot(m.$1.toDouble(), m.$2.toDouble()),
                  )
                  .toList(),
              isCurved: true,
              gradient: LinearGradient(
                colors: [
                  ColorTween(
                          begin: AppColorPalette.appGreen,
                          end: AppColorPalette.appGreen.withOpacity(0.5))
                      .lerp(0.2)!,
                  ColorTween(
                          begin: AppColorPalette.appGreen,
                          end: AppColorPalette.appGreen.withOpacity(0.5))
                      .lerp(0.2)!,
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
                            begin: AppColorPalette.appGreen,
                            end: AppColorPalette.appGreen.withOpacity(0.5))
                        .lerp(0.2)!
                        .withOpacity(0.1),
                    ColorTween(
                            begin: AppColorPalette.appGreen,
                            end: AppColorPalette.appGreen.withOpacity(0.5))
                        .lerp(0.2)!
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
