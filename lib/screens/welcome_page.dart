// ignore_for_file: prefer_const_constructors

import 'package:expence_app/screens/login_page.dart';
import 'package:expence_app/screens/register_screen.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 50.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/loggo.jpg', // Correct the typo from 'loggo.jpg' to 'logo.jpg'
                        height: 300,
                      ),
                      const Text(
                        'zTHeExpense App',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.blue,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'We Thank You For Choosing Our APP',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterScreen()));
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blue),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 450 + _animation.value, // Adjust this value based on your layout
              left: MediaQuery.of(context).size.width / 2 - 45, // Center the icon
              child: Icon(Icons.attach_money, size: 100, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
