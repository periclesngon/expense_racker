// expense_graph_widget.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../screens/expense_provider.dart'; // Import your provider

class ExpenseGraphWidget extends StatelessWidget {
  const ExpenseGraphWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceEvenly,
        maxY: expenseProvider.getMaxExpense(),  // Set max Y axis value based on highest expense
        barGroups: expenseProvider.getWeeklyBarGroups(), // Get bar groups from provider
        titlesData: FlTitlesData(
          leftTitles:  AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        interval: 20, // Set the interval for the left titles (Y-axis)
        getTitlesWidget: (double value, TitleMeta meta) {
          return Text(value.toInt().toString(), style: const TextStyle(fontSize: 12));
        },
      ),
    ),
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
      ),
    ),
   ),
  ),
 );
 }
}
