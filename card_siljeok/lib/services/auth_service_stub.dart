// Web stub for AuthService (No local_auth)
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      return null;
    }
  }

  Future<UserCredential?> signUpWithEmail(String email, String password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      return null;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      return await _firebaseAuth.signInWithPopup(GoogleAuthProvider());
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<bool> isDeviceSupported() async => true;
  Future<bool> hasBiometrics() async => false;
  Future<bool> authenticate() async => true;
  Future<void> storePin(String pin) async {}
  Future<String?> getStoredPin() async => null;
  Future<bool> verifyPin(String entered) async => true;
  Future<bool> hasStoredPin() async => false;
}

