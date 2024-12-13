import '../services/myDatabase.dart';
class HomeModel {
  final myDatabaseClass _localDb = myDatabaseClass();

  Future<String?> getWelcomeName(String userId) async {
    try {
      // Query the database to get the user's name
      List<Map<String, dynamic>> result = await _localDb.readData(
        'SELECT name FROM Users WHERE id = ?',
        [userId],
      );

      if (result.isNotEmpty) {
        return result[0]['name'];
      }
      return null; // No user found
    } catch (e) {
      print('Error fetching welcome name: $e');
      return null;
    }
  }
  remoteFetchFriendList()
  {

  }

}