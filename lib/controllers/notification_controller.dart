import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch notifications for a specific user as a stream
  Stream<List<Map<String, dynamic>>> fetchNotifications(String userId) {
    return _firestore
        .collection('Notifications')
        .where('receiverId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      return {
        'id': doc.id, // Include the document ID
        ...doc.data(), // Spread other fields including senderId
      };
    }).toList());
  }

  /// Add a notification with senderId
  Future<void> addNotification(
      String receiverId, String senderId, String message, String type) async {
    await _firestore.collection('Notifications').add({
      'receiverId': receiverId, // Receiver's ID
      'senderId': senderId, // Sender's ID
      'message': message, // Notification message
      'type': type, // Notification type
      'status': 'unread', // Default status
      'timestamp': FieldValue.serverTimestamp(), // Timestamp
    });
  }

  /// Delete a notification by ID
  Future<void> deleteNotification(String notificationId) async {
    await _firestore.collection('Notifications').doc(notificationId).delete();
  }

  /// Mark a notification as read
  Future<void> markAsRead(String notificationId) async {
    await _firestore.collection('Notifications').doc(notificationId).update({
      'status': 'read',
    });
  }

  Future<void> sendPledgeNotification(
      String receiverId,
      String senderId,
      String senderName,
      String giftName,
      String eventName,
      ) async {
    final String message = '$senderName pledged "$giftName" from "$eventName"';
    print(message);
    await addNotification(receiverId, senderId, message, 'gift_pledged');
  }


  Stream<List<Map<String, dynamic>>> listenForNotifications(String receiverId) {
    return _firestore
        .collection('Notifications')
        .where('receiverId', isEqualTo: receiverId)
        .where('status', isEqualTo: 'unread')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
        .toList());
  }
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _firestore.collection('Notifications').doc(notificationId).update({
        'status': 'read',
      });
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }
}
