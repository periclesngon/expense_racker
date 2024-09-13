// add_expense_screen.dart
// ignore_for_file: use_key_in_widget_constructors

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
      // Save expense
      Provider.of<ExpenseProvider>(context, listen: false).addExpense(
        Expense(
          title: _title,
          amount: _amount,
          category: _category,
          date: DateTime.now(), id: '',
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expense"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _amount = double.parse(value!),
              ),
            DropdownButtonFormField(
  value: _category,
  items: [
    'Food',
    'Transport',
    'Shopping',
    'Utilities',
    'Housing',
    'Entertainment',
    'Health',
    'Travel',
    'Education',
    'Insurance',
    'Personal Care',
    'Clothing',
    'Gifts',
  ].map((category) {
    return DropdownMenuItem(
      value: category,
      child: Text(category),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      _category = value as String;
    });
  },
),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text("Add Expense"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
