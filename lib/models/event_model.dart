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
}
