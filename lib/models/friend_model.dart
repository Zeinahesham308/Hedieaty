import 'package:cloud_firestore/cloud_firestore.dart';
class Friend {
  final String userId; // Foreign key for User
  final String friendId; // ID of the friend
  String name="";

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


}
