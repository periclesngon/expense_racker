import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // Firestore import

class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;  // Firestore instance
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Check if biometrics are available
  Future<bool> isBiometricAvailable() async {
    try {
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      bool isDeviceSupported = await _localAuth.isDeviceSupported();
      return canCheckBiometrics && isDeviceSupported;
    } catch (e) {
      print('Failed to check biometrics availability: $e');
      return false; // Return false if there is a failure in checking availability
    }
  }

  // Authenticate the user with biometrics
  Future<bool> authenticate() async {
    try {
      var authenticate = _localAuth.authenticate(
        localizedReason: 'Please authenticate to continue',
         options: const AuthenticationOptions(biometricOnly: true,
           stickyAuth: true,  // Keeps the authentication session active
          useErrorDialogs: true,)
        // Automatically handle errors by showing dialogs to the user
      );
      return await authenticate;
    } catch (e) {
      print('Error during biometric authentication: $e');
      
      return false;
    }
  }

  // Save biometric status to Firebase
  Future<void> setupBiometricsOrPassword(String userId) async {
    try {
      // Save biometric enrollment status to Firestore
      await _firestore.collection('users').doc(userId).set({
        'biometric_enrolled': true,
        'enrollment_date': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // Merge to avoid overwriting
      print('Biometric enrollment status saved successfully.');
    } catch (e) {
      print('Error saving biometric status: $e');
      throw Exception('Failed to save biometric status');
    }
  }

  // Store password securely in Firebase (e.g., hashed)
  Future<void> storePasswordInFirebase(String userId, String password) async {
    try {
      // Store password in Firestore
      await _firestore.collection('users').doc(userId).set({
        'password': password, // In real production, never store raw passwords, hash them
        'password_setup_date': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      print('Password stored in Firebase successfully.');
    } catch (e) {
      print('Error saving password to Firebase: $e');
      throw Exception('Failed to store password in Firebase');
    }
  }

  // Define the method to store password locally
  Future<void> storePassword(String password) async {
    try {
      // Example: Save password locally using Firebase Realtime Database (or secure storage)
      User? user = _auth.currentUser;
      if (user != null) {
        await _dbRef.child('users/${user.uid}/password').set(password);
        print('Password stored locally.');
      }
    } catch (e) {
      print('Error storing password: $e');
      throw Exception('Failed to store password');
    }
  }

  // Define the _showPasswordSetupDialog method
  void _showPasswordSetupDialog(BuildContext context, String message) {
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Password Setup'),
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
