import 'package:flutter/material.dart';
import '../controllers/friend_controller.dart';

class AddFriendPage extends StatefulWidget {
  final String userId;

  const AddFriendPage({Key? key, required this.userId}) : super(key: key);

  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final FriendController _friendController = FriendController();
  Stream<Map<String, dynamic>?>? friendStream;
  Map<String, dynamic>? friendData;
  bool isLoading = false;
  bool isPending = false; // Tracks if a friend request is pending


  void _searchFriend() {
    String phoneNumber = _phoneNumberController.text.trim();
    if (phoneNumber.isEmpty) {
      _showSnackBar('Please enter a phone number.');
      return;
    }

    // Set the friend stream using the controller
    setState(() {
      isLoading = true;
      friendStream = _friendController.getFriendData(phoneNumber);
    });

    // Handle stream completion
    // Use an async callback for listen
    friendStream!.listen((data) async {
      setState(() {
        friendData = data;
        isLoading = false;
      });

      if (friendData == null) {
        _showSnackBar('No user found with this phone number.');
      } else {
        // Check if a pending request exists
        bool pending = await _friendController.isFriendRequestPending(
            widget.userId, friendData!['id']);
        setState(() {
          isPending = pending;
        });
      }
    }, onError: (e) {
      _showSnackBar('Error fetching friend: $e');
      setState(() {
        isLoading = false;
      });
    });
  }
  Future<void> _addFriend() async {
    print(friendData);
    if (friendData == null || friendData?['id'] == null) {
      _showSnackBar('Friend data is invalid or incomplete.');
      return;
    }

    try {
      String friendId = friendData!['id'];
      await _friendController.sendFriendRequest(widget.userId, friendId);

      _showSnackBar('Friend request sent successfully!');
      setState(() {
        friendData = null;
        _phoneNumberController.clear();
      });
    } catch (e) {
      _showSnackBar('Error adding friend: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: true,
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
            'Add Friend',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
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
              child: TextField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter phone number',
                  icon: Icon(Icons.search, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchFriend,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Search',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (friendData != null)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFC107),
                      Color(0xFF2EC2D2),
                    ],
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
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        friendData!['name'] ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: isPending ? null : _addFriend, // Disable button if pending
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPending ? Colors.grey : Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        isPending ? 'Pending' : 'Add Friend',
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
