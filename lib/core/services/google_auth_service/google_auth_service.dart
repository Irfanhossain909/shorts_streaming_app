import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:testemu/core/services/google_auth_service/user_model.dart';

class GoogleWebAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  GoogleUserModel? userData;

  Future<GoogleUserModel?> signIn() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.addScope('email');
      googleProvider.addScope('profile');
      googleProvider.setCustomParameters({'prompt': 'select_account'});

      // ✅ এটা WebView popup দিয়ে sign in করবে — release mode এ কাজ করে
      final UserCredential userCredential =
          await _firebaseAuth.signInWithProvider(googleProvider);

      final User firebaseUser = userCredential.user!;
      final String? firebaseIdToken = await firebaseUser.getIdToken(true);
      final String? fcmToken = await _firebaseMessaging.getToken();

      if (firebaseIdToken == null) throw Exception("Firebase ID Token is null");

      userData = GoogleUserModel(
        userId: firebaseUser.uid,
        name: firebaseUser.displayName ?? "",
        email: firebaseUser.email ?? "",
        photo: firebaseUser.photoURL ?? "",
        googleIdToken: firebaseIdToken, // এখানে firebase token দিচ্ছি
        firebaseIdToken: firebaseIdToken,
        fcmToken: fcmToken ?? "",
      );

      log("Google WebView Sign In Success: ${firebaseUser.email}");
      return userData;
    } catch (e, s) {
      log("Google WebView SignIn Error", error: e, stackTrace: s);
      return null;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    userData = null;
  }
}

