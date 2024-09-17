import 'package:expence_app/screens/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/welcome_page.dart'; // Assuming you have a welcome page

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser; // Get current user

    return IconButton(
      icon: const CircleAvatar(
        child: Icon(Icons.person), // Person icon
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('User Info'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Email: ${user?.email ?? 'No email'}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _logout(context); // Call logout function
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          },
        );
      },
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
