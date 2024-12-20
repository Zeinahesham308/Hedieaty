import 'package:flutter/material.dart';
import 'package:hedieaty/controllers/notification_controller.dart';
class NotificationHandler extends StatefulWidget {
  final String userId;
  final Widget child;

  const NotificationHandler({Key? key, required this.userId, required this.child}) : super(key: key);

  @override
  _NotificationHandlerState createState() => _NotificationHandlerState();
}

class _NotificationHandlerState extends State<NotificationHandler> {
  final NotificationController _notificationController = NotificationController();

  @override
  void initState() {
    super.initState();

    // Start listening for notifications
    _notificationController
        .listenForNotifications(widget.userId)
        .listen((notifications) {
      for (var notification in notifications) {
        // Show popup for each unread notification
        _showNotificationPopup(notification);
        // Mark it as read after showing the popup
        _notificationController.markNotificationAsRead(notification['id']);
      }
    });
  }

  void _showNotificationPopup(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification['type'] == 'gift_pledged' ? 'Gift Pledged' : 'Notification'),
        content: Text(notification['message']),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child; // Return the child widget (the rest of your app)
  }
}
