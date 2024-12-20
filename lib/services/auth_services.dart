import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Login Error: $e');
      return null;
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Return the created user
    } catch (e) {
      print('AuthService - Signup Error: $e');
      return null;
    }
  }
  String? getCurrentUserId() {
    User? user = _auth.currentUser;
    return user?.uid; // Returns the user's UID or null if not logged in
  }
}
