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
  Stream<Map<String, dynamic>?> getUserByPhoneNumberStream(String phoneNumber) {
    return FirebaseFirestore.instance
        .collection('Users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        // Add the document ID to the returned map
        return {
          'id': snapshot.docs.first.id, // Add the Firestore document ID
          ...snapshot.docs.first.data(), // Merge the document data
        };
      } else {
        print('No user found for phone number: $phoneNumber');
        return null; // Return null if no user is found
      }
    }).handleError((error) {
      print('Error fetching user by phone number: $error');
      return null; // Return null if there's an error
    });
  }
}
