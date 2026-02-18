import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:testemu/core/services/google_auth_service/user_model.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Store signed-in user
  GoogleUserModel? userData;

  /// 🔑 Get correct client ID based on device
  String getServerClientId() {
    if (kIsWeb) {
      throw Exception("Google Sign-In not configured for Web");
    }

    if (Platform.isAndroid) {
      // ✅ Web Client ID (Android)
      return "651738200724-c4ugcdsr08lit3lhsnp177l04md7o4gi.apps.googleusercontent.com";
    }

    if (Platform.isIOS) {
      // ✅ iOS Client ID
      return "651738200724-olnoilujpcoindod17ut3e82hbma48pb.apps.googleusercontent.com";
    }

    throw Exception("Unsupported platform");
  }

  /// 🚀 Initialize Google Sign-In
  Future<void> initialize() async {
    final String serverClientId = getServerClientId();

    await _googleSignIn.initialize(serverClientId: serverClientId);

    log("GoogleSignIn initialized");
    log("Platform Client ID: $serverClientId");
  }

  /// 🔐 Google Sign In + Firebase Auth + Tokens
  Future<GoogleUserModel?> signIn() async {
    try {
      /// 🔴 Clear previous Google session
      await _googleSignIn.signOut();
      log("Previous Google session cleared");

      /// 🔐 Start Google Sign-In
      final GoogleSignInAccount googleUser =
          await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      /// 🔑 GOOGLE ID TOKEN (Token #1)
      final String? googleIdToken = googleAuth.idToken;

      if (googleIdToken == null) {
        throw Exception("Google ID Token is null");
      }

      /// 🔑 Create Firebase credential (Google → Firebase)
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleIdToken,
      );

      /// 🔥 Firebase Sign-In
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final User firebaseUser = userCredential.user!;

      /// 🔑 FIREBASE ID TOKEN (Token #2 – BACKEND TOKEN)
      final String? firebaseIdToken =
          await firebaseUser.getIdToken(true);

      if (firebaseIdToken == null) {
        throw Exception("Firebase ID Token is null");
      }

      /// 📲 FCM TOKEN (Token #3)
      final String? fcmToken = await _firebaseMessaging.getToken();

      /// 📦 Map user data
      userData = GoogleUserModel(
        userId: firebaseUser.uid,
        name: firebaseUser.displayName ?? "",
        email: firebaseUser.email ?? "",
        photo: firebaseUser.photoURL ?? "",
        googleIdToken: googleIdToken,
        firebaseIdToken: firebaseIdToken,
        fcmToken: fcmToken ?? "",
      );

      /// 🔍 CLEAR DEBUG LOGS
      log("========== AUTH TOKEN DETAILS ==========");
      log("UID               : ${firebaseUser.uid}");
      log("Email             : ${firebaseUser.email}");
      log("Name              : ${firebaseUser.displayName}");
      log("Google ID Token   : $googleIdToken");
      log("Firebase ID Token : $firebaseIdToken");
      log("FCM Token         : $fcmToken");
      log("=======================================");

      return userData;
    } catch (e, s) {
      log("Google/Firebase SignIn Error", error: e, stackTrace: s);
      return null;
    }
  }

  /// 🚪 Google + Firebase Sign Out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    userData = null;

    log("Google & Firebase Sign Out Successful");
  }
}




// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:testemu/core/services/google_auth_service/user_model.dart';

// class GoogleAuthService {
//   final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   /// Store signed-in user
//   GoogleUserModel? userData;

//   /// 🔑 Get correct client ID based on device
//   String getServerClientId() {
//     if (kIsWeb) {
//       throw Exception("Google Sign-In not configured for Web");
//     }

//     if (Platform.isAndroid) {
//       // ✅ Web Client ID (Android)
//       return "651738200724-c4ugcdsr08lit3lhsnp177l04md7o4gi.apps.googleusercontent.com";
//     }

//     if (Platform.isIOS) {
//       // ✅ iOS Client ID
//       return "651738200724-olnoilujpcoindod17ut3e82hbma48pb.apps.googleusercontent.com";
//     }

//     throw Exception("Unsupported platform");
//   }

//   /// 🚀 Initialize Google Sign-In
//   Future<void> initialize() async {
//     final String serverClientId = getServerClientId();

//     await _googleSignIn.initialize(
//       serverClientId: serverClientId,
//     );

//     log("GoogleSignIn initialized");
//     log("Platform Client ID: $serverClientId");
//   }

//   /// 🔐 Google Sign In + Firebase Auth + Tokens
//   Future<GoogleUserModel?> signIn() async {
//     try {
//       /// 🔴 Clear previous Google session
//       await _googleSignIn.signOut();
//       log("Previous Google session cleared");

//       /// 🔐 Start Google Sign-In
//       final GoogleSignInAccount googleUser =
//           await _googleSignIn.authenticate();

//       final GoogleSignInAuthentication googleAuth =
//           googleUser.authentication;

//       /// 🔑 Create Firebase credential (Google → Firebase)
//       final OAuthCredential credential = GoogleAuthProvider.credential(
//         idToken: googleAuth.idToken,
//       );

//       /// 🔥 Firebase Sign-In
//       final UserCredential userCredential =
//           await _firebaseAuth.signInWithCredential(credential);

