
class User {
  final String id; // Firestore UID
  final String name;
  final String email;
  final String phoneNumber;
  final String preferences;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.preferences = '',
  });

  // Convert Firestore document to User model
  factory User.fromFirestore(Map<String, dynamic> data, String id) {
    return User(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber : data['phoneNumber']??'',
      preferences: data['preferences'] ?? '',
    );
  }

  // Convert SQLite row to User model
  factory User.fromLocalDB(Map<String, dynamic> data) {
    return User(
      id: data['id'].toString(),
      name: data['name'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      preferences: data['preferences'],
    );
  }

  // Convert User model to SQLite insertable map
  Map<String, dynamic> toLocalDB() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'preferences': preferences,
    };
  }
}
