import 'package:expence_app/screens/biometric.dart';
import 'package:flutter/material.dart';
import 'secure_storage_service.dart';
import 'home_page.dart';  // Assuming HomeScreen is the home page
import 'package:firebase_auth/firebase_auth.dart';  // Firebase Auth import

class BiometricPassword extends StatefulWidget {
  const BiometricPassword({super.key});

  @override
  _BiometricEnrollmentScreenState createState() => _BiometricEnrollmentScreenState();
}

class _BiometricEnrollmentScreenState extends State<BiometricPassword> {
  final BiometricService _biometricService = BiometricService();
  final SecureStorageService _secureStorageService = SecureStorageService();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;  // Firebase Authentication instance

  // Enroll biometrics (scan fingerprint)
  Future<void> _enrollBiometrics() async {
    try {
      bool canEnroll = await _biometricService.isBiometricAvailable();

      if (canEnroll) {
        bool enrolled = await _biometricService.authenticate();

        if (enrolled) {
          User? user = _auth.currentUser;  // Fetch current authenticated user
          if (user != null) {
            await _biometricService.setupBiometricsOrPassword(user.uid);  // Save biometric enrollment in Firebase
            _navigateToHome();
          } else {
            _showErrorSnackbar('User not authenticated');
          }
        } else {
          _showErrorSnackbar('Biometric enrollment failed');
        }
      } else {
        _showErrorSnackbar('Biometrics not available on this device');
      }
    } catch (e) {
      _showErrorSnackbar('Error during biometric setup: ${e.toString()}');
    }
  }

  // Save password
  Future<void> _setPassword() async {
    final String password = _passwordController.text;

    if (password.isNotEmpty) {
      try {
        User? user = _auth.currentUser;
        if (user != null) {
          // Store password securely in Firebase or local storage
          await _secureStorageService.storePassword(password);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password set successfully')),
          );
          _navigateToHome();
        } else {
          _showErrorSnackbar('User not authenticated');
        }
      } catch (e) {
        _showErrorSnackbar('Error during password setup: ${e.toString()}');
      }
    } else {
      _showErrorSnackbar('Please enter a valid password');
    }
  }

  // Error handling - show error snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Navigate to HomeScreen
  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biometric Enrollment')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _enrollBiometrics,
              child: const Text('Set up Biometrics'),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Enter a fallback password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _setPassword,
              child: const Text('Set up Password instead'),
            ),
          ],
        ),
      ),
    );
  }
}
