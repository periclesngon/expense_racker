import 'package:expence_app/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
 // Import the login screen to navigate back

class VerificationScreen extends StatefulWidget {
  final String email;

  VerificationScreen({required this.email});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  bool _isCodeValid = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heightAnimation = Tween<double>(begin: 0, end: 150).animate(_animationController);
  }

  Future<void> _verifyCode() async {
    String enteredCode = _codeController.text.trim();
    // Here, you would verify the code received from Firebase or your backend
    if (enteredCode == '123456') { // Mock code validation
      setState(() {
        _isCodeValid = true;
      });
      _animationController.forward(); // Start animation
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid verification code')),
      );
    }
  }

  Future<void> _updatePassword() async {
    String newPassword = _newPasswordController.text.trim();
    if (newPassword.isNotEmpty) {
      try {
        // Update the password in Firebase or your backend
        await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully')),
        );
        // Redirect to the login screen and clear the stack
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false, // Clears the navigation stack
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Code')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'A verification code has been sent to your email. Enter the code below.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Verification Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _verifyCode,
              child: const Text('Verify Code'),
            ),
            const SizedBox(height: 20),
            // Animated password field container
            SizeTransition(
              sizeFactor: _heightAnimation,
              child: Column(
                children: [
                  TextField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'New Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _updatePassword,
                    child: const Text('Save New Password'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
