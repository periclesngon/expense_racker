import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:expence_app/screens/expense_provider.dart'; // Ensure this import is correct
import 'package:expence_app/screens/home_page.dart'; // Ensure this import is correct

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key, required this.amount});

  final double amount; // Add this parameter

  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  final LocalAuthentication _auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    // Set the amount in the controller
    _amountController.text = widget.amount.toString();
  }

  Future<void> _authenticate() async {
    try {
      final isAuthenticated = await _auth.authenticate(
        localizedReason: 'Please authenticate to proceed with the withdrawal.',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (isAuthenticated) {
        _processWithdrawal();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _processWithdrawal() {
    final amount = double.tryParse(_amountController.text);
    final category = _categoryController.text;

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    try {
      final balanceSufficient = Provider.of<ExpenseProvider>(context, listen: false).withdraw(amount);

      if (balanceSufficient) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PaymentSuccess(
              message: 'Withdrawal of F CFA ${amount.toStringAsFixed(2)} successful!',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Insufficient balance')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing withdrawal: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdraw Money'),
        backgroundColor: const Color.fromARGB(255, 11, 180, 253),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'Review Withdrawal Details',
              style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 14, 14, 14)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row( // Use Row to align the containers horizontally
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensure even spacing
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0), // Padding between the containers
                    child: _buildSummaryContainer(
                      label: 'Amount to Withdraw',
                      value: widget.amount.toStringAsFixed(2),
                      icon: Icons.attach_money,
                      color: Colors.red, // Spent color
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0), // Padding between the containers
                    child: _buildSummaryContainer(
                      label: 'Category',
                      value: _categoryController.text.isEmpty ? 'No category' : _categoryController.text,
                      icon: Icons.category,
                      color: Colors.green, // Income color
                    ),
                  ),
                ),
              ],
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
              onPressed: _authenticate,
              child: const Text('Confirm Withdrawal', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryContainer({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return AspectRatio(
      aspectRatio: 1, // Ensure the container is square
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$label: $value',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Payment Success Screen
class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Image.network(
                "https://res.cloudinary.com/iamvictorsam/image/upload/v1671834054/Capture_inlcff.png",
                height: MediaQuery.of(context).size.height * 0.4, // 40%
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              Text(message,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
              const Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 5.0,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Back to Home Screen',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
