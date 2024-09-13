// expense_line_chart_widget.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseLineChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                switch (value.toInt()) {
                  case 0:
                    return const Text('Mon');
                  case 1:
                    return const Text('Tue');
                  case 2:
                    return const Text('Wed');
                  case 3:
                    return const Text('Thu');
                  case 4:
                    return const Text('Fri');
                  case 5:
                    return const Text('Sat');
                  case 6:
                    return const Text('Sun');
                }
                return const Text('');
              },
              interval: 1,  // Show titles for each day
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(0, 30),
              const FlSpot(1, 50),
              const FlSpot(2, 80),
              const FlSpot(3, 60),
              const FlSpot(4, 90),
              const FlSpot(5, 40),
              const FlSpot(6, 70),
            ],
            isCurved: true,
           color: Colors.blue,  // Use colors instead of color
            barWidth: 4,
            belowBarData: BarAreaData(
              show: true,
               color: Colors.lightBlue.withOpacity(0.4),  // Use colors instead of color
            ),
          ),
        ],
      ),
    );
  }
}
