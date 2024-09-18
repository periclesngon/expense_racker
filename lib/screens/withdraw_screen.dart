import 'package:expence_app/screens/biometric.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:expence_app/screens/expense_provider.dart'; // Ensure this import is correct
import 'package:expence_app/screens/home_page.dart'; // Ensure this import is correct
 // Import the biometric service

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({
    super.key, 
    required this.amount, 
    required this.onWithdrawConfirmed, // Ensure this is initialized
    required this.category,            // Ensure this is initialized
  });

  final double amount;
  final String category; // Final variable initialized
  final void Function() onWithdrawConfirmed; // Final variable initialized

  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}


class _WithdrawScreenState extends State<WithdrawScreen> {
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  final BiometricService _biometricService = BiometricService();
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isBiometricAvailable = false;
  List<String> _categories = []; // List to store categories
  String _selectedCategory = ''; // Selected category

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.amount.toString();
    _checkBiometricAvailability(); // Check for biometrics on init
    _selectedCategory = widget.category;
     _fetchCategories(); // Fetch categories on init

  }

  Future<void> _fetchCategories() async {
    // Simulating a fetch request for categories. In a real app, you'd fetch from a service or database.
    List<String> fetchedCategories = ['Food', 'Transport', 'Shopping', 'Bills', 'Other'];

    setState(() {
      _categories = fetchedCategories;
      // Default to the passed category or the first in the list
      if (!_categories.contains(_selectedCategory)) {
        _selectedCategory = _categories.isNotEmpty ? _categories[0] : '';
      }
    });
  }

  Future<void> _checkBiometricAvailability() async {
    bool isAvailable = await _biometricService.isBiometricAvailable();
    setState(() {
      _isBiometricAvailable = isAvailable;
    });
  }

  Future<void> _authenticate() async {
    if (_isBiometricAvailable) {
      bool isAuthenticated = await _biometricService.authenticate();
      if (isAuthenticated) {
        _processWithdrawal();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric authentication failed')),
        );
      }
    } else {
      _showPasswordConfirmationDialog(); // Show password dialog if biometrics are not available
    }
  }
    Future<bool> _validatePassword(String enteredPassword) async {
    // Fetch the user's stored password from Firebase or other secure storage
    try {
      bool isValid = await _biometricService.validatePassword(enteredPassword);
    return isValid;
    } catch (e) {
      print('Password validation failed: $e');
      return false;
    }
  }

  void _showPasswordConfirmationDialog() {
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Password Confirmation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please enter your password to confirm the withdrawal.'),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              child: const Text('Confirm'),
              onPressed: () async {
                String enteredPassword = passwordController.text;
                if (await _validatePassword(enteredPassword)) {
                  Navigator.of(context).pop(); // Close the dialog if the password is correct
                  _processWithdrawal(); // Proceed with withdrawal
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid password')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
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
                    padding: const EdgeInsets.only(left: 8.0),
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
              onPressed: _authenticate, // Trigger authentication before proceeding with withdrawal
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
      aspectRatio: 1,
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