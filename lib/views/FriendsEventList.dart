import 'package:flutter/material.dart';
import '../controllers/friend_controller.dart';
import 'FriendsGiftList.dart'; // Import FriendsGiftList page

class FriendsEventListPage extends StatefulWidget {
  final String friendId;
  final String friendName;
  final String userId;

  const FriendsEventListPage({
    Key? key,
    required this.friendId,
    required this.friendName,
    required this.userId,
  }) : super(key: key);

  @override
  _FriendsEventListPageState createState() => _FriendsEventListPageState();
}

class _FriendsEventListPageState extends State<FriendsEventListPage> {
  final FriendController _friendController = FriendController();
  List<Map<String, dynamic>> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFriendEvents();
  }

  Future<void> _loadFriendEvents() async {
    try {
      List<Map<String, dynamic>> events =
      await _friendController.fetchEventsByFriendId(widget.friendId);
      setState(() {
        _events = events;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading friend events: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          key: const Key('friends_event_list_app_bar'),
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
          title: Text(
            '${widget.friendName}\'s Events',
            key: const Key('friends_event_list_title'),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
        key: Key('friends_event_list_loading'),
        child: CircularProgressIndicator(),
      ) // Loading state
          : _events.isEmpty
          ? const Center(
        key: Key('friends_event_list_empty'),
        child: Text('No events available.'),
      ) // No events state
          : ListView.builder(
        key: const Key('friends_event_list'),
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          return GestureDetector(
            key: Key('friend_event_item_$index'),
            onTap: () {
              // Navigate to FriendsGiftListPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FriendsGiftListPage(
                    eventName: event['name'],
                    friendName: widget.friendName,
                    eventId: event['id'],
                    userId: widget.userId,
                  ),
                ),
              );
            },
            child: Container(
              key: Key('friend_event_container_$index'),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFC107),
                    Color(0xFF2EC2D2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Event Details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['name'],
                        key: Key('friend_event_name_$index'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        event['date'] ?? 'No Date',
                        key: Key('friend_event_date_$index'),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                    key: Key('friend_event_arrow_icon'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
