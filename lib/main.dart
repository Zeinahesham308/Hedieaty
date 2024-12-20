import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/myDatabase.dart';
import 'views/first.dart';
import 'views/login.dart';
import 'views/signup.dart';
import 'views/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  myDatabaseClass database = myDatabaseClass();

  // Drop the database
  await database.reseting();

  // Reinitialize the database
  await database.mydbcheck(); // Ensure database is initialized
  runApp(const HedeieatyApp());
}

class HedeieatyApp extends StatelessWidget {
  const HedeieatyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedieaty',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) =>  FirstScreen(),
        '/login': (context) => LoginScreen(), // Define LoginScreen
        '/signup': (context) => SignUpScreen(), // Define SignUpScreen
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/HomeScreen') {
          final args = settings.arguments as String; // Expecting userId as a String
          return MaterialPageRoute(
            builder: (context) => HomeScreen(userId: args),
          );
        }
        return null;
      },
    );
  }
}
