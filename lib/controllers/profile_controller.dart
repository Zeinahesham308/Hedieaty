import '../models/profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController {
  final ProfileModel _profileModel;

  ProfileController(String userId) : _profileModel = ProfileModel(userId);

  /// Fetch the user's name
  Future<String?> getUserName() async {
    try {
      final userName = await _profileModel.getUserName();
      if (userName != null) {
        print('Fetched user name: $userName');
      } else {
        print('User name not found for ID: ${_profileModel.userId}');
      }
      return userName;
    } catch (e) {
      print('Error fetching user name: $e');
      return null;
    }
  }

  /// Clear the local user data
  Future<void> clearLocalUserData() async {
    try {
      await _profileModel.clearLocalUserData();
      print('Local user data cleared successfully!');
    } catch (e) {
      print('Error clearing local user data: $e');
    }
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch current user data
  Future<Map<String, dynamic>> getCurrentUserData(String userId) async {
    try {
      final docSnapshot = await _firestore.collection('Users').doc(userId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data()!;
      }
      throw Exception('User not found.');
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }



  Future<void> updateField(String userId, String field, String value) async {
    try {
      await _profileModel.updateUserField(userId, field, value);
    } catch (e) {
      print('Controller Error: $e');
      throw Exception('Failed to update $field.');
    }
  }

  FirebaseFirestore get firestore => _firestore;


}



  // Future<void>changeName()
  // Future<void>changePhone()


