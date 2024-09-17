import 'package:expence_app/screens/deposit_screen.dart';
import 'package:expence_app/screens/expense.dart';
import 'package:expence_app/screens/expense_provider.dart';
import 'package:expence_app/screens/withdraw_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  double _amount = 0;
  String _category = 'Food';
  final String _type = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final balanceSufficient = Provider.of<ExpenseProvider>(context, listen: false).withdraw(_amount);

      if (balanceSufficient) {
        try {
          Provider.of<ExpenseProvider>(context, listen: false).addExpense(
            Expense(
              UniqueKey().toString(),
              title: _title,
              amount: _amount,
              date: DateTime.now(),
              category: _category,
              type: _type,
              id: '',
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Expense added successfully')),
          );

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WithdrawScreen(amount: _amount,)),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DepositScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expense"),
        backgroundColor: const Color.fromARGB(255, 104, 168, 112),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Expense Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                _buildInputField(
                  icon: Icons.description,
                  label: 'Title',
                  onSaved: (value) => _title = value!,
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  icon: Icons.attach_money,
                  label: 'Amount',
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
                _buildDropdownField(
                  icon: Icons.category,
                  label: 'Category',
                  value: _category,
                  items: [
                    'Food', 'Transport', 'Shopping', 'Utilities', 'Housing', 'Entertainment',
                    'Health', 'Travel', 'Education', 'Insurance', 'Personal Care', 'Clothing', 'Gifts'
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _category = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: _submitForm,
                    child: const Text("Add Expense", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String label,
    TextInputType? keyboardType,
    required FormFieldSetter<String> onSaved,
    FormFieldValidator<String>? validator,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          prefixIcon: Icon(icon),
        ),
        keyboardType: keyboardType,
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }

  Widget _buildDropdownField({
    required IconData icon,
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          prefixIcon: Icon(icon),
        ),
        value: value,
        items: items.map((String category) {
          return DropdownMenuItem(
            value: category,
            child: Text(category),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
