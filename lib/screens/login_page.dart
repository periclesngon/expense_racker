import 'package:expence_app/screens/biometric_password.dart';
import 'package:expence_app/screens/home_page.dart'; // Import Home Screen
import 'package:expence_app/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return; // User canceled the login

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase authentication using the Google credentials
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      
      // Navigate to HomeScreen after successful sign-in
      _navigateToHomePage();
    } catch (e) {
      _showErrorSnackbar('Google Sign-In failed. Try again.');
    }
  }

  // Sign in with email and password
  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _navigateToHomePage(); // Navigate to Home on successful login
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          _showErrorSnackbar('No user found with this email. Please sign up.');
        } else if (e.code == 'wrong-password') {
          _showErrorSnackbar('Incorrect password. Try again.');
        } else {
          _showErrorSnackbar('Login failed. Try again.');
        }
      } else {
        _showErrorSnackbar('An error occurred. Try again.');
      }
    }
  }

  // Helper method to show error snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Navigate to Home Screen
  void _navigateToHomePage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => BiometricPassword()), // Replace HomeScreen with your actual home page
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/Login.png'), // Your login icon or profile picture
            ),
            const SizedBox(height: 30),
            Text("Login", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 30),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Implement forgot password functionality
                },
                child: const Text('Forgot Password?'),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            const Row(
              children: <Widget>[
                Expanded(child: Divider(thickness: 2)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('OR'),
                ),
                Expanded(child: Divider(thickness: 2)),
              ],
            ),
            const SizedBox(height: 16),
            // Center the Google Sign-In button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: signInWithGoogle,
                  child: Image.asset('assets/images/search.png'), // Google logo asset
                  backgroundColor: Colors.white,
                  elevation: 1,
                ),
              ],
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () {
                // Navigate to the register screen
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => BiometricPassword()));
              },
              child: const Text('Don\'t have an account? Register'),
            ),
          ],
        ),
      ),
    );
  }
}
