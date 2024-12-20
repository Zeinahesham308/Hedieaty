import 'package:flutter/material.dart';

class FirstScreenController {
  void navigateToLogin(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }

  void navigateToSignUp(BuildContext context) {
    Navigator.pushNamed(context, '/signup');
  }
}
