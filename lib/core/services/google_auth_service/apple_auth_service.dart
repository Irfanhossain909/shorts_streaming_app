import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:testemu/core/services/google_auth_service/user_model.dart';

class AppleWebAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  GoogleUserModel? userData;

  Future<GoogleUserModel?> signIn() async {
    try {
      final AppleAuthProvider appleProvider = AppleAuthProvider();
      appleProvider.addScope('email');
      appleProvider.addScope('name');

      // ✅ Android + iOS + Release mode সব জায়গায় কাজ করে
      final UserCredential userCredential =
          await _firebaseAuth.signInWithProvider(appleProvider);

      final User firebaseUser = userCredential.user!;
      final String? firebaseIdToken = await firebaseUser.getIdToken(true);
      final String? fcmToken = await _firebaseMessaging.getToken();

      if (firebaseIdToken == null) throw Exception("Firebase ID Token is null");

      userData = GoogleUserModel(
        userId: firebaseUser.uid,
        name: firebaseUser.displayName ?? "",
        email: firebaseUser.email ?? "",
        photo: firebaseUser.photoURL ?? "",
        googleIdToken: firebaseIdToken,
        firebaseIdToken: firebaseIdToken,
        fcmToken: fcmToken ?? "",
      );

      log("Apple WebView Sign In Success: ${firebaseUser.email}");
      return userData;
    } catch (e, s) {
      log("Apple WebView SignIn Error", error: e, stackTrace: s);
      return null;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    userData = null;
  }
}


