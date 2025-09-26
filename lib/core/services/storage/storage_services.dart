import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/route/app_routes.dart';
import '../../utils/log/app_log.dart';
import '../../utils/enum/enum.dart';
import 'storage_keys.dart';

class LocalStorage {
  static String token = "";
  static String refreshToken = "";
  static bool isLogIn = false;
  static String userId = "";
  static String myImage = "";
  static String myName = "";
  static String myEmail = "";
  static UserRole userRole = UserRole.jobSeeker;

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
    isLogIn = localStorage.getBool(LocalStorageKeys.isLogIn) ?? false;
    userId = localStorage.getString(LocalStorageKeys.userId) ?? "";
    myImage = localStorage.getString(LocalStorageKeys.myImage) ?? "";
    myName = localStorage.getString(LocalStorageKeys.myName) ?? "";
    myEmail = localStorage.getString(LocalStorageKeys.myEmail) ?? "";

    // Handle user role with fallback to jobSeeker
    String roleString =
        localStorage.getString(LocalStorageKeys.userRole) ?? "jobSeeker";
    userRole = roleString == "employer"
        ? UserRole.employer
        : UserRole.jobSeeker;

    appLog(userId, source: "Local Storage");
  }

  /// Remove All Data From SharedPreferences
  static Future<void> removeAllPrefData() async {
    final localStorage = await _getStorage();
    await localStorage.clear();
    _resetLocalStorageData();
    Get.offAllNamed(AppRoutes.signIn);
    await getAllPrefData();
  }

  // Reset LocalStorage Data
  static void _resetLocalStorageData() {
    if (preferences != null) {
      preferences!.setString(LocalStorageKeys.token, "");
      preferences!.setString(LocalStorageKeys.refreshToken, "");
      preferences!.setString(LocalStorageKeys.userId, "");
      preferences!.setString(LocalStorageKeys.myImage, "");
      preferences!.setString(LocalStorageKeys.myName, "");
      preferences!.setString(LocalStorageKeys.myEmail, "");
      preferences!.setString(LocalStorageKeys.userRole, "jobSeeker");
      preferences!.setBool(LocalStorageKeys.isLogIn, false);
    }
  }

  // Save Data To SharedPreferences
  static Future<void> setString(String key, String value) async {
    final localStorage = await _getStorage();
    await localStorage.setString(key, value);
  }

  static Future<void> setBool(String key, bool value) async {
    final localStorage = await _getStorage();
    await localStorage.setBool(key, value);
  }

  static Future<void> setInt(String key, int value) async {
    final localStorage = await _getStorage();
    await localStorage.setInt(key, value);
  }
}
