import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'expense.dart';  // Make sure this model is defined in your project

class ExpenseProvider with ChangeNotifier {
  final List<Expense> _expenses = [];
  double _monthlyBudget = 2400.0;  // Default budget, can be changed

  List<Expense> get expenses => _expenses;

  double get monthlyBudget => _monthlyBudget;
  
  get weeklyExpenses => null;
  set monthlyBudget(double value) {
    _monthlyBudget = value;
    notifyListeners();
  }

  double totalSpentThisWeek() {
    DateTime now = DateTime.now();
    int weekday = now.weekday;
    DateTime startOfWeek = now.subtract(Duration(days: weekday - 1));
    return _expenses.where((expense) => expense.date.isAfter(startOfWeek)).fold(0.0, (sum, expense) => sum + expense.amount);
  }

  double spentThisMonth() {
    DateTime now = DateTime.now();
    return _expenses.where((expense) => expense.date.month == now.month && expense.date.year == now.year).fold(0.0, (sum, expense) => sum + expense.amount);
  }

  double spentPercentage() {
    return (monthlyBudget > 0) ? spentThisMonth() / monthlyBudget : 0;
  }

  bool isThisWeek(DateTime date) {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
    return date.isAfter(startOfWeek) && date.isBefore(endOfWeek);
  }

  // Calculating daily expenses for each day of the current week
  Map<String, double> calculateDailyExpenses() {
    Map<String, double> dailyExpenses = {};
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    startOfWeek.add(const Duration(days: 6));
    
    for (var i = 0; i < 7; i++) {
      DateTime day = startOfWeek.add(Duration(days: i));
      double total = _expenses.where((expense) => 
          expense.date.year == day.year &&
          expense.date.month == day.month &&
          expense.date.day == day.day).fold(0.0, (sum, exp) => sum + exp.amount);
      dailyExpenses[DateFormat('EEEE').format(day)] = total;
    }
    return dailyExpenses;
  }

  List<BarChartGroupData> getWeeklyBarGroups() {
    Map<String, double> dailyExpenses = calculateDailyExpenses();
    return dailyExpenses.keys.toList().asMap().entries.map((entry) {
      int idx = entry.key;
      double total = double.parse(entry.value);
      return BarChartGroupData(
        x: idx,
        barRods: [BarChartRodData(toY: total, color: Colors.blueAccent)],
      );
    }).toList();
  }

  void calculateWeeklyExpenses() {
  DateTime now = DateTime.now();
  int weekday = now.weekday;

  // Start from the beginning of the week (assuming Monday is the first day)
  DateTime startOfWeek = now.subtract(Duration(days: weekday - 1));

  // Reset weeklyExpenses to 0 for each day
  List<double> _weeklyExpenses = List<double>.filled(7, 0.0);

  for (var expense in _expenses) {
    if (expense.date.isAfter(startOfWeek) || (expense.date.year == startOfWeek.year &&
        expense.date.month == startOfWeek.month &&
        expense.date.day == startOfWeek.day)) {

      int dayDifference = expense.date.difference(startOfWeek).inDays;

      if (dayDifference >= 0 && dayDifference < 7) {
        _weeklyExpenses[dayDifference] += expense.amount;
      }
    }
  }

  notifyListeners();
}


  void addExpense(Expense expense) {
    _expenses.add(expense);
    calculateWeeklyExpenses();
    notifyListeners();
  }

  void editMonthlyBudget(double newBudget) {
    monthlyBudget = newBudget;
    notifyListeners();
  }

  getMaxExpense() {}
}
