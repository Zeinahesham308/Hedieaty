import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add User to Firestore
  Future<void> addUser(String userId, String name, String email, dynamic preferences,String phoneNumber) async {
    try {
      await _firestore.collection('Users').doc(userId).set({
        'name': name,
        'email': email,
        'preferences': preferences,
        'phoneNumber' :phoneNumber
      });
      print('FirestoreService - User added successfully!');
    } catch (e) {
      print('FirestoreService - Error adding user: $e');
    }
  }
}
