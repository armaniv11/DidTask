import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future signinEmailandPass(String email, String password) async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = authResult.user;
      return firebaseUser;
    } catch (e) {
      print(e.toString());
    }
  }

  Future signupwithEmailandPass(String email, String password) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = authResult.user;

      return firebaseUser;
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
