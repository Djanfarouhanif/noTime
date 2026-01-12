import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/models/daily_progress.dart';

class ProgressChart extends StatelessWidget {
  final List<DailyProgress> history;

  const ProgressChart({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    // Sort history by date
    history.sort((a, b) => a.date.compareTo(b.date));

    // Simple 7 day view logic for MVP
    // We want to show the last 7 days ending today.
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Map data to spots
    List<FlSpot> spots = [];
    double maxY = 240; // 4 hours default max

    for (int i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));

      // Find progress for this date
      final progress = history.firstWhere(
        (p) =>
          p.date.year == date.year &&
          p.date.month == date.month &&
          p.date.day == date.day,
        orElse: () => DailyProgress(goalId: '', date: date, declaredMinutes: 0),
      );

      spots.add(FlSpot((6-i).toDouble(), progress.declaredMinutes.toDouble()));
      if (progress.declaredMinutes > maxY) maxY = progress.declaredMinutes.toDouble();
    }

    return AspectRatio(
      aspectRatio: 1.70,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 24,
          bottom: 12,
        ),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 60,
              getDrawingHorizontalLine: (value) {
                return const FlLine(
                  color: Colors.white10,
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    // Show day names (M, T, W...)
                    final date = today.subtract(Duration(days: 6 - value.toInt()));
                    // Simple day letter
                    const days = ['M','T','W','T','F','S','S'];
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(days[date.weekday - 1]),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 60, // 1 hour
                  getTitlesWidget: (value, meta) {
                    return Text('${value.toInt()~/60}h');
                  },
                  reservedSize: 42,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            minX: 0,
            maxX: 6,
            minY: 0,
            maxY: maxY * 1.2,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.tertiary,
                  ],
                ),
                barWidth: 5,
                isStrokeCapRound: true,
                dotData: const FlDotData(
                  show: false, // Cleaner look
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      Theme.of(context).colorScheme.tertiary.withOpacity(0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
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
