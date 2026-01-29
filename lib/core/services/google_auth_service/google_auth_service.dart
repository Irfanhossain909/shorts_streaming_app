import 'dart:developer';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:testemu/core/services/google_auth_service/user_model.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  /// Store signed-in user
  GoogleUserModel? userData;

  /// Initialize Google Sign-In
  Future<void> initialize() async {
    // await DeviceInfoService().printDeviceInfo();

    // final String webClientId = dotenv.get('WEB_CLIENT_ID');    
    final String webClientId = "651738200724-c4ugcdsr08lit3lhsnp177l04md7o4gi.apps.googleusercontent.com";
    await _googleSignIn.initialize(serverClientId: webClientId);

    log("GoogleSignIn initialized with WEB_CLIENT_ID");
  }

  /// Google Sign In
  Future<bool> signIn() async {
    try {
      /// 🔴 FORCE SIGN OUT BEFORE SIGN IN
      await _googleSignIn.signOut();
      // optional but stronger:
      // await _googleSignIn.disconnect();

      log("Previous Google session cleared");

      /// 🔐 Start fresh sign in
      final GoogleSignInAccount user = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication auth = user.authentication;

      final String? idToken = auth.idToken;

      userData = GoogleUserModel(
        userId: user.id,
        name: user.displayName ?? "",
        email: user.email,
        photo: user.photoUrl ?? "",
        idToken: idToken ?? "",
      );

      log("========== GOOGLE SIGN IN SUCCESS ==========");
      log("User ID  : ${userData!.userId}");
      log("Email    : ${userData!.email}");
      log("Name     : ${userData!.name}");
      log("Photo    : ${userData!.photo}");
      log("ID Token : ${userData!.idToken}");
      log("===========================================");

      return true;
    } catch (e, s) {
      log("Google SignIn Error", error: e, stackTrace: s);
      return false;
    }
  }

  /// Google Sign Out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    userData = null;
    log("Google Sign Out Successful");
  }
}
