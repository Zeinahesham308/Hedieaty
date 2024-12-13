import 'package:cloud_firestore/cloud_firestore.dart';
class Friend {
  final String userId; // Foreign key for User
  final String friendId; // ID of the friend

  Friend({
    required this.userId,
    required this.friendId,
  });

  // Convert Firestore document to Friend model
  factory Friend.fromFirestore(Map<String, dynamic> data) {
    return Friend(
      userId: data['user_id'] ?? '',
      friendId: data['friend_id'] ?? '',
    );
  }

  // Convert SQLite row to Friend model
  factory Friend.fromLocalDB(Map<String, dynamic> data) {
    return Friend(
      userId: data['user_id'].toString(),
      friendId: data['friend_id'].toString(),
    );
  }

  // Convert Friend model to SQLite insertable map
  Map<String, dynamic> toLocalDB() {
    return {
      'user_id': userId,
      'friend_id': friendId,
    };
  }



  // Future<List<Map<String, dynamic>>> fetchFriends(String userId) async {
  //   List<Map<String, dynamic>> friendsList = [];
  //
  //   // Step 1: Get friends for the logged-in user
  //   var friendsSnapshot = await FirebaseFirestore.instance
  //       .collection('Friends')
  //       .where('userId', isEqualTo: userId)
  //       .get();
  //
  //   // Step 2: For each friendId, fetch user details from the Users table
  //   for (var friendDoc in friendsSnapshot.docs) {
  //     var friendData = friendDoc.data();
  //     String friendId = friendData['friendId'];
  //
  //     var userSnapshot = await FirebaseFirestore.instance
  //         .collection('Users')
  //         .doc(friendId)
  //         .get();
  //
  //     if (userSnapshot.exists) {
  //       var userData = userSnapshot.data()!;
  //       friendsList.add({
  //         'friendId': friendId,
  //         'name': userData['name'], // Fetch from Users table
  //         'upcomingEventsCount': 0, // Default for now
  //       });
  //     }
  //   }
  //
  //   return friendsList;
  // }

}
