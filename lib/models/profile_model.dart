import '../services/myDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  final myDatabaseClass _localDb = myDatabaseClass();
  final String userId;
  ProfileModel(this.userId);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> clearLocalUserData() async {

    final myDb = myDatabaseClass();

    // Example SQL query to delete user-specific data
    String sql = "DELETE FROM Users WHERE id = '$userId'";
    try {
      var response = await myDb.deleteData(sql);
      print('Deleted $response rows from the local database for user: $userId');
    } catch (e) {
      print('Error clearing local user data: $e');
    }
  }

  Future<String?> getUserName() async {
    String sql = "SELECT name FROM Users WHERE id = ?";
    try {
      List<Map<String, dynamic>> response = await _localDb.readData(sql, [userId]);
      if (response.isNotEmpty) {
        return response[0]['name'] as String?; // Return the name from the result
      } else {
        print('No user found with id: $userId');
        return null;
      }
    } catch (e) {
      print('Error retrieving user name: $e');
      return null;
    }
  }

  Future<void> updateUserField(String userId, String field, String value) async {
    try {
      // Update in Firestore
      await _firestore.collection('Users').doc(userId).update({field: value});

      // Update in Local Database
      String sql = '''
      UPDATE Users
      SET $field = ?
      WHERE id = ?
    ''';

      await _localDb.updateProfileData(sql, [value, userId]);

      print('$field updated successfully in both Firestore and Local Database.');
    } catch (e) {
      throw Exception('Error updating $field: $e');
    }
  }



}