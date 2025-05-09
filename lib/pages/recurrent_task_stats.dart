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

    return Scaffold(
      appBar: AppBar(title: Text('${task.title} Stats')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceBetween,
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, _) {
                    final index = value.toInt();
                    if (index < 0 || index >= records.length) {
                      return const SizedBox.shrink();
                    }
                    return Text(
                      formatter.format(records[index].startTime),
                      style: const TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, _) => Text(
                    useSeconds ? '${value.toInt()}s' : '${value.toInt()}m',
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ),
            barGroups: [
              for (int i = 0; i < records.length; i++)
                BarChartGroupData(x: i, barRods: [
                  BarChartRodData(
                    toY: useSeconds
                        ? records[i].duration.inSeconds.toDouble()
                        : records[i].duration.inMinutes.toDouble(),
                    width: 16,
                  ),
                ])
            ],
          ),
        ),
      ),
    );
  }
}
