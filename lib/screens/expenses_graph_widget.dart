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
          // Scrollable content to handle overflow
          Expanded(
            child: SingleChildScrollView(
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

                  // Bar chart for weekly expenses with interactivity
                  AspectRatio(
                    aspectRatio: 1.7,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: expenseProvider.getMaxExpense() * 1.2, // Dynamically scale Y-axis
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.blueAccent, // Set the background color
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final day = getDayLabel(group.x.toInt());
                              return BarTooltipItem(
                                '$day\n',
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: '\$${rod.toY.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.yellow,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          touchCallback: (FlTouchEvent event, BarTouchResponse? touchResponse) {
                            if (!event.isInterestedForInteractions || touchResponse == null || touchResponse.spot == null) {
                              return;
                            }

                            // Get the index of the touched bar
                            final touchedIndex = touchResponse.spot!.touchedBarGroupIndex;
                            final day = getDayLabel(touchedIndex);

                            // Display a SnackBar with more information about the touched bar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Touched bar on $day: \$${touchResponse.spot!.touchedRodData.y.toStringAsFixed(2)} spent',
                                ),
                              ),
                            );
                          },
                        ),
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
                                final labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                return Text(
                                  labels[value.toInt()],
                                  style: const TextStyle(color: Colors.black54),
                                );
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
}

extension on BarChartRodData {
  get y => null;
}
