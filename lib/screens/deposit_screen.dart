import 'package:expence_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'expense_provider.dart'; // Make sure ExpenseProvider is imported

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  _DepositScreenState createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String reference = '';

  @override
  void initState() {
    super.initState();
    reference = "TX-${DateTime.now().millisecondsSinceEpoch}";
  }

  Future<void> _simulatePayment(String amount, String email) async {
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
      context.read<ExpenseProvider>().deposit(depositAmount);  // Use context.read here
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaymentSuccess(
          message: 'You have successfully deposited F CFA $amount',
        ),
      ),
    );
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
              const SizedBox(height: 20),
              const Text(
                'Enter Amount and Email',
                style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 14, 14, 14)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
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
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Color.fromARGB(255, 6, 6, 6)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
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
                  final amount = _amountController.text;
                  final email = _emailController.text;

                  if (amount.isEmpty || email.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid amount and email')),
                    );
                  } else {
                    _simulatePayment(amount, email);
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
