// main.dart
import 'package:expence_app/screens/budget_screen.dart';
import 'package:expence_app/screens/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/expense_provider.dart'; // Path to your provider
import 'screens/home_page.dart'; // Path to your home screen

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
         ChangeNotifierProvider(create: (_) => ThemeProvider(ThemeData.light())), // Default to light theme // Providing the ExpenseProvider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Budgetsetter(),
      
      debugShowCheckedModeBanner: false,
    );
  }
}
