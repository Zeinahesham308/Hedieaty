import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';
import 'ProfileDetails.dart';
import 'MyPledgedGifts.dart';
import '../controllers/logout_controller.dart';
import '../controllers/profile_controller.dart';
import '../views/EventsList.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;
  final LogoutController _controller;
  final ProfileController profileController;

  ProfileScreen({Key? key, required this.userId})
      : _controller = LogoutController(),
        profileController = ProfileController(userId),
        super(key: key);

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
                colors: [Color(0xFFFFC107), Color(0xFF2EC2D2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          title: const Text(
            'Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
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
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFF2EC2D2),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<String?>(
                    future: profileController.getUserName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError || snapshot.data == null) {
                        return const Text(
                          'Name not available',
                          style: TextStyle(fontSize: 22, color: Colors.grey),
                        );
                      }
                      return Text(
                        snapshot.data!,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ProfileOption(
              icon: Icons.edit,
              label: 'Update Personal Information',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileDetailsScreen(userId: userId)),
                );
              },
            ),
            // ProfileOption(
            //   icon: Icons.notifications,
            //   label: 'Notifications',
            //   onTap: () {},
            // ),
            ProfileOption(
              icon: Icons.event,
              label: 'My Events',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventListPage(userId: userId)),
                );
              },
            ),
            ProfileOption(
              icon: Icons.card_giftcard,
              label: 'My Pledged Gifts',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PledgedGiftsPage(userId: userId)),
                );
              },
            ),
            ProfileOption(
              icon: Icons.logout,
              label: 'Logout',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        'Confirm Logout',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text('No', style: TextStyle(color: Colors.red)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                            _controller.logoutUser(context, userId); // Call logout
                          },
                          child: const Text('Yes', style: TextStyle(color: Colors.green)),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 4,
        userId: userId,
      ),
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

