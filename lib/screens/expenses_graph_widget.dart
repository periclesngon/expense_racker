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
    final totalSpentThisWeek = expenseProvider.spentThisWeek(); // Ensure non-null
    const percentageChange = 12; // Mock percentage increase (you can calculate this)

    // Define a list of colors for the bars
    final List<Color> barColors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.yellow,
      Colors.cyan
    ];

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
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.category, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text(
                    'F CFA${totalSpentThisWeek.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
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
          const SizedBox(height: 0),

          // Scrollable and Bar Chart without interactivity
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 1.2,
                ),
                child: AspectRatio(
                  aspectRatio: 1.7,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceBetween,
                      maxY: expenseProvider.getMaxExpense() * 1.1,
                      barTouchData: BarTouchData(enabled: false),  // Disable interaction
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: expenseProvider.getYAxisInterval(),
                            reservedSize: 50,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 10, color: Colors.black54),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50,
                            getTitlesWidget: (value, meta) {
                              final labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                  labels[value.toInt()],
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: false),
                      barGroups: expenseProvider.getWeeklyBarGroups().asMap().entries.map((entry) {
                        int index = entry.key;
                        var group = entry.value;

                        Color barColor = barColors[index % barColors.length];

                        return BarChartGroupData(
                          x: group.x,
                          barRods: group.barRods.map((rod) {
                            return BarChartRodData(
                              toY: rod.toY,
                              width: 14,
                              color: barColor,
                              borderRadius: BorderRadius.circular(6),
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to get the day label based on index
  String getDayLabel(int index) {
    switch (index) {
      case 0:
        return 'Monday';
      case 1:
        return 'Tuesday';
      case 2:
        return 'Wednesday';
      case 3:
        return 'Thursday';
      case 4:
        return 'Friday';
      case 5:
        return 'Saturday';
      case 6:
        return 'Sunday';
      default:
        return 'Unknown';
    }
  }

  String formatCurrency(double value) {
    return 'F CFA${value.toStringAsFixed(2)}';
  }
}
