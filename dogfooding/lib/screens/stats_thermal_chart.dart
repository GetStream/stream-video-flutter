import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../theme/app_palette.dart';

class StatsThermalChart extends StatelessWidget {
  const StatsThermalChart({super.key, required this.thermalSeverityHistory});

  /// Severity scale expected in ascending order (0 = none ... N = most severe).
  final List<int> thermalSeverityHistory;

  static const int _maxSeverity =
      6; // none, light, moderate, severe, critical, emergency, shutdown

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.start,
          barTouchData: const BarTouchData(enabled: false),
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) => const FlLine(
              color: Color(0xff37434d),
              strokeWidth: 1,
            ),
          ),
          titlesData: const FlTitlesData(
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 1,
              ),
            ),
            topTitles: AxisTitles(),
            bottomTitles: AxisTitles(),
            leftTitles: AxisTitles(),
          ),
          borderData: FlBorderData(show: false),
          minY: 0,
          maxY: _maxSeverity.toDouble() + 1,
          barGroups: thermalSeverityHistory.indexed
              .map(
                (entry) => BarChartGroupData(
                  x: entry.$1,
                  barRods: [
                    BarChartRodData(
                      toY:
                          entry.$2
                              .toDouble()
                              .clamp(0, _maxSeverity)
                              .toDouble() +
                          1,
                      width: 10,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                      color: Color.lerp(
                        AppColorPalette.appGreen,
                        AppColorPalette.appRed,
                        (entry.$2.clamp(0, _maxSeverity)) / _maxSeverity,
                      ),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: _maxSeverity.toDouble(),
                        color: Colors.white.withValues(alpha: .04),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
