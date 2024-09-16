import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ExpenseLineChartWidget extends StatelessWidget {
  // Accept daily expenses as a parameter (e.g., a list of expenses for each day)
  final List<double> dailyExpenses;

  const ExpenseLineChartWidget({super.key, required this.dailyExpenses});

  @override
  Widget build(BuildContext context) {
    // Get the maximum expense to dynamically adjust the y-axis max value
    double maxExpense = dailyExpenses.isNotEmpty ? dailyExpenses.reduce((a, b) => a > b ? a : b) : 100;

    // Define a list of colors for each day of the week
    final List<Color> dayColors = [
      Colors.blue,    // Monday
      Colors.green,   // Tuesday
      Colors.orange,  // Wednesday
      Colors.red,     // Thursday
      Colors.purple,  // Friday
      Colors.yellow,  // Saturday
      Colors.cyan,    // Sunday
    ];
String formatCurrency(double value) {
  final formatter = NumberFormat.currency(symbol: 'FCFA', decimalDigits: 2);
  return formatter.format(value);
}
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,  // Make the chart scrollable horizontally
      child: SizedBox(
        width: dailyExpenses.length * 100.0, // Set a dynamic width for scrolling
        child: LineChart(
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
            minY: 0,
            maxY: maxExpense * 1.2,  // Scale Y-axis dynamically based on maximum expense
            lineBarsData: [
              LineChartBarData(
                spots: dailyExpenses.asMap().entries.map((entry) {
                  int index = entry.key;
                  double value = entry.value;
                  return FlSpot(index.toDouble(), value);  // Use dynamic data for the chart spots
                }).toList(),
                isCurved: true,
                color: Colors.blue,  // Default color for line (can be customized)
                barWidth: 4 + (maxExpense / 50), // Increase the bar width based on max expense
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.lightBlue.withOpacity(0.4),  // Area color
                ),
                dotData: FlDotData(
                  show: true,
                  checkToShowDot: (spot, barData) {
                    return true;  // Show dots at each data point
                  },
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: dayColors[index % dayColors.length],  // Use different color for each day
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
