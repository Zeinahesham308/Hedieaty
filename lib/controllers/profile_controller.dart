import '../models/profile_model.dart';

class ProfileController {
  final ProfileModel _profileModel;

  ProfileController(String userId) : _profileModel = ProfileModel(userId);

  /// Fetch the user's name
  Future<String?> getUserName() async {
    try {
      final userName = await _profileModel.getUserName();
      if (userName != null) {
        print('Fetched user name: $userName');
      } else {
        print('User name not found for ID: ${_profileModel.userId}');
      }
      return userName;
    } catch (e) {
      print('Error fetching user name: $e');
      return null;
    }
  }

  /// Clear the local user data
  Future<void> clearLocalUserData() async {
    try {
      await _profileModel.clearLocalUserData();
      print('Local user data cleared successfully!');
    } catch (e) {
      print('Error clearing local user data: $e');
    }
  }
}
