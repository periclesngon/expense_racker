import 'package:expence_app/screens/biometric.dart';
import 'package:expence_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
  // The BiometricService class you provided
  // Navigate to home after setup

class BiometricPassword extends StatefulWidget {
  @override
  _BiometricEnrollmentScreenState createState() => _BiometricEnrollmentScreenState();
}

class _BiometricEnrollmentScreenState extends State<BiometricPassword> {
  final BiometricService _biometricService = BiometricService();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _enrollBiometrics() async {
    bool canEnroll = await _biometricService.isBiometricAvailable();

    if (canEnroll) {
      bool enrolled = await _biometricService.authenticate();

      if (enrolled) {
        await _biometricService.setupBiometricsOrPassword(context);
        _navigateToHome();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric enrollment failed')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometrics not available on this device')),
      );
    }
  }

  Future<void> _setPassword() async {
    final String password = _passwordController.text;

    if (password.isNotEmpty) {
      // Here, you would typically store the password securely in Firebase (or securely on the device)
      // Using a simple example to show you could store it in Firebase for now.
      await _biometricService.storePassword(password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password set successfully')),
      );
      _navigateToHome();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid password')),
      );
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),  // Navigate to HomeScreen
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),  // Skip setup
                );
              },
              child: const Text(''),
            ),
          ],
        ),
      ),
    );
  }
}
