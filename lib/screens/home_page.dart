// ignore_for_file: library_private_types_in_public_api

import 'package:expence_app/screens/budget_screen.dart';
import 'package:expence_app/screens/expense_provider.dart';
import 'package:expence_app/screens/expenses_graph_widget.dart';
import 'package:expence_app/screens/transaction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expence_app/screens/add_expenses.dart';
import 'theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to respective screens based on index
    if (index == 0) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TransactionScreen()));
    } else if (index == 1) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else if (index == 2) {
      // Add additional page if necessary
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showThemeDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "F CFA${expenseProvider.totalSpentThisWeek()}",
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const Text("Total spent this week"),
                const SizedBox(height: 200, child: ExpenseGraphWidget()),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Budget for this month: F CFA${expenseProvider.monthlyBudget}",
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  "Spent: F CFA${expenseProvider.spentThisMonth()} of F CFA${expenseProvider.monthlyBudget}",
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(value: expenseProvider.spentPercentage()),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Budgetsetter()));
                  },
                  child: const Text('Modify Budget'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent, // Modify the color of the FAB
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddExpenseScreen()));
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        color: Colors.white, // Set background color of BottomAppBar
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Ensure proper spacing
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.list,
                color: _selectedIndex == 0 ? Colors.blueAccent : Colors.grey, // Color change on tap
              ),
              onPressed: () => _onItemTapped(0),
            ),
            const SizedBox(width: 48), // The space for the floating action button
            IconButton(
              icon: Icon(
                Icons.person,
                color: _selectedIndex == 1 ? Colors.blueAccent : Colors.grey, // Color change on tap
              ),
              onPressed: () => _onItemTapped(1),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('Light Theme'),
                onTap: () {
                  _changeTheme(context, ThemeData.light());
                },
              ),
              ListTile(
                title: const Text('Dark Theme'),
                onTap: () {
                  _changeTheme(context, ThemeData.dark());
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _changeTheme(BuildContext context, ThemeData theme) {
    Provider.of<ThemeProvider>(context, listen: false).setTheme(theme);
    Navigator.of(context).pop(); // Close the dialog after selection
  }
}
