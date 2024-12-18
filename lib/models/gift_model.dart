import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/myDatabase.dart';
class Gift {
  final String id; // Firestore document ID
  final String name;
  final String description;
  final String category;
  final double price;
  final String status;
  final String eventId; // Foreign key for Event
  final String pledgedBy; // Foreign key for User
  final String imagePath; // Default image path for gifts


  Gift({
    required this.id,
    required this.name,
    this.description = '',
    this.category = '',
    this.price = 0.0,
    this.status = '',
    required this.eventId,
    required this.pledgedBy,
    this.imagePath = 'assets/images/default_gift.png', // Default image path

  });
  final myDatabaseClass _db = myDatabaseClass();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Convert Firestore document to Gift model
  factory Gift.fromFirestore(Map<String, dynamic> data, String id) {
    return Gift(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      status: data['status'] ?? '',
      eventId: data['event_id'] ?? '',
      pledgedBy: data['pledged_by'] ?? '',
    );
  }

  // Convert SQLite row to Gift model
  factory Gift.fromLocalDB(Map<String, dynamic> data) {
    return Gift(
      id: data['id'].toString(),
      name: data['name'],
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      price: data['price'].toDouble(),
      status: data['status'] ?? '',
      eventId: data['event_id'].toString(),
      pledgedBy: data['pledged_by'].toString(),
      imagePath: 'assets/images/default_gift.png', // Always use the default path
    );
  }

  // Convert Gift model to SQLite insertable map
  Map<String, dynamic> toLocalDB() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'status': status,
      'event_id': eventId,
      'pledged_by': pledgedBy,
    };
  }
  // Fetch gifts for a specific event from the database
  Future<List<Map<String, dynamic>>> getGiftsForEvent(String eventId) async {
    String sql = '''
      SELECT * FROM Gifts WHERE event_id = '$eventId'
    ''';

    try {
      final List<Map<String, dynamic>> result = await _db.readData(sql);
      return result;
    } catch (e) {
      print('Error fetching gifts for event: $e');
      return [];
    }
  }
  Future<List<String>> fetchCategories() async {
    final String sql = 'SELECT name FROM Categories';
    final List<Map<String, dynamic>> result = await _db.readData(sql);

    return result.map((row) => row['name'] as String).toList();
  }


  /// Insert a new gift into the database
  Future<void> insertGift({
    required String id,
    required String name,
    required String description,
    required String category,
    required double price,
    required String status,
    required String eventId,
    String? pledgedBy,
  }) async {
    String sql = '''
      INSERT INTO Gifts (id, name, description, category, price, status, event_id, pledged_by)
      VALUES ('$id', '$name', '$description', '$category', $price, '$status', '$eventId', '${pledgedBy ?? ''}')
    ''';

    await _db.insertData(sql);
  }
  /// Delete a gift by ID
  Future<void> deleteGift(String giftId) async {
    String sql = '''
      DELETE FROM Gifts WHERE id = '$giftId'
    ''';
    await _db.deleteData(sql);
  }
  /// Update a gift by ID
  Future<void> updateGift({
    required String id,
    required String name,
    required String description,
    required String category,
    required double price,
    required String status,
  }) async {
    String sql = '''
      UPDATE Gifts
      SET name = '$name',
          description = '$description',
          category = '$category',
          price = $price,
          status = '$status'
      WHERE id = '$id'
    ''';

    await _db.updateData(sql);
  }
  // Fetch gifts for a specific event from Firestore
  Future<List<Map<String, dynamic>>> getGiftsByEventId(String eventId) async {
    try {
      // Query the local database for all gifts associated with the given eventId
      String sql = "SELECT * FROM Gifts WHERE event_id = '$eventId'";
      final List<Map<String, dynamic>> result = await _db.readData(sql);
      return result;
    } catch (e) {
      print('Error fetching gifts for event ID $eventId: $e');
      return [];
    }
  }
  Future<List<Map<String, dynamic>>> fetchGiftsFromFirestore(String eventId) async {
    try {
      // Access the subcollection 'Gifts' within a specific Event document
      final QuerySnapshot snapshot = await _firestore
          .collection('Events') // Parent collection
          .doc(eventId) // Specific event document
          .collection('Gifts') // Subcollection 'Gifts'
          .get();

      // Convert each Firestore document to a Map
      return snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>; // Cast document data to Map
      }).toList();
    } catch (e) {
      print('Error fetching gifts from Firestore for event ID $eventId: $e');
      return [];
    }
  }



}