//       final User firebaseUser = userCredential.user!;

//       /// 🔐 Firebase ID Token (🔥 BACKEND TOKEN)
//       final String? firebaseIdToken =
//           await firebaseUser.getIdToken(true);

//       /// 📲 FCM Token (Push Notification)
//       final String? fcmToken = await _firebaseMessaging.getToken();

//       /// 📦 Map user data (frontend use)
//       userData = GoogleUserModel(
//         userId: firebaseUser.uid,
//         name: firebaseUser.displayName ?? "",
//         email: firebaseUser.email ?? "",
//         photo: firebaseUser.photoURL ?? "",
//         idToken: firebaseIdToken ?? "", // ✅ Firebase ID Token
//         // You can add fcmToken in model if needed
//       );

//       /// ✅ Logs (debug only)
//       log("========== GOOGLE + FIREBASE SIGN IN SUCCESS ==========");
//       log("UID              : ${firebaseUser.uid}");
//       log("Email            : ${firebaseUser.email}");
//       log("Name             : ${firebaseUser.displayName}");
//       log("Photo            : ${firebaseUser.photoURL}");
//       log("Firebase IDToken : $firebaseIdToken");
//       log("FCM Token        : $fcmToken");
//       log("======================================================");

//       return userData;
//     } catch (e, s) {
//       log("Google/Firebase SignIn Error", error: e, stackTrace: s);
//       return null;
//     }
//   }

//   /// 🚪 Google + Firebase Sign Out
//   Future<void> signOut() async {
//     await _googleSignIn.signOut();
//     await _firebaseAuth.signOut();
//     userData = null;

//     log("Google & Firebase Sign Out Successful");
//   }
// }



// // import 'dart:developer';
// // import 'dart:io';

// // import 'package:flutter/foundation.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:google_sign_in/google_sign_in.dart';
// // import 'package:testemu/core/services/google_auth_service/user_model.dart';

// // class GoogleAuthService {
// //   final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
// //   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
// //   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

// //   /// Store signed-in user
// //   GoogleUserModel? userData;

// //   /// 🔑 Get correct client ID based on device
// //   String getServerClientId() {
// //     if (kIsWeb) {
// //       throw Exception("Google Sign-In not configured for Web");
// //     }

// //     if (Platform.isAndroid) {
// //       return "651738200724-c4ugcdsr08lit3lhsnp177l04md7o4gi.apps.googleusercontent.com";
// //     }

// //     if (Platform.isIOS) {
// //       return "651738200724-olnoilujpcoindod17ut3e82hbma48pb.apps.googleusercontent.com";
// //     }

// //     throw Exception("Unsupported platform");
// //   }

// //   /// Initialize Google Sign-In
// //   Future<void> initialize() async {
// //     final String serverClientId = getServerClientId();

// //     await _googleSignIn.initialize(
// //       serverClientId: serverClientId,
// //     );

// //     log("GoogleSignIn initialized");
// //     log("Platform Client ID: $serverClientId");
// //   }

// //   /// Google Sign In with Firebase + FCM Token
// //   Future<GoogleUserModel?> signIn() async {
// //     try {
// //       /// 🔴 Clear previous session
// //       await _googleSignIn.signOut();

// //       log("Previous Google session cleared");

// //       /// 🔐 Start Google Sign-In
// //       final GoogleSignInAccount googleUser =
// //           await _googleSignIn.authenticate();

// //       final GoogleSignInAuthentication googleAuth =
// //           googleUser.authentication;

// //       /// 🔑 Create Firebase credential
// //       final OAuthCredential credential = GoogleAuthProvider.credential(
// //         idToken: googleAuth.idToken,
// //       );

// //       /// 🔥 Firebase Sign-In
// //       final UserCredential userCredential =
// //           await _firebaseAuth.signInWithCredential(credential);

// //       final User firebaseUser = userCredential.user!;

// //       /// 📲 Get FCM Token
// //       final String? fcmToken = await _firebaseMessaging.getToken();

// //       /// 📦 Map user data
// //       userData = GoogleUserModel(
// //         userId: firebaseUser.uid,
// //         name: firebaseUser.displayName ?? "",
// //         email: firebaseUser.email ?? "",
// //         photo: firebaseUser.photoURL ?? "",
// //         idToken: googleAuth.idToken ?? "",
// //         // optional: add fcmToken in model if needed
// //       );

// //       log("========== GOOGLE + FIREBASE SIGN IN SUCCESS ==========");
// //       log("UID       : ${userData!.userId}");
// //       log("Email     : ${userData!.email}");
// //       log("Name      : ${userData!.name}");
// //       log("Photo     : ${userData!.photo}");
// //       log("ID Token  : ${userData!.idToken}");
// //       log("FCM Token : $fcmToken");
// //       log("======================================================");

// //       return userData;
// //     } catch (e, s) {
// //       log("Google/Firebase SignIn Error", error: e, stackTrace: s);
// //       return null;
// //     }
// //   }

// //   /// Google + Firebase Sign Out
// //   Future<void> signOut() async {
// //     await _googleSignIn.signOut();
// //     await _firebaseAuth.signOut();
// //     userData = null;

// //     log("Google & Firebase Sign Out Successful");
// //   }
// // }


