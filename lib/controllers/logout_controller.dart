import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedieaty/views/first.dart';
import '../models/profile_model.dart';

class LogoutController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> logoutUser(BuildContext context, String userId) async {
    try {
      // Step 1: Sign out from Firebase Authentication
      await _auth.signOut();

      // Step 2: Clear local user data using ProfileModel
      final profileModel = ProfileModel(userId);
      await profileModel.clearLocalUserData();
      print('User data cleared from local database!');

      // Step 3: Navigate to LoginScreen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  FirstScreen()),
            (route) => false,
      );

      print('User logged out successfully!');
    } catch (e) {
      // Show error if logout fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during logout: $e'),
          backgroundColor: Colors.red,
        ),
      );
      print('Error during logout: $e');
    }
  }
}