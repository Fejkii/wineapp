import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStatehanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithGoogle() async {

  }
}
