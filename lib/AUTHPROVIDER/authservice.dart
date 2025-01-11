import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream to listen for auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      UserCredential userCredential = await _auth.signInWithProvider(googleProvider);
      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}