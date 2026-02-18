import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:testemu/core/services/google_auth_service/user_model.dart';

class AppleAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Store signed-in user
  GoogleUserModel? userData;

  /// 🚀 Initialize (optional – future use)
  Future<void> initialize() async {
    if (!Platform.isIOS) {
      throw Exception("Apple Sign-In is only supported on iOS");
    }
    log("AppleAuthService initialized");
  }

  /// 🔐 Apple Sign In + Firebase Auth + Tokens
  Future<GoogleUserModel?> signIn() async {
    try {
      if (!Platform.isIOS) {
        throw Exception("Apple Sign-In only works on iOS");
      }

      /// 🍎 STEP 1: Apple ID Credential
      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final String? appleIdentityToken = appleCredential.identityToken;
      final String? appleAuthCode = appleCredential.authorizationCode;

      if (appleIdentityToken == null) {
        throw Exception("Apple identity token is null");
      }

      /// 🔑 STEP 2: Apple → Firebase credential
      final OAuthCredential credential = OAuthProvider("apple.com").credential(
        idToken: appleIdentityToken,
        accessToken: appleAuthCode,
      );

      /// 🔥 STEP 3: Firebase Sign-In
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final User firebaseUser = userCredential.user!;

      /// 🔑 STEP 4: Firebase ID Token (Backend Token)
      final String? firebaseIdToken =
          await firebaseUser.getIdToken(true);

      if (firebaseIdToken == null) {
        throw Exception("Firebase ID Token is null");
      }

      /// 📲 STEP 5: FCM Token
      final String? fcmToken = await _firebaseMessaging.getToken();

      /// 📦 STEP 6: Map user data
      userData = GoogleUserModel(
        userId: firebaseUser.uid,
        name:
            "${appleCredential.givenName ?? ""} ${appleCredential.familyName ?? ""}"
                .trim(),
        email: firebaseUser.email ?? "",
        googleIdToken: appleIdentityToken,
        photo: firebaseUser.photoURL ?? "",
        firebaseIdToken: firebaseIdToken,
        fcmToken: fcmToken ?? "",
      );

      /// 🔍 DEBUG LOGS
      log("========== APPLE AUTH TOKEN DETAILS ==========");
      log("UID               : ${firebaseUser.uid}");
      log("Email             : ${firebaseUser.email}");
      log("Name              : ${userData!.name}");
      log("Apple ID Token    : $appleIdentityToken");
      log("Firebase ID Token : $firebaseIdToken");
      log("FCM Token         : $fcmToken");
      log("============================================");

      return userData;
    } catch (e, s) {
      log("Apple/Firebase SignIn Error", error: e, stackTrace: s);
      return null;
    }
  }

  /// 🚪 Apple + Firebase Sign Out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    userData = null;

    log("Apple & Firebase Sign Out Successful");
  }
}
