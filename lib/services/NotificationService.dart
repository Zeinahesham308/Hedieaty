import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<Map<String, dynamic>> listenForNotifications(String ownerId) {
    return _firestore
        .collection('Notifications')
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        final latestNotification = snapshot.docs.first;
        // Mark notification as seen (optional)
        await _firestore.collection('Notifications').doc(latestNotification.id).update({'seen': true});
        return latestNotification.data() as Map<String, dynamic>;
      }
      return {};
    });
  }
}
