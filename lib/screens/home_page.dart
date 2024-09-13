// home_screen.dart
import 'package:expence_app/screens/expense_provider.dart';
import 'package:expence_app/screens/expenses_graph_widget.dart';
import 'package:expence_app/screens/transaction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expence_app/screens/add_expenses.dart';
 // Assuming you have this widget in the widgets folder

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Accessing the expense provider data
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("\F CFA${expenseProvider.totalSpentThisWeek()}", // Using provider data
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const Text("Total spent this week"),
                const SizedBox(height: 200, child: ExpenseGraphWidget()), // Assuming this shows a graph of expenses
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text("Budget for this month: \F CFA${expenseProvider.monthlyBudget}", 
                    style: const TextStyle(fontSize: 18)),
                Text("Spent: \F CFA${expenseProvider.spentThisMonth()} of \F CFA${expenseProvider.monthlyBudget}"),
                const SizedBox(height: 10),
                LinearProgressIndicator(value: expenseProvider.spentPercentage()), // Progress bar for spending
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddExpenseScreen()));
          // Open new expense screen
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen()));
                // Navigate to the Home Screen
              },
            ),
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => TransactionSummaryScreen()));
                // Navigate to the Transactions Screen
              },
            ),
            const SizedBox(width: 48),  // The space for the floating action button
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigate to the Settings Screen
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                // Navigate to the Profile Screen
              },
            ),
          ],
        ),
      ),
    );
  }
}
    

