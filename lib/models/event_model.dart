import '../services/myDatabase.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Event {
  final String id; // Firestore document ID
  final String name;
  final String date;
  final String location;
  final String description;
  final String userId; // Foreign key for User

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    this.description = '',
    required this.userId,
  });
  final myDatabaseClass _db = myDatabaseClass();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Convert Firestore document to Event model
  factory Event.fromFirestore(Map<String, dynamic> data, String id) {
    return Event(
      id: id,
      name: data['name'] ?? '',
      date: data['date'] ?? '',
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      userId: data['user_id'] ?? '',
    );
  }

  // Convert SQLite row to Event model
  factory Event.fromLocalDB(Map<String, dynamic> data) {
    return Event(
      id: data['id'].toString(),
      name: data['name'],
      date: data['date'],
      location: data['location'],
      description: data['description'] ?? '',
      userId: data['user_id'].toString(),
    );
  }

  // Convert Event model to SQLite insertable map
  Map<String, dynamic> toLocalDB() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'location': location,
      'description': description,
      'user_id': userId,
    };
  }


  Future<void> addEvent({
    required String name,
    required String date,
    required String location,
    String? description,
    required String userId,
  }) async {
    //final String eventId = const Uuid().v4(); // Generate unique event ID

    String sql = '''
      INSERT INTO Events (id, name, date, location, description, user_id) 
      VALUES ('$id', '$name', '$date', '$location', '$description', '$userId')
    ''';

    try {
      await _db.insertData(sql);
      print('Event added successfully!');
    } catch (e) {
      print('Error adding event: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getEvents(String userId) async {
    String sql = '''
      SELECT * FROM Events WHERE user_id = '$userId'
    ''';
    return await _db.readData(sql);
  }

  Future<void> updateEvent({
    required String id,
    required String name,
    required String date,
    required String location,
    String? description,
  }) async {
    String sql = '''
    UPDATE Events 
    SET name = '$name', date = '$date', location = '$location', description = '${description ?? ''}' 
    WHERE id = '$id'
  ''';

    try {
      await _db.updateData(sql);
      print('Event updated successfully!');
    } catch (e) {
      print('Error updating event: $e');
    }
  }
  // Fetch a specific event by its ID
  Future<Map<String, dynamic>> getEventById(String eventId) async {
    String sql = '''
      SELECT * FROM Events WHERE id = '$eventId'
    ''';

    try {
      final List<Map<String, dynamic>> result = await _db.readData(sql);

      if (result.isNotEmpty) {
        return result.first; // Return the first matching event
      } else {
        return {}; // Return an empty map if no event is found
      }
    } catch (e) {
      print('Error fetching event by ID: $e');
      return {};
    }
  }
  Future<void> deleteEvent(String eventId) async {
    String sql = "DELETE FROM Events WHERE id = '$eventId'";
    try {
      await _db.deleteData(sql);
      print('Event deleted successfully!');
    } catch (e) {
      print('Error deleting event: $e');
    }
  }
  // Fetch events associated with a specific userId from Firestore
  Future<List<Event>> fetchEventsFromFirestoreByUserId(String userId) async {
    try {
      QuerySnapshot eventSnapshot = await _firestore
          .collection('Events')
          .where('userId', isEqualTo: userId)
          .get();

      return eventSnapshot.docs.map((doc) {
        return Event.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching events from Firestore: $e');
      return [];
    }
  }
}
