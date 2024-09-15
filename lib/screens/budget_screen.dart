import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart'; // Import the Rive package
import 'expense_provider.dart';
import 'home_page.dart';

class Budgetsetter extends StatefulWidget {
  const Budgetsetter({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BudgetsetterState createState() => _BudgetsetterState();
}

class _BudgetsetterState extends State<Budgetsetter>
    with SingleTickerProviderStateMixin {
  final TextEditingController _budgetController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Set the animation duration
    )..repeat(reverse: true); // Repeat the animation with a reverse motion

    // Tween to control the bounce effect
    _animation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the animation controller
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Monthly Budget'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User account details")),
              );
            },
          ),
        ],
        backgroundColor: Colors.teal, // Custom color for the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animated Wallet (Rive)
            const Center(
              child: SizedBox(
                height: 150, // Set the size for the animation
                width: 150,
                child: RiveAnimation.asset(
                  'assets/images/frankenstack.riv', // Path to your .riv file
                  fit: BoxFit.cover, // Adjust the fit
                  animations: ['idle'], // Define the animation (idle, etc.)
                ),
              ),
            ),
            
            const SizedBox(height: 20),

            // AnimatedBuilder to animate the jumping money icon
            Center(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -_animation.value),
                    child: child,
                  );
                },
                child: const Icon(
                  Icons.attach_money,
                  color: Colors.teal,
                  size: 50, // Size of the bouncing icon
                ),
              ),
            ),
            
            const SizedBox(height: 20),

            Text(
              'Set your Monthly Budget',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Monthly Budget',
                labelStyle: TextStyle(color: Colors.teal),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 2),
                ),
                prefixIcon: Icon(
                  Icons.monetization_on,
                  color: Colors.teal,
                ),
              ),
              cursorColor: Colors.teal,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Button background color
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 15.0),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  double newBudget =
                      double.tryParse(_budgetController.text) ?? 0.0;

                  // Update the budget using the provider
                  Provider.of<ExpenseProvider>(context, listen: false)
                      .editMonthlyBudget(newBudget);

                  // Navigate to the HomeScreen after setting the budget
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()),
                  );
                },
                child: const Text('Set Budget'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
