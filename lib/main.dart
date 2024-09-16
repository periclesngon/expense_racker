// main.dart
// ignore_for_file: unused_import

import 'package:expence_app/screens/budget_screen.dart';
import 'package:expence_app/screens/home_page.dart';
import 'package:expence_app/screens/login_page.dart';
import 'package:expence_app/screens/theme_provider.dart';
import 'package:expence_app/screens/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/expense_provider.dart'; // Path to your provider
// Path to your home screen

void main() {
  runApp(

      const MyApp(),
    );
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
         ChangeNotifierProvider(create: (_) => ThemeProvider(ThemeData.dark())),
      ],
      child: MaterialApp(
        title: 'Expense App',
        theme:ThemeData.light(),
        home: const  WelcomePage (),
        
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
