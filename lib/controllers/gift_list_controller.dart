import '../models/event_model.dart';
import '../models/gift_model.dart';
import 'package:uuid/uuid.dart';
import '../controllers/notification_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class GiftListController {
  final _uuid = const Uuid();
  Future<Map<String, String>> fetchEventNames(String userId) async {

    final Event event = Event(
      id: '',
      name: '',
      date: '',
      location: '',
      userId: userId,
    );

    final List<Map<String, dynamic>> events = await event.getEvents(userId);

    // Convert events into a map of eventId -> eventName
    return {for (var e in events) e['id'] as String: e['name'] as String};
  }



  // Fetch all gifts for a specific event from the database
  Future<List<Map<String, dynamic>>> fetchGiftsForEvent(String eventId) async {
    // Instantiate the Gift model
    final Gift gift = Gift(
      id: '',
      name: '',
      description: '',
      category: '',
      price: 0.0,
      status: '',
      eventId: eventId,
      pledgedBy: '',
    );

    // Call a method to get gifts from the database filtered by eventId
    return await gift.getGiftsForEvent(eventId);
  }
  // Fetch event name for the given eventId
  Future<String> fetchEventName(String eventId) async {
    final Event event = Event(
      id: eventId,
      name: '',
      date: '',
      location: '',
      userId: '',
    );
    final result = await event.getEventById(eventId); // Query event details
    return result['name'] ?? 'Unknown Event';
  }

  /// Fetch predefined categories
  Future<List<String>> fetchCategories() async {
    final Gift giftModel = Gift(
      id: '',
      name: '',
      eventId: '',
      pledgedBy: '',
    );
    return await giftModel.fetchCategories();
  }


  /// Add a new gift
  Future<void> addGift({
    required String name,
    required String description,
    required String category,
    required double price,
    required String eventId,
  }) async {
    final String giftId = _uuid.v4();// Generate unique ID
    final Gift giftModel = Gift(
      id: giftId,
      name: name,
      description: description,
      category: category,
      price: price,
      status: 'Available', // Default status
      eventId: eventId,
      pledgedBy: '', // Default: Not pledged
    );

    await giftModel.insertGift(
      id: giftId,
      name: name,
      description: description,
      category: category,
      price: price,
      status: 'Available',
      eventId: eventId,
      pledgedBy: null,
    );
  }

  /// Update an existing gift
  Future<void> updateGift({
    required String id,
    required String name,
    required String description,
    required String category,
    required double price,
    required String status,
  }) async {
    final Gift giftModel = Gift(
      id: id,
      name: name,
      description: description,
      category: category,
      price: price,
      status: status,
      eventId: '',
      pledgedBy: '',
    );

    await giftModel.updateGift(
      id: id,
      name: name,
      description: description,
      category: category,
      price: price,
      status: status,
    );
  }

  /// Delete a gift
  Future<void> deleteGift(String giftId) async {
    final Gift giftModel = Gift(
      id: giftId,
      name: '',
      eventId: '',
      pledgedBy: '',
    );


    await giftModel.deleteGift(giftId);
  }

    /// Fetch gifts for a specific event ID
    Future<List<Map<String, dynamic>>> retrieveGifts(String eventId,
        {bool fromFirestore = true}) async {
      final Gift giftModel = Gift(
        id: '',
        name: '',
        eventId: '',
        pledgedBy: '',
      );
      try {
        if (fromFirestore) {
          // Fetch gifts from Firestore
          return await giftModel.fetchGiftsFromFirestore(eventId);
        } else {
          // Fetch gifts from local database
          return await giftModel.getGiftsByEventId(eventId);
        }
      } catch (e) {
        print('Error retrieving gifts for event ID $eventId: $e');
        return [];
      }
    }

  Future<void> updateGiftStatus(String giftId, String newStatus, String pledgedBy,String eventId) async {
    try {
      final Gift gift = Gift(
        id: giftId,
        name: '',
        category: '',
        description: '',
        price: 0.0,
        status: '',
        eventId: '',
        pledgedBy: pledgedBy
      );
      print("HELLO from GIFT LIST CONTROLLER");
      await gift.updateGiftStatus(giftId,newStatus,pledgedBy,eventId);

      final eventDoc = await FirebaseFirestore.instance
          .collection('Events')
          .doc(eventId)
          .get();

      final String eventName = eventDoc.data()?['name'] ?? 'Unknown Event';


      final giftDoc = await FirebaseFirestore.instance
          .collection('Events')
          .doc(eventId)
          .collection('Gifts')
          .doc(giftId)
          .get();

      final String giftName = giftDoc.data()?['name'] ?? 'Unknown Gift';
      final String Receiver =eventDoc.data()?['userId'] ?? 'Unokwn receiver';


      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(pledgedBy)
          .get();

      final String pledgerName = userDoc.data()?['name'] ?? 'Unknown User';

      final String pledger = giftDoc.data()?['pledgedBy'] ?? '';
      if (pledger.isNotEmpty) {
        //final String message = '$pledgerName pledged "$giftName" from "$eventName"';
        await NotificationController().sendPledgeNotification(
          Receiver,
          pledgedBy,
          pledgerName,
          giftName,
            eventName
        );
      }
    } catch (e) {
      print('Controller Error: Failed to update gift status: $e');
    }
  }



  Future<void> pledgeGift(String giftId, String userId,eventId) async {
    Gift gift = Gift(
        id: giftId,
        name: '',
        category: '',
        description: '',
        price: 0.0,
        status: '',
        eventId: '',
        pledgedBy: userId
    );

    await gift.updateGiftStatus(giftId,'Pledged', userId,eventId);
  }




  Future<void> purchaseGift(String giftId,userId,eventId) async {
    Gift gift = Gift(
      id: giftId,
      name: '',
      category: '',
      description: '',
      price: 0.0,
      status: '',
      eventId: '',
      pledgedBy: userId,
    );

    await gift.updateGiftStatus(giftId,'Purchased',userId,eventId);
  }


  Future<List<Map<String, dynamic>>> fetchPledgedGifts(String userId) async {
    return await Gift.getPledgedGiftsAcrossEvents(userId);
  }
  Future<void> updateGiftDetails(String id, String name, String category, String description, double price) async {
    Gift gift = Gift(
      id: id,
      name: '',
      category: '',
      description: '',
      price: 0.0,
      status: '',
      eventId: '',
      pledgedBy: ' ',
    );
    try {
      await gift.updateGiftDetails(
        id: id,
        name: name,
        category: category,
        description: description,
        price: price,
      );
    } catch (e) {
      print('Error updating gift details in the controller: $e');
    }
}

  /// Sort gifts alphabetically by name
  List<Map<String, dynamic>> sortGiftsByName(List<Map<String, dynamic>> gifts) {
    final modifiableGifts = List<Map<String, dynamic>>.from(gifts); // Make a mutable copy
    modifiableGifts.sort((a, b) => (a['name'] ?? '').toString().compareTo((b['name'] ?? '').toString()));
    return modifiableGifts;
  }

  /// Sort gifts alphabetically by category
  List<Map<String, dynamic>> sortGiftsByCategory(List<Map<String, dynamic>> gifts) {
    final modifiableGifts = List<Map<String, dynamic>>.from(gifts);
    modifiableGifts.sort((a, b) => (a['category'] ?? '').toString().compareTo((b['category'] ?? '').toString()));
    return modifiableGifts;
  }

  /// Sort gifts by status: Available -> Pledged -> Purchased
  List<Map<String, dynamic>> sortGiftsByStatus(List<Map<String, dynamic>> gifts) {
    final modifiableGifts = List<Map<String, dynamic>>.from(gifts);
    modifiableGifts.sort((a, b) {
      final String statusA = a['status'] ?? '';
      final String statusB = b['status'] ?? '';
      return _statusOrder(statusA).compareTo(_statusOrder(statusB));
    });
    return modifiableGifts;
  }

  /// Helper function to define status order
  int _statusOrder(String status) {
    switch (status) {
      case 'Available':
        return 0;
      case 'Pledged':
        return 1;
      case 'Purchased':
        return 2;
      default:
        return 3;
    }
  }
  /// Controller function to fetch gift status
  Future<String> getGiftStatus(String giftId, String eventId) async {
    try {
      Gift gift = Gift(
        id: giftId,
        name: '',
        category: '',
        description: '',
        price: 0.0,
        status: '',
        eventId: eventId,
        pledgedBy: ' ',
      );
      final String status = await gift.fetchGiftStatus(giftId, eventId);
      return status;
    } catch (e) {
      print('Controller Error: Failed to fetch gift status: $e');
      return 'Error';
    }
  }




}
