import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<bool> isBiometricAvailable() async {
    return await _localAuth.canCheckBiometrics;
  }

  Future<bool> authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } catch (e) {
      return false;
    }
  }

  Future<void> setupBiometricsOrPassword(BuildContext context) async {
    bool canAuthenticateWithBiometrics = await isBiometricAvailable();
    if (canAuthenticateWithBiometrics) {
      bool didAuthenticate = await authenticate();
      if (didAuthenticate) {
        await _storeBiometricEnrollment(true);
      } else {
        // Handle failure or fallback to password setup
        _showPasswordSetupDialog(context, 'Biometric authentication failed. Would you like to set up a password instead?');
      }
    } else {
      // Prompt user to set up a password instead
      _showPasswordSetupDialog(context, 'Biometrics not available. Please set up a password.');
    }
  }

  Future<void> _storeBiometricEnrollment(bool enrolled) async {
    String? userId = _auth.currentUser?.uid;
    if (userId != null) {
      await _dbRef.child('users/$userId/biometrics').set(enrolled);
    }
  }

  // Store password securely in Firebase Database or other secure storage
  Future<void> storePassword(String password) async {
    String? userId = _auth.currentUser?.uid;
    if (userId != null) {
      // Hash the password or store securely (e.g., using Firebase or secure storage)
      await _dbRef.child('users/$userId/password').set(password);  // DO NOT store plain text in a real app
    }
  }

  // Define the _showPasswordSetupDialog method
  void _showPasswordSetupDialog(BuildContext context, String message) {
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Password Setup'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Enter password',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog
              },
            ),
            ElevatedButton(
              child: const Text('Set Password'),
              onPressed: () async {
                final String password = passwordController.text;
                if (password.isNotEmpty) {
                  await storePassword(password);  // Store the password securely
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password setup successful')),
                  );
                  Navigator.of(context).pop();  // Close the dialog after saving password
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid password')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
