// main.dart
// ignore_for_file: unused_import


import 'package:expence_app/screens/home_page.dart';
import 'package:expence_app/screens/login_page.dart';
import 'package:expence_app/screens/theme_provider.dart';
import 'package:expence_app/screens/user_profile.dart';
import 'package:expence_app/screens/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/expense_provider.dart'; // Path to your provider
// Path to your home screen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
      options: const FirebaseOptions(
      apiKey:"AIzaSyC288wK3r6M5WyYQLVU9flCjBmbU95noK0", 
    appId: "1:1029305283942:android:35bdd956c8b7c6344684a7",
     messagingSenderId: "1029305283942",
      projectId: "ztheexpense",
      storageBucket: "ztheexpense.appspot.com",
      databaseURL: "https://ztheexpense-default-rtdb.firebaseio.com/",
      authDomain: "ztheexpense.firebaseapp.com"
      
      
      
      
      ),
     
  
  );
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
         ChangeNotifierProvider(create: (_) => UserProvider()),
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
