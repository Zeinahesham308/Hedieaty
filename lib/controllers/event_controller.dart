import '../models/event_model.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/gift_model.dart';
class EventController {
  final _uuid = const Uuid();

  final _firestore = FirebaseFirestore.instance;
  Future<void> createEvent({
    required String name,
    required String date,
    required String location,
    String? description,
    required String userId,
  }) async {
    final String eventId = _uuid.v4(); // Generate a unique ID
    final Event event = Event(
      id: eventId,
      name: name,
      date: date,
      location: location,
      description: description ?? '',
      userId: userId,
    );

    await event.addEvent(
      name: name,
      date: date,
      location: location,
      description: description,
      userId: userId,
    );
  }

  Future<List<Map<String, dynamic>>> fetchEvents(String userId) async {
    final Event event = Event(
      id: '', // Dummy ID, not required for fetching events
      name: '',
      date: '',
      location: '',
      userId: userId,
    );

    return await event.getEvents(userId);
  }

  String getEventStatus(String eventDate) {
    DateTime today = DateTime.now();
    DateTime event = DateTime.parse(eventDate);

    // Truncate time component for comparison
    DateTime todayDate = DateTime(today.year, today.month, today.day);
    DateTime eventDateOnly = DateTime(event.year, event.month, event.day);

    if (eventDateOnly.isBefore(todayDate)) {
      return 'Past';
    } else if (eventDateOnly.isAtSameMomentAs(todayDate)) {
      return 'Current';
    } else {
      return 'Upcoming';
    }
  }
  /// Update an existing event
  Future<void> updateEvent({
    required String id,
    required String name,
    required String date,
    required String location,
    String? description,
  }) async {
    final Event event = Event(
      id: id,
      name: name,
      date: date,
      location: location,
      description: description ?? '',
      userId: '', // Not required for updating
    );

    await event.updateEvent(
      id: id,
      name: name,
      date: date,
      location: location,
      description: description,
    );
  }
  Future<void> deleteEvent(String eventId) async {
    final Event event = Event(
      id: '', // Dummy ID, not required for fetching events
      name: '',
      date: '',
      location: '',
      userId: '',
    );
    await event.deleteEvent(eventId);
  }
  /// Sort events alphabetically by name
  List<Map<String, dynamic>> sortEventsByName(List<Map<String, dynamic>> events) {
    final modifiableEvents = List<Map<String, dynamic>>.from(events); // Make a mutable copy
    modifiableEvents.sort((a, b) => a['name'].toString().compareTo(b['name'].toString()));
    return modifiableEvents;
  }

  /// Sort events by status: Past -> Current -> Upcoming
  List<Map<String, dynamic>> sortEventsByStatus(List<Map<String, dynamic>> events) {
    final modifiableEvents = List<Map<String, dynamic>>.from(events);
    modifiableEvents.sort((a, b) {
      final String statusA = getEventStatus(a['date']);
      final String statusB = getEventStatus(b['date']);
      return _statusOrder(statusA).compareTo(_statusOrder(statusB));
    });
    return modifiableEvents;
  }
  /// Helper function to define status order
  int _statusOrder(String status) {
    switch (status) {
      case 'Past':
        return 0;
      case 'Current':
        return 1;
      case 'Upcoming':
        return 2;
      default:
        return 3;
    }
  }


// Publish a specific event and its associated gifts to Firestore
  Future<void> publishGiftList(String eventID) async {
    try {
      // Step 1: Fetch the specific event from the local database using eventID
      final Event eventModel = Event(
        id: '',
        name: '',
        date: '',
        location: '',
        userId: '',
      );

      final Map<String, dynamic> localEvent = await eventModel.getEventById(eventID);

      if (localEvent.isEmpty) {
        print('No event found with the specified ID.');
        return;
      }

      // Step 2: Upload the event to Firestore
      final DocumentReference eventDocRef = _firestore.collection('Events').doc(localEvent['id']);
      await eventDocRef.set({
        'id': localEvent['id'],
        'name': localEvent['name'],
        'date': localEvent['date'],
        'location': localEvent['location'],
        'description': localEvent['description'] ?? '',
        'userId': localEvent['user_id'],
        'publishedAt': FieldValue.serverTimestamp(),
      });

      print('Event uploaded successfully.');

      // Step 3: Fetch associated gifts for the event
      final Gift giftModel = Gift(
        id: '',
        name: '',
        description: '',
        category: '',
        price: 0.0,
        status: '',
        eventId: eventID,
        pledgedBy: '',
      );

      final List<Map<String, dynamic>> gifts = await giftModel.getGiftsForEvent(eventID);

      // Step 4: Upload each gift to Firestore under the event's document
      for (var gift in gifts) {
        await eventDocRef.collection('Gifts').doc(gift['id']).set({
          'id': gift['id'],
          'name': gift['name'],
          'description': gift['description'] ?? '',
          'category': gift['category'],
          'price': gift['price'],
          'status': gift['status'],
          'pledgedBy': gift['pledged_by'] ?? '',
          'uploadedAt': FieldValue.serverTimestamp(),
        });
      }

      print('All gifts associated with the event have been uploaded successfully.');
    } catch (e) {
      print('Error publishing gift list: $e');
    }



  }
  /// Fetch events for a specific friend from Firestore
  Future<List<Event>> fetchEventsForFriend(String friendId) async {
    final Event eventModel = Event(
      id: '',
      name: '',
      date: '',
      location: '',
      userId: '',
    );

    return await eventModel.fetchEventsFromFirestoreByUserId(friendId);
  }

}
