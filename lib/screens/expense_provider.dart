// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'expense.dart'; // Ensure this model is defined in your project

class ExpenseProvider extends ChangeNotifier {
  double _income = 0.0;  // Tracks total income (deposits)
  double _spent = 0.0;   // Tracks total spent (expenses)
  List<Expense> _expenses = []; // Assuming you have an Expense model to track expenses

  double get income => _income;  // Getter for total income
  double get spent => _expenses.fold(0, (sum, item) => sum + item.amount);
  
    // Getter for total spent

  List<Expense> get expenses => _expenses; // Getter for the list of expenses

  // Deposit money to increase the incomePP
  void deposit(double amount) {
    if (amount > 0) {
      _income += amount;
      notifyListeners();
    }
  }
   bool withdraw(double amount) {
    if (_income - _spent >= amount) {  // Check if the user has enough balance
      _spent += amount;
      notifyListeners();
      return true;  // Withdrawal successful
    } else {
      return false; // Insufficient balance
    }
    }

  // Add an expense to increase the spent amount
  void addExpense(Expense expense) {
    if (expense.amount > 0) {
      _spent += expense.amount;
      _expenses.add(expense);
      notifyListeners();
    }
  }
double get Spent => _expenses.fold(0, (sum, item) => sum + item.amount);

  // Spent percentage of the monthly budget
  double spentPercentage(double monthlyBudget) {
    return (monthlyBudget > 0) ? _spent / monthlyBudget : 0.0;
  }

  // Spent this week
  double spentThisWeek() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Start of the current week (Monday)
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6)); // End of the current week (Sunday)

    return _expenses
        .where((expense) => expense.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) && expense.date.isBefore(endOfWeek.add(const Duration(days: 1))))
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  // Spent this month
  double spentThisMonth() {
    DateTime now = DateTime.now();
    return _expenses
        .where((expense) => expense.date.month == now.month && expense.date.year == now.year)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  // Get maximum expense
  double getMaxExpense() {
    if (_expenses.isEmpty) return 0.0;
    return _expenses.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
  }

  // Get Y-axis interval based on the maximum expense
  double getYAxisInterval() {
    final maxExpense = getMaxExpense();

    if (maxExpense <= 100) {
      return 10;
    } else if (maxExpense <= 500) {
      return 50;
    } else if (maxExpense <= 1000) {
      return 100;
    } else {
      return 200;
    }
  }

  // Calculate daily expenses for each day of the current week
  Map<String, double> calculateDailyExpenses() {
    Map<String, double> dailyExpenses = {};
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    for (var i = 0; i < 7; i++) {
      DateTime day = startOfWeek.add(Duration(days: i));
      double total = _expenses
          .where((expense) =>
              expense.date.year == day.year &&
              expense.date.month == day.month &&
              expense.date.day == day.day)
          .fold(0.0, (sum, exp) => sum + exp.amount);

      dailyExpenses[DateFormat('EEEE').format(day)] = total;
    }
    return dailyExpenses;
  }

  // Get bar groups for weekly bar chart
  List<BarChartGroupData> getWeeklyBarGroups() {
    Map<String, double> dailyExpenses = calculateDailyExpenses();

    final dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    return dayNames.asMap().entries.map((entry) {
      int index = entry.key;
      String dayName = entry.value;
      double totalExpense = dailyExpenses[dayName] ?? 0.0;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: totalExpense,
            color: Colors.blueAccent,
          ),
        ],
      );
    }).toList();
  }

  // Calculate weekly expenses for each day
  List<double> calculateWeeklyExpenses() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    List<double> weeklyExpenses = List<double>.filled(7, 0.0);

    for (var expense in _expenses) {
      if (isThisWeek(expense.date)) {
        int dayDifference = expense.date.difference(startOfWeek).inDays;
        if (dayDifference >= 0 && dayDifference < 7) {
          weeklyExpenses[dayDifference] += expense.amount;
        }
      }
    }
    return weeklyExpenses;
  }

  // Check if the date is within this week
  bool isThisWeek(DateTime date) {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
    return date.isAfter(startOfWeek) && date.isBefore(endOfWeek);
  }
}

// Widget to display line chart based on weekly expenses
class ExpenseLineChartWidget extends StatelessWidget {
  final List<double> weeklyExpenses;

  const ExpenseLineChartWidget({super.key, required this.weeklyExpenses});

  @override
  Widget build(BuildContext context) {
    double maxExpense = weeklyExpenses.isNotEmpty ? weeklyExpenses.reduce((a, b) => a > b ? a : b) : 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Daily Expense Overview",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),

        Column(
          children: weeklyExpenses.asMap().entries.map((entry) {
            int index = entry.key;
            double value = entry.value;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(getDayLabel(index)),
                Text('F CFA ${value.toStringAsFixed(2)}'),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        LineChart(
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
                  interval: 1,
                ),
              ),
            ),
            minY: 0,
            maxY: maxExpense * 1.2,
            lineBarsData: [
              LineChartBarData(
                spots: weeklyExpenses.asMap().entries.map((entry) {
                  int index = entry.key;
                  double value = entry.value;
                  return FlSpot(index.toDouble(), value);
                }).toList(),
                isCurved: true,
                color: Colors.blue,
                barWidth: 4,
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.lightBlue.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

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
        return '';
    }
  }
}
