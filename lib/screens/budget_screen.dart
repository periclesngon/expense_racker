import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'expense_provider.dart';
import 'home_page.dart'; 
// Import your provider

class Budgetsetter extends StatefulWidget {
  const Budgetsetter({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BudgetsetterState createState() => _BudgetsetterState();
}

class _BudgetsetterState extends State<Budgetsetter> {
  final TextEditingController _budgetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Monthly Budget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Monthly Budget',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                double newBudget = double.tryParse(_budgetController.text) ?? 0.0;

                // Update the budget using the provider
                Provider.of<ExpenseProvider>(context, listen: false).editMonthlyBudget(newBudget);

                // Navigate to the HomeScreen after setting the budget
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),  // Navigate to your HomeScreen
                );
              },
              child: const Text('Set Budget'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }
}