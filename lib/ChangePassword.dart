import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFC107),
                  Color(0xFF2EC2D2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          title: const Text(
            'Change Password',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const PasswordTextField(
                label: 'Current Password',
                hintText: 'Enter your current password',
              ),
              const SizedBox(height: 20),
              const PasswordTextField(
                label: 'New Password',
                hintText: 'Enter your new password',
              ),
              const SizedBox(height: 20),
              const PasswordTextField(
                label: 'Confirm Password',
                hintText: 'Re-enter your new password',
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Handle password change submission
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: const Color(0xFF2EC2D2), // Button color
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 4), // Keep bottom nav bar
    );
  }
}

class PasswordTextField extends StatelessWidget {
  final String label;
  final String hintText;

  const PasswordTextField({
    Key? key,
    required this.label,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            obscureText: true, // To hide password input
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
