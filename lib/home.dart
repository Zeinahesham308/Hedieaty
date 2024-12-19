import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';
import 'views/FriendsEventList.dart'; // Replace with the actual import path
import 'controllers/home_screen_controller.dart';
import 'controllers/friend_controller.dart';
import 'views/AddFriend.dart';
import 'views/listCreationPage.dart';

class HomeScreen extends StatefulWidget {
  final String userId;


  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeScreenController _controller = HomeScreenController();
  final FriendController friendController = FriendController();

  String? welcomeName;
  List<Map<String, dynamic>> friendsList = [];
  Map<String, int> upcomingEventsMap = {}; // Map to store upcoming events count for each friend
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    HomeScreenController.setUserId(widget.userId);
    _fetchWelcomeName();
    _fetchFriends();
  }

  Future<void> _fetchWelcomeName() async {
    String? name = await _controller.getWelcomeName();
    setState(() {
      welcomeName = name;
    });
  }

  Future<void> _fetchFriends() async {
    try {
      List<Map<String, dynamic>> fetchedFriends =
      await _controller.fetchFriendsFromFriendsModel(widget.userId);

      // Fetch upcoming events for each friend
      for (var friend in fetchedFriends) {
        int count = await friendController.getUpcomingEventsCount(friend['friendId']);
        setState(() {
          upcomingEventsMap[friend['friendId']] = count;
        });
      }

      setState(() {
        friendsList = fetchedFriends;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching friends: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
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
          title: Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 30, color: Colors.grey),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    welcomeName != null ? 'Welcome, $welcomeName!' : 'Welcome, ...',
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const Text(
                    'Explore and manage your events',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CreateEventButton(userId: widget.userId),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search Friends or Gift Lists',
                        icon: Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddFriendPage(userId: widget.userId),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: const Icon(Icons.person_add, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : friendsList.isEmpty
                ? const Center(
              child: Text(
                'You have no friends yet',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
                : Expanded(
              child: ListView.builder(
                itemCount: friendsList.length,
                itemBuilder: (context, index) {
                  var friend = friendsList[index];
                  int upcomingEvents =
                      upcomingEventsMap[friend['friendId']] ?? 0;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FriendsEventListPage(
                            friendId: friend['friendId'],
                            friendName: friend['name'],
                            userId: widget.userId,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFC107), Color(0xFF2EC2D2)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: Colors.grey),
                        ),
                        title: Text(
                          friend['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Upcoming Events: $upcomingEvents'),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            color: Colors.black),
                        contentPadding: const EdgeInsets.all(0),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 0, userId: widget.userId),
    );
  }
}


class CreateEventButton extends StatelessWidget {
  final String userId;

  const CreateEventButton({Key? key, required this.userId}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListCreationPage(userId: userId)));
            print("Create event logic");
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.add, color: Colors.white, size: 20),
            SizedBox(width: 5),
            Text(
              'Create Your own Event/List',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
