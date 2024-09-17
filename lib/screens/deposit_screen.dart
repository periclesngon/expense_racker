import 'package:expence_app/screens/biometric.dart';
import 'package:expence_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'expense_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
 // Add this for biometric authentication
 // Make sure ExpenseProvider is imported

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  _DepositScreenState createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final BiometricService _biometricService = BiometricService();  // Use BiometricService here

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
    bool authenticated = await _biometricService.authenticate();  // Use authenticate from BiometricService

    if (authenticated) {
      final amount = _amountController.text;
      _simulatePayment(amount);
    }
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
                   Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const HomeScreen())
      );
 // Go back to the previous screen
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
