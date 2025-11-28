import 'package:flutter/material.dart';
import 'screens/goal/goals_screen.dart'; // This imports your new screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financial Tracker',
      debugShowCheckedModeBanner: false, // Removes the "Debug" banner
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // CHANGE THIS LINE BELOW:
      // We changed 'MyHomePage' to 'GoalsScreen'
      home: const GoalsScreen(),
    );
  }
}