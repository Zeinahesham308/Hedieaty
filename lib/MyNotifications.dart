import 'package:flutter/material.dart';
import 'controllers/notification_controller.dart';
import 'controllers/friend_controller.dart';
import 'bottom_nav_bar.dart';

class NotificationPage extends StatefulWidget {
  final String userId;


  const NotificationPage({Key? key, required this.userId}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  final NotificationController _notificationController = NotificationController();
  final FriendController _friendController = FriendController();

  Future<void> _acceptFriendRequest(String requesterId,String receiverId, String notificationId) async {
    await _friendController.acceptFriendRequest(requesterId, widget.userId);
    await _notificationController.deleteNotification(notificationId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Friend request accepted.')),
    );
  }

  Future<void> _denyFriendRequest(String requesterId,String receiverId, String notificationId) async {
    await _friendController.denyFriendRequest(requesterId, widget.userId);
    await _notificationController.deleteNotification(notificationId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Friend request denied.')),
    );
  }

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
            'Notifications',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _notificationController.fetchNotifications(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching notifications.'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No notifications available.'));
          }

          final notifications = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                print("Notification $index: $notification");
                return NotificationCard(
                  title: notification['message'] ?? 'Notification',
                  description: notification['type'] ?? 'General',
                  date: notification['timestamp']?.toDate().toString() ?? '',
                  onDelete: () async {
                    await _notificationController.deleteNotification(notification['id']);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notification deleted.')),
                    );
                  },
                  onAccept: notification['type'] == 'friend_request' &&
                      notification['receiverId'] != null &&
                      notification['id'] != null
                      ? () => _acceptFriendRequest(notification['senderId'],notification['receiverId'],notification['id'] )
                      : null,

                  onDeny: notification['type'] == 'friend_request' &&
                      notification['receiverId'] != null &&
                      notification['id'] != null
                      ? () => _denyFriendRequest(notification['senderId'],notification['receiverId'],notification['id'])
                      : null,
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 3,
        userId: widget.userId,
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final VoidCallback onDelete;
  final VoidCallback? onAccept; // Accept button callback
  final VoidCallback? onDeny; // Deny button callback

  const NotificationCard({
    Key? key,
    required this.title,
    required this.description,
    required this.date,
    required this.onDelete,
    this.onAccept,
    this.onDeny,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFC107), Color(0xFF2EC2D2)],
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: const TextStyle(fontSize: 12, color: Colors.black45),
              ),
              Row(
                children: [
                  if (onAccept != null)
                    ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Accept', style: TextStyle(color: Colors.white)),
                    ),
                  const SizedBox(width: 8),
                  if (onDeny != null)
                    ElevatedButton(
                      onPressed: onDeny,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Deny', style: TextStyle(color: Colors.white)),
                    ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
