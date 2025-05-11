import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/recurrent_task.dart';
import 'package:intl/intl.dart';

class RecurrentTaskStatsPage extends StatelessWidget {
  final RecurrentTask task;

  const RecurrentTaskStatsPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final records = task.records;
    final formatter = DateFormat('MMM d, HH:mm');

    if (records.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('${task.title} Stats')),
        body: const Center(child: Text('No records yet.')),
      );
    }

    final maxSeconds = records
        .map((r) => r.duration.inSeconds)
        .reduce((a, b) => a > b ? a : b);
    final useSeconds = maxSeconds < 60;

    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;
    final labelStyle = TextStyle(fontSize: isSmallScreen ? 10 : 12);

    return Scaffold(
      appBar: AppBar(title: Text('${task.title} Stats')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: AspectRatio(
                aspectRatio: isSmallScreen ? 1 : 1.5,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceBetween,
                    barGroups: List.generate(records.length, (i) {
                      final r = records[i];
                      return BarChartGroupData(x: i, barRods: [
                        BarChartRodData(
                          toY: r.duration.inSeconds.toDouble(),
                          width: isSmallScreen ? 12 : 18,
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(4),
                        )
                      ]);
                    }),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (double value, _) {
                            final index = value.toInt();
                            if (index < 0 || index >= records.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                formatter.format(records[index].startTime),
                                style: labelStyle,
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            final intVal = value.toInt();
                            return Text(
                              useSeconds
                                  ? '$intVal s'
                                  : '${(intVal / 60).toStringAsFixed(0)} m',
                              style: labelStyle,
                            );
                          },
                          reservedSize: 40,
                        ),
                      ),
                      topTitles:
                          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: const FlGridData(show: true),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}