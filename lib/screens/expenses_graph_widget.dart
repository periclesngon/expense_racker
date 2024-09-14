import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../screens/expense_provider.dart'; // Import your provider

class ExpenseGraphWidget extends StatelessWidget {
  const ExpenseGraphWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    // Total spent this week
    final totalSpentThisWeek = expenseProvider.totalSpentThisWeek();
    const percentageChange = 12; // Mock percentage increase (you can calculate this)

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview section
          const Text(
            "Overview",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${totalSpentThisWeek.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const Text(
                '+ $percentageChange%',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Total spent this week",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),
          
          // Bar chart for weekly expenses
          AspectRatio(
            aspectRatio: 1.7,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: expenseProvider.getMaxExpense(), // Adjust max Y-axis based on highest expense
                barTouchData: BarTouchData(enabled: false), // Disable bar touch interactions
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 100, // Set appropriate interval for Y-axis labels
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        switch (value.toInt()) {
                          case 0:
                            return const Text('Mon', style: TextStyle(color: Colors.black54));
                          case 1:
                            return const Text('Tue', style: TextStyle(color: Colors.black54));
                          case 2:
                            return const Text('Wed', style: TextStyle(color: Colors.black54));
                          case 3:
                            return const Text('Thu', style: TextStyle(color: Colors.black54));
                          case 4:
                            return const Text('Fri', style: TextStyle(color: Colors.black54));
                          case 5:
                            return const Text('Sat', style: TextStyle(color: Colors.black26)); // Grey for unused days
                          case 6:
                            return const Text('Sun', style: TextStyle(color: Colors.black26)); // Grey for unused days
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false), // Remove the border for a clean look
                gridData: const FlGridData(show: false), // Remove the grid lines
                barGroups: expenseProvider.getWeeklyBarGroups(), // Bar data from provider
              ),
            ),
          ),
        ],
      ),
    );
  }
}
