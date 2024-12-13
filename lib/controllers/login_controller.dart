import 'package:flutter/material.dart';
import '../home.dart';
import '../services/myDatabase.dart';
import '../models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final myDatabaseClass _localDb = myDatabaseClass();

  Future<void> loginUser(BuildContext context, String email, String password) async {
    try {
      // Step 1: Log the user in with Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      // Step 2: Fetch user data from Firestore
      DocumentSnapshot<Map<String, dynamic>> userDoc =
      await _firestore.collection('Users').doc(userId).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = {
          'id': userId,
          'name': userDoc.data()?['name'] ?? '',
          'email': userDoc.data()?['email'] ?? '',
          'preferences': userDoc.data()?['preferences'] ?? '',
          'phoneNumber': userDoc.data()?['phoneNumber'] ?? '',
        };

        // Step 3: Save user data locally
        await _localDb.saveUser(userData);

        print('User logged in and saved locally!');
        print(userData['name']);

        // Step 4: Navigate to HomeScreen
        // Pass the userId to the HomeScreen for further use
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(userId: userId),
          ),
        );
      } else {
        // Show a SnackBar if the user does not exist in Firestore
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 10),
                Text("Sorry, we don't recognize those details. Please check and try again."),
              ],
            ),
            backgroundColor: Colors.white,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 3),
          ),
        );
        print('No user data found in Firestore.');
      }
    } catch (e) {
      // Show error if login fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during login: $e'),
          backgroundColor: Colors.red,
        ),
      );
      print('Error during login: $e');
    }
  }

  // Navigate back to the previous page
  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  void goHome(BuildContext context) {
    Navigator.pushNamed(context, '/HomeScreen');
  }

  void goSignUp(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/signup');
  }
}
