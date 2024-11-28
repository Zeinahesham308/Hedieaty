import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
            'Profile',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Avatar and Name
            Center(
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFF2EC2D2),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Zeina Hesham',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // List of Options
            ProfileOption(
              icon: Icons.edit,
              label: 'Update Personal Information',
              onTap: () {
                // Navigate or handle action
              },
            ),
            ProfileOption(
              icon: Icons.notifications,
              label: 'Notifications',
              onTap: () {
                // Navigate or handle action
              },
            ),
            ProfileOption(
              icon: Icons.event,
              label: 'My Events',
              onTap: () {
                // Navigate or handle action
              },
            ),
            ProfileOption(
              icon: Icons.card_giftcard,
              label: 'My Pledged Gifts',
              onTap: () {
                // Navigate or handle action
              },
            ),
            ProfileOption(
              icon: Icons.logout,
              label: 'Logout',
              onTap: () {
                // Navigate or handle action
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 4), // Highlighting Profile
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ProfileOption({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: const Color(0xFF2EC2D2),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, size: 24, color: Colors.white),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward, color: Colors.white, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

