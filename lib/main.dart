// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/expense_provider.dart'; // Path to your provider
import 'screens/home_page.dart'; // Path to your home screen

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseProvider()), // Providing the ExpenseProvider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
