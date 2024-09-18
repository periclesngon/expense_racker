import 'package:expence_app/screens/biometric.dart';
import 'package:expence_app/screens/withdraw_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'expense_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'biometric_password.dart'; // Import the new screen for password input

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  _DepositScreenState createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final BiometricService _biometricService = BiometricService();  

  String? userEmail;

  @override
  void initState() {
    super.initState();
    userEmail = FirebaseAuth.instance.currentUser?.email;
    _emailController.text = userEmail ?? "";
  }

  Future<void> _simulatePayment(String amount) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      _showPaymentSuccessScreen(context, amount);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing payment: $e')),
      );
    }
  }

  void _showPaymentSuccessScreen(BuildContext context, String amount) {
    final double depositAmount = double.tryParse(amount) ?? 0;
    if (depositAmount > 0) {
      context.read<ExpenseProvider>().deposit(depositAmount);
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaymentSuccess(
          message: 'You have successfully deposited F CFA $amount',
        ),
      ),
    );
  }

  Future<void> _biometricCheck(BuildContext context) async {
    bool canCheckBiometrics = await _biometricService.isBiometricAvailable();

    if (canCheckBiometrics) {
      bool authenticated = await _biometricService.authenticate();
      if (authenticated) {
        final amount = _amountController.text;
        _simulatePayment(amount);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric authentication failed')),
        );
      }
    } else {
      _showPasswordDialog(context);
    }
  }

  void _showPasswordDialog(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Password Authentication'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Enter your password',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog
              },
            ),
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () async {
                final String password = passwordController.text;
                if (password.isNotEmpty) {
                  bool authenticated = await _verifyPassword(password);
                  if (authenticated) {
                    Navigator.of(context).pop();  // Close the dialog
                    final amount = _amountController.text;
                    _simulatePayment(amount);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid password')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid password')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _verifyPassword(String password) async {
    // Implement your password verification logic here
    // For demonstration, we assume the password is always correct
    // Replace with actual verification logic
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Verify password with your secure storage or Firebase logic
      return true;  // This should be the result of actual password verification
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposit Money'),
        backgroundColor: const Color.fromARGB(255, 11, 180, 253),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _emailController,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount (F CFA)',
                  labelStyle: const TextStyle(color: Color.fromARGB(255, 16, 16, 16)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: const TextStyle(color: Color.fromARGB(255, 2, 2, 2)),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (_amountController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid amount')),
                    );
                  } else {
                    _biometricCheck(context);
                  }
                },
                child: const Text('Confirm Deposit', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
