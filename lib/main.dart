import 'package:flutter/material.dart';
import 'first.dart'; // Import the FirstScreen from first.dart
import 'login.dart';
import 'signup.dart';
import 'home.dart';

void main() {
  runApp(const HedeieatyApp());
}

class HedeieatyApp extends StatelessWidget {
  const HedeieatyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(), // Start with FirstScreen
      debugShowCheckedModeBanner: false,
    );
  }
}
