import 'package:flutter/material.dart';
import 'home.dart';
import 'MyPledgedGifts.dart';
import 'EventsList.dart';
import 'MyNotifications.dart';
import 'Profile.dart';
//import 'controllers/home_screen_controller.dart';


class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final String userId;

  const BottomNavBar({Key? key, required this.selectedIndex, required this.userId}) : super(key: key);

  void _navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>  HomeScreen(userId: userId)),
              (route) => false, // Clear navigation stack
        );
        break;
      case 1:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>  PledgedGiftsPage(userId: userId)),
              (route) => false,
        );
        break;
      case 2:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>  EventListPage(userId: userId)),
              (route) => false,
        );
        break;
      case 3:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>  NotificationPage(userId: userId)),
              (route) => false,
        );
        break;
      case 4:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>  ProfileScreen(userId: userId)),
              (route) => false,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFC107),
            Color(0xFF80D8FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => _navigateToPage(context, index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}
