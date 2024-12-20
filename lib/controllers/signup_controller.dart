import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_services.dart';
import '../services/firestore_service.dart';

class SignUpController {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  void goLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  // Signup and Save User Info
  Future<void> signupUser(BuildContext context, String name, String email, String password, String phoneNumber) async {
    try {
      // Step 1: Create user in Firebase Auth
      User? user = await _authService.signUp(email, password);

      if (user != null) {
        // Step 2: Save additional info in Firestore
        await _firestoreService.addUser(user.uid, name, email, null, phoneNumber);

        // Step 3: Show success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 10),
                Text('You Signed up successfully .. moving to the login page',style: TextStyle(color: Colors.black),),
              ],
            ),
            backgroundColor: Colors.white,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 3),
          ),
        );

        // Step 4: Navigate to the login page after SnackBar duration
        Future.delayed(const Duration(seconds: 3), () {
          goLogin(context);
        });
      } else {
        // Show error if signup failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signup failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle exceptions during signup
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
