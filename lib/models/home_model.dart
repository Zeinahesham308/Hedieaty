import '../services/myDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeModel {
  final myDatabaseClass _localDb = myDatabaseClass();

  Future<String?> getWelcomeName(String userId) async {
    try {
      // Query the database to get the user's name
      List<Map<String, dynamic>> result = await _localDb.readData(
        'SELECT name FROM Users WHERE id = ?',
        [userId],
      );

      if (result.isNotEmpty) {
        return result[0]['name'];
      }
      return null; // No user found
    } catch (e) {
      print('Error fetching welcome name: $e');
      return null;
    }
  }


  Future<List<Map<String, dynamic>>> fetchFriends(String userId) async {
    List<Map<String, dynamic>> friendsList = [];

    // Step 1: Get friends for the logged-in user
    var friendsSnapshot = await FirebaseFirestore.instance
        .collection('Friends')
        .where('userId', isEqualTo: userId)
        .get();

    // Step 2: For each friendId, fetch user details from the Users table
    for (var friendDoc in friendsSnapshot.docs) {
      var friendData = friendDoc.data();
      String friendId = friendData['friendId'];

      var userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(friendId)
          .get();

      if (userSnapshot.exists) {
        var userData = userSnapshot.data()!;
        friendsList.add({
          'friendId': friendId,
          'name': userData['name'], // Fetch from Users table
          'upcomingEventsCount': 0, // Default for now
        });
      }
    }

    return friendsList;
  }


}