import 'package:expence_app/screens/home_page.dart';
import 'package:expence_app/screens/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart'; // Ensure you have a HomeScreen to navigate to
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // If the user's name is not set in UserProvider, set it
    if (user != null && userProvider.userName.isEmpty) {
      String displayName = user.displayName ?? user.email!.split('@')[0];
      userProvider.setUserName(displayName);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen())),
        ),
      ),
      body: Center(
        child: IconButton(
          icon: const CircleAvatar(
            child: Icon(Icons.person), // Person icon
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Hi, ${userProvider.userName}!'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Name: ${userProvider.userName}'),
                      const SizedBox(height: 10),
                      Text('Email: ${user?.email ?? 'No email'}'),
                      const SizedBox(height: 10),
                      Text('Total Spent: \$${userProvider.totalSpent.toStringAsFixed(2)}'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _logout(context);
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomePage()),
    );
  }
}

// Mocked UserProvider class
class UserProvider with ChangeNotifier {
  String _userName = '';
  double _totalSpent = 0.0;

  String get userName => _userName;
  double get totalSpent => _totalSpent;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserProvider() {
    loadUserData();
  }

  Future<void> loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await _firestore.collection('users').doc(user.uid).get();
      _userName = userData['name'];
      notifyListeners();
    }
  }

  void setTotalSpent(double amount) {
    _totalSpent = amount;
    notifyListeners();
  }

  void setUserName(String displayName) {
    _userName = displayName;
    notifyListeners();
  }
}
