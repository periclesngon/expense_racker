import 'package:expence_app/screens/transaction.dart';
import 'package:expence_app/screens/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'expense_provider.dart';
import 'add_expenses.dart';
import 'deposit_screen.dart'; 
import 'expenses_graph_widget.dart';
import 'theme_provider.dart';
 // Import the profile page you want to navigate to

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String depositedAmount = ''; // State to hold deposited amount

  // Handles navigation
  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else if (index == 1) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TransactionScreen()));
    } else if (index == 2) {
      // Navigate to DepositScreen and wait for result
      final result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const DepositScreen()),
      );

      if (result != null) {
        setState(() {
          depositedAmount = result; // Update the deposited amount
        });
      }
    } else if (index == 3) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddExpenseScreen()));
    } else if (index == 4) {
      _showThemeDialog(context);
    }
  }

  // Navigate to the profile page
  void _navigateToProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) =>  const UserProfile()), // Replace with your profile page
    );
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final balance = expenseProvider.income - expenseProvider.spent; // Calculate the balance

    return Scaffold(
    appBar: AppBar(
  title: const Text(
    'zTHeTRAck',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.blue,
    ),
  ),
  actions: [
    // Profile Icon in a Green Circle
    IconButton(
      icon: const CircleAvatar(
        backgroundColor: Colors.green, // Green circle
        child: Icon(
          Icons.person, // Profile icon
          color: Colors.white, // Icon color
        ),
      ),
      onPressed: () => _navigateToProfile(context), // Navigate on press
    ),
  ],
  automaticallyImplyLeading: false, // This removes the back button
),

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Show deposited amount if available
                if (depositedAmount.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'You have successfully deposited: F CFA $depositedAmount',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSummaryCard(
                              label: 'Incoming',
                              amount: expenseProvider.income.toString(),
                              color: Colors.green,
                              icon: Icons.arrow_downward,
                            ),
                            _buildSummaryCard(
                              label: 'Spends',
                              amount: expenseProvider.spent.toString(),
                              color: Colors.red,
                              icon: Icons.arrow_upward,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Add balance container here
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(0.1), // Similar to spent color
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Balance',
                                  style: TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'F CFA ${balance.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 350, child: ExpenseGraphWidget()),
                      ],
                    ),
                  ),
                ),
                // Removed total spent
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: expenseProvider.expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenseProvider.expenses[index];
                    return ListTile(
                      title: Text(expense.title),
                      subtitle: Text('Amount: \$${expense.amount}'),
                      trailing: Text(expense.category),
                    );
                  },
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(icon: Icons.home, label: 'Home', index: 0),
            _buildNavItem(icon: Icons.list, label: 'Transaction', index: 1),
            _buildAddButton(),
            _buildNavItem(icon: Icons.attach_money, label: 'Deposit', index: 2),
            _buildNavItem(icon: Icons.settings, label: 'Setting', index: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _selectedIndex == index ? Colors.blue : Colors.grey),
          Text(
            label,
            style: TextStyle(
              color: _selectedIndex == index ? Colors.blue : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () => _onItemTapped(3),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String label,
    required String amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'F CFA $amount',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('Light Theme'),
                onTap: () {
                  _changeTheme(context, ThemeData.light());
                },
              ),
              ListTile(
                title: const Text('Dark Theme'),
                onTap: () {
                  _changeTheme(context, ThemeData.dark());
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _changeTheme(BuildContext context, ThemeData theme) {
    Provider.of<ThemeProvider>(context, listen: false).setTheme(theme);
    Navigator.of(context).pop();
  }
}