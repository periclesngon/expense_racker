import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'expense_provider.dart';
import 'expense.dart'; // Assuming Expense model exists

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final weekExpenses = expenseProvider.calculateDailyExpenses();
    final monthlyExpenses = expenseProvider.expenses
        .where((expense) => expenseProvider.isThisWeek(expense.date))
        .toList();
    final todayExpenses = expenseProvider.expenses
        .where((expense) =>
            DateFormat.yMd().format(expense.date) ==
            DateFormat.yMd().format(DateTime.now()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Daily Transactions",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: todayExpenses.length,
                itemBuilder: (context, index) {
                  Expense expense = todayExpenses[index];
                  return TransactionTile(
                    day: DateFormat.jm().format(expense.date),
                    amount: expense.amount,
                    title: expense.title,
                    category: expense.category,
                    color: Colors.orangeAccent,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Weekly Transactions",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: weekExpenses.length,
                itemBuilder: (context, index) {
                  String day = weekExpenses.keys.toList()[index];
                  double amount = weekExpenses[day] ?? 0.0;
                  return TransactionTile(
                    day: day,
                    amount: amount,
                    title: "Weekly Expense",
                    category: "General",
                    color: Colors.blueAccent,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Monthly Transactions",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: monthlyExpenses.length,
                itemBuilder: (context, index) {
                  Expense expense = monthlyExpenses[index];
                  return TransactionTile(
                    day: DateFormat.yMMMMd().format(expense.date),
                    amount: expense.amount,
                    title: expense.title,
                    category: expense.category,
                    color: Colors.greenAccent,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final String day;
  final double amount;
  final String title;
  final String category;
  final Color color;

  const TransactionTile(
      {Key? key,
      required this.day,
      required this.amount,
      required this.title,
      required this.category,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: const Icon(Icons.attach_money, color: Colors.teal),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        subtitle: Text(day),
        trailing: Text(
          '\$${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        onTap: () {
          // Navigate to detail screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionDetailScreen(
                title: title,
                amount: amount,
                date: day,
                category: category,
              ),
            ),
          );
        },
      ),
    );
  }
}

class TransactionDetailScreen extends StatelessWidget {
  final String title;
  final double amount;
  final String date;
  final String category;

  const TransactionDetailScreen(
      {Key? key, required this.title, required this.amount, required this.date, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Transaction Details",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Title: $title",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Amount: \$${amount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Date: $date",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Category: $category",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
