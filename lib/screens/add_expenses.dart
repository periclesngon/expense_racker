import 'package:expence_app/screens/expense.dart';
import 'package:expence_app/screens/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  double _amount = 0;
  String _category = 'Food';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final budget = Provider.of<ExpenseProvider>(context, listen: false).monthlyBudget;
      if (_amount > budget) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Budget Exceeded'),
            content: Text('The amount entered exceeds your current budget of \$${budget.toStringAsFixed(2)}.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      } else {
        Provider.of<ExpenseProvider>(context, listen: false).addExpense(
          Expense(title: _title, amount: _amount, category: _category, date: DateTime.now(), id: ''),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expense"),
        backgroundColor: Colors.deepPurple, // Enhanced UI: Color change
      ),
      body: SingleChildScrollView( // For better handling of small screens
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Expense Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // Enhanced UI: Header
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(), // Enhanced UI: Bordered input
                    prefixIcon: Icon(Icons.description), // Enhanced UI: Icon
                  ),
                  onSaved: (value) => _title = value!,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(), // Enhanced UI: Bordered input
                    prefixIcon: Icon(Icons.attach_money), // Enhanced UI: Icon
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _amount = double.parse(value!),
                  validator: (value) {
                    if (value != null && double.parse(value) <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(), // Enhanced UI: Bordered dropdown
                    prefixIcon: Icon(Icons.category), // Enhanced UI: Icon
                  ),
                  value: _category,
                  items: [
                    'Food', 'Transport', 'Shopping', 'Utilities', 'Housing', 'Entertainment',
                    'Health', 'Travel', 'Education', 'Insurance', 'Personal Care', 'Clothing', 'Gifts'
                  ].map((String category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _category = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green), // Enhanced UI: Button color
                    onPressed: _submitForm,
                    child: const Text("Add Expense", style: const TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
