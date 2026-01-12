import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/daily_progress.dart';

class ProgressChart extends StatelessWidget {
  // Map of Goal Title -> History
  final Map<String, List<DailyProgress>> allHistories;

  const ProgressChart({super.key, required this.allHistories});

  @override
  Widget build(BuildContext context) {
    // If empty, show placeholder
    if (allHistories.isEmpty) {
      return Center(
        child: Text(
          'No data yet',
          style: GoogleFonts.poppins(color: Colors.grey),
        ),
      );
    }

    // 7 Days Logic
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Prepare lines
    List<LineChartBarData> lines = [];
    double maxY = 60; // minimum scale

    // Colors palette
    final colors = [
      const Color(0xFF6B4EFF), // Purple
      const Color(0xFFFF6B6B), // Red/Pink
      const Color(0xFF4ECDC4), // Teal
      const Color(0xFFFFBE0B), // Yellow
      const Color(0xFF1A535C), // Dark Teal
    ];
    int colorIndex = 0;

    allHistories.forEach((goalTitle, history) {
      List<FlSpot> spots = [];

      for (int i = 6; i >= 0; i--) {
        final date = today.subtract(Duration(days: i));

        // Find progress
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

      lines.add(
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: colors[colorIndex % colors.length],
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          // Only show area for the first one to avoid mess, or none
          belowBarData: BarAreaData(show: false),
        ),
      );
      colorIndex++;
    });

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
              horizontalInterval: 60, // 1 hour lines
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey.withOpacity(0.1),
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
                    final date = today.subtract(Duration(days: 6 - value.toInt()));
                    const days = ['M','T','W','T','F','S','S'];
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        days[date.weekday - 1],
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 60, // 1 hour
                  getTitlesWidget: (value, meta) {
                    if (value == 0) return const SizedBox();
                    return Text(
                      '${value.toInt()~/60}h',
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    );
                  },
                  reservedSize: 32,
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: 6,
            minY: 0,
            maxY: maxY * 1.1,
            lineBarsData: lines,
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((LineBarSpot touchedSpot) {
                    // Find which goal this line belongs to
                    // This is tricky with Map iteration order but reliable if we constructed list in order
                    // Simply showing value for now
                    return LineTooltipItem(
                      '${touchedSpot.y.toInt()}m',
                      GoogleFonts.poppins(color: Colors.white),
                    );
                  }).toList();
                }
              ),
            ),
          ),
        ),
      ),
    );
  }
}
