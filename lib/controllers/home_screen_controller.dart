import '../models/home_model.dart';

class HomeScreenController {
  static String? id; // Static variable to store the user ID
  final HomeModel _model = HomeModel();

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
}

