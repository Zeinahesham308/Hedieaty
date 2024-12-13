class Gift {
  final String id; // Firestore document ID
  final String name;
  final String description;
  final String category;
  final double price;
  final String status;
  final String eventId; // Foreign key for Event
  final String pledgedBy; // Foreign key for User

  Gift({
    required this.id,
    required this.name,
    this.description = '',
    this.category = '',
    this.price = 0.0,
    this.status = '',
    required this.eventId,
    required this.pledgedBy,
  });

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
}
