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
}
