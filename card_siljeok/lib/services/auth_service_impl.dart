// Mobile implementation of AuthService
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsi;

class AuthService {
  final LocalAuthentication _auth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
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
      final gsi.GoogleSignInAccount googleUser = await gsi.GoogleSignIn.instance.authenticate();
      final gsi.GoogleSignInAuthentication googleAuth = googleUser.authentication;
      
      // Request access token
      final authClient = googleUser.authorizationClient;
      final authz = await authClient.authorizeScopes(['email', 'profile']);

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authz.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await gsi.GoogleSignIn.instance.signOut();
  }

  Future<bool> isDeviceSupported() async {
    // Mobile devices: use plugin
    return await _auth.isDeviceSupported();
  }

  Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticate() async {
    if (!await hasBiometrics()) return false;
    try {
      return await _auth.authenticate(
        localizedReason: '지문 인증을 사용합니다.',
        biometricOnly: true,
      );
    } catch (_) {
      return false;
    }
  }

  Future<void> storePin(String pin) async {
    await _secureStorage.write(key: 'user_pin', value: pin);
  }

  Future<String?> getStoredPin() async {
    return await _secureStorage.read(key: 'user_pin');
  }

  Future<bool> verifyPin(String entered) async {
    final stored = await getStoredPin();
    if (stored == null) {
      await storePin(entered);
      return true;
    }
    return stored == entered;
  }

  Future<bool> hasStoredPin() async {
    final pin = await getStoredPin();
    return pin != null;
  }
}
