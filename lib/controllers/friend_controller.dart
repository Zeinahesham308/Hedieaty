import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/friend_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendController
{


 final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 final FirestoreService _firestore1 = FirestoreService();
 Stream<Map<String, dynamic>?> getFriendData(String phoneNumebr)
  {
    // Call the stream method from the user model
    return  _firestore1.getUserByPhoneNumberStream(phoneNumebr);
  }

 Future<void> sendFriendRequest(String requesterId, String receiverId) async {
   try {
     // Step 1: Check if a pending request already exists
     QuerySnapshot existingRequest = await _firestore
         .collection('FriendRequests')
         .where('requesterId', isEqualTo: requesterId)
         .where('receiverId', isEqualTo: receiverId)
         .where('status', isEqualTo: 'pending')
         .get();

     if (existingRequest.docs.isNotEmpty) {
       print('Friend request already sent and pending.');
       return; // Do not add a duplicate request
     }

     // Step 2: Fetch the requester's name from the Users collection
     String requesterName = 'Unknown User';
     DocumentSnapshot userDoc = await _firestore.collection('Users').doc(requesterId).get();

     if (userDoc.exists) {
       requesterName = userDoc['name'] ?? 'Unknown User';
     }

     // Step 3: Add to FriendRequests if no existing pending request
     await _firestore.collection('FriendRequests').add({
       'requesterId': requesterId,
       'receiverId': receiverId,
       'status': 'pending',
     });

     // Step 4: Add notification for the receiver
     await _firestore.collection('Notifications').add({
       'receiverId': receiverId,
       'senderId': requesterId,
       'message': 'You received a friend request from $requesterName.',
       'type': 'friend_request',
       'status': 'unread',
       'timestamp': FieldValue.serverTimestamp(),
     });

     print('Friend request sent successfully!');
   } catch (e) {
     print('Error sending friend request: $e');
   }
 }
 Future<bool> isFriendRequestPending(String requesterId, String receiverId) async {
   try {
     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
         .collection('FriendRequests')
         .where('requesterId', isEqualTo: requesterId)
         .where('receiverId', isEqualTo: receiverId)
         .where('status', isEqualTo: 'pending')
         .get();

     return querySnapshot.docs.isNotEmpty; // True if a pending request exists
   } catch (e) {
     print('Error checking pending friend request: $e');
     return false;
   }
 }
 Future<void> acceptFriendRequest(String requesterId, String accepterId) async {
   // Step 1: Update FriendRequests status
   QuerySnapshot requestSnapshot = await _firestore
       .collection('FriendRequests')
       .where('requesterId', isEqualTo: requesterId)
       .where('receiverId', isEqualTo: accepterId)
       .get();

   for (var doc in requestSnapshot.docs) {
     await doc.reference.update({'status': 'accepted'});
   }

   // Step 2: Add mutual entries in Friends collection
   await _firestore.collection('Friends').add({
     'userId': accepterId,
     'friendId': requesterId,
   });
   await _firestore.collection('Friends').add({
     'userId': requesterId,
     'friendId': accepterId,
   });
   String accepterName = 'Unknown User';
   DocumentSnapshot userDoc = await _firestore.collection('Users').doc(accepterId).get();

   if (userDoc.exists) {
     accepterName = userDoc['name'] ?? 'Unknown User';
   }

   // Step 3: Add notification for requester
   await _firestore.collection('Notifications').add({
     'senderId': requesterId,
     'receiverId': requesterId,
     'message': '$accepterName accepted your friend request.',
     'type': 'friend_accept',
     'status': 'unread',
   });
 }
 Future<void> denyFriendRequest(String requesterId, String receiverId) async {
   // Remove the friend request
   QuerySnapshot requestSnapshot = await _firestore
       .collection('FriendRequests')
       .where('requesterId', isEqualTo: requesterId)
       .where('receiverId', isEqualTo: receiverId)
       .get();

   for (var doc in requestSnapshot.docs) {
     await doc.reference.delete();
   }
 }
}

