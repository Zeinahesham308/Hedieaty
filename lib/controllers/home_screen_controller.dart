import '../models/home_model.dart';
import '../models/friend_model.dart';

class HomeScreenController {
  static String? id; // Static variable to store the user ID
  late String F_id;
  final HomeModel _model = HomeModel();
  //late Friend _Fmodel;

  // Set the user ID
  static void setUserId(String userId) {
    id = userId;
  }

  // Get the user ID
  static String? getUserId() {
    return id;
  }

  // Fetch the welcome name from the model
  Future<String?> getWelcomeName() async {
    if (id == null) {
      throw Exception('User ID is not set!');
    }

    // Delegate to the model to fetch the welcome name
    return await _model.getWelcomeName(id!);
  }

  Future<List<Map<String, dynamic>>> fetchFriendsFromFriendsModel(String userId) async {
    return _model.fetchFriends(userId);
  }




}

