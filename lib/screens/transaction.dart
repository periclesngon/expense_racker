import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'expense_provider.dart';  // Make sure this is correctly imported

class TransactionSummaryScreen extends StatelessWidget {
  const TransactionSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Summary'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              SummaryCard(
                title: 'Today',
                total: expenseProvider.spentPercentage(),
              ),
              SummaryCard(
                title: 'This Week',
                total: expenseProvider.totalSpentThisWeek(),
              ),
              SummaryCard(
                title: 'This Month',
                total: expenseProvider.spentThisMonth(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final double total;

  const SummaryCard({Key? key, required this.title, required this.total}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '₣ CFA${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
