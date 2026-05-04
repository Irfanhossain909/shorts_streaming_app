import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/route/app_routes.dart';
import '../../utils/enum/enum.dart';
import '../../utils/log/app_log.dart';
import 'storage_keys.dart';

class LocalStorage {
  static String token = "";
  static String refreshToken = "";
  static String fcmToken = "";
  static bool isLogIn = false;
  static String userId = "";
  static String myImage = "";
  static String myName = "";
  static String myEmail = "";
  static UserRole userRole = UserRole.jobSeeker;
  static bool isSubscribed = false;
  static bool isGuest = false;
  static String deviceId = "";
  static String deviceType = "";
  // Create Local Storage Instance
  static SharedPreferences? preferences;

  /// Get SharedPreferences Instance
  static Future<SharedPreferences> _getStorage() async {
    preferences ??= await SharedPreferences.getInstance();
    return preferences!;
  }

  /// Get All Data From SharedPreferences
  static Future<void> getAllPrefData() async {
    final localStorage = await _getStorage();

    token = localStorage.getString(LocalStorageKeys.token) ?? "";
    refreshToken = localStorage.getString(LocalStorageKeys.refreshToken) ?? "";
    fcmToken = localStorage.getString(LocalStorageKeys.fcmToken) ?? "";
    deviceId = localStorage.getString(LocalStorageKeys.deviceId) ?? "";
    deviceType = localStorage.getString(LocalStorageKeys.deviceType) ?? "";
    isLogIn = localStorage.getBool(LocalStorageKeys.isLogIn) ?? false;
    userId = localStorage.getString(LocalStorageKeys.userId) ?? "";
    myImage = localStorage.getString(LocalStorageKeys.myImage) ?? "";
    myName = localStorage.getString(LocalStorageKeys.myName) ?? "";
    myEmail = localStorage.getString(LocalStorageKeys.myEmail) ?? "";

    isSubscribed =
        localStorage.getBool(LocalStorageKeys.isSubscribed) ?? false;
    isGuest = localStorage.getBool(LocalStorageKeys.isGuest) ?? false;

    // Handle user role with fallback to jobSeeker
    String roleString =
        localStorage.getString(LocalStorageKeys.userRole) ?? "jobSeeker";
    userRole = roleString == "employer"
        ? UserRole.employer
        : UserRole.jobSeeker;

    appLog(userId, source: "Local Storage");
  }

  /// Remove All Data From SharedPreferences (full logout)
  static Future<void> removeAllPrefData() async {
    final localStorage = await _getStorage();
    await localStorage.clear();
    _resetLocalStorageData();
    Get.offAllNamed(AppRoutes.signIn);
    await getAllPrefData();
  }

  /// Clears JWT/session fields so guest API calls do not send stale tokens.
  /// Does not clear device prefs or guest flag (caller sets guest after this).
  static Future<void> clearAuthSessionForGuest() async {
    final localStorage = await _getStorage();
    await localStorage.setString(LocalStorageKeys.token, "");
    await localStorage.setString(LocalStorageKeys.refreshToken, "");
    await localStorage.setBool(LocalStorageKeys.isLogIn, false);
    await localStorage.setString(LocalStorageKeys.userId, "");
    await localStorage.setString(LocalStorageKeys.myImage, "");
    await localStorage.setString(LocalStorageKeys.myName, "");
    await localStorage.setString(LocalStorageKeys.myEmail, "");
    token = "";
    refreshToken = "";
    isLogIn = false;
    userId = "";
    myImage = "";
    myName = "";
    myEmail = "";
  }

  /// Exit guest mode and go back to sign-in screen
  static Future<void> exitGuestMode() async {
    final localStorage = await _getStorage();
    await localStorage.setBool(LocalStorageKeys.isGuest, false);
    isGuest = false;
    Get.offAllNamed(AppRoutes.signIn);
  }

  // Reset LocalStorage Data
  static void _resetLocalStorageData() {
    if (preferences != null) {
      preferences!.setString(LocalStorageKeys.token, "");
      preferences!.setString(LocalStorageKeys.refreshToken, "");
      preferences!.setString(LocalStorageKeys.fcmToken, "");
      preferences!.setString(LocalStorageKeys.deviceId, "");
      preferences!.setString(LocalStorageKeys.deviceType, "");
      preferences!.setString(LocalStorageKeys.userId, "");
      preferences!.setString(LocalStorageKeys.myImage, "");
      preferences!.setString(LocalStorageKeys.myName, "");
      preferences!.setString(LocalStorageKeys.myEmail, "");
      preferences!.setString(LocalStorageKeys.userRole, "jobSeeker");
      preferences!.setBool(LocalStorageKeys.isLogIn, false);
      preferences!.setBool(LocalStorageKeys.isSubscribed, false);
      preferences!.setBool(LocalStorageKeys.isGuest, false);
    }
  }

  // Save Data To SharedPreferences
  static Future<void> setString(String key, String value) async {
    final localStorage = await _getStorage();
    await localStorage.setString(key, value);

    // Update static variables immediately after saving
    if (key == LocalStorageKeys.token) {
      token = value;
    } else if (key == LocalStorageKeys.refreshToken) {
      refreshToken = value;
    } else if (key == LocalStorageKeys.fcmToken) {
      fcmToken = value;
    } else if (key == LocalStorageKeys.deviceId) {
      deviceId = value;
    } else if (key == LocalStorageKeys.deviceType) {
      deviceType = value;
    } else if (key == LocalStorageKeys.userId) {
      userId = value;
    } else if (key == LocalStorageKeys.myImage) {
      myImage = value;
    } else if (key == LocalStorageKeys.myName) {
      myName = value;
    } else if (key == LocalStorageKeys.myEmail) {
      myEmail = value;
    } else if (key == LocalStorageKeys.userRole) {
      userRole = value == "employer" ? UserRole.employer : UserRole.jobSeeker;
    }
  }

  static Future<void> setBool(String key, bool value) async {
    final localStorage = await _getStorage();
    await localStorage.setBool(key, value);

    // Update static variables immediately after saving
    if (key == LocalStorageKeys.isLogIn) {
      isLogIn = value;
    } else if (key == LocalStorageKeys.isSubscribed) {
      isSubscribed = value;
    } else if (key == LocalStorageKeys.isGuest) {
      isGuest = value;
    }
  }

  static Future<void> setInt(String key, int value) async {
    final localStorage = await _getStorage();
    await localStorage.setInt(key, value);
  }
}
