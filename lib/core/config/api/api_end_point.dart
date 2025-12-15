import 'package:flutter/foundation.dart';

class ApiEndPoint {
  ApiEndPoint._privateConstructor();
  static final ApiEndPoint _instance = ApiEndPoint._privateConstructor();
  static ApiEndPoint get instance => _instance;

  // Dynamic domain based on debug/release mode
  static final String domain = _getDomain();
  final String baseUrl = "$domain/api/v1";
  final String imageUrl = _getImageUrl();
  final String socketUrl = _getSocketUrl();

  // Auth endpoints
  final String signUp = "users/sign-up";
  final String verifyEmail = "users/verify-email";
  final String signIn = "/auth/login";
  final String forgotPassword = "users/forget-password";
  final String verifyOtp = "users/verify-otp";
  final String resetPassword = "users/reset-password";
  final String changePassword = "users/change-password";

  // App endpoints
  final String user = "users";
  final String notifications = "notifications";
  final String privacyPolicies = "privacy-policies";
  final String termsOfServices = "terms-and-conditions";
  final String chats = "chats";
  final String messages = "messages";
}

// Helper function to get domain based on environment
String _getDomain() {
  String liveServer = "http://103.145.138.74:5003";
  String localServer = "http://10.10.7.48:5003";

  try {
    if (kDebugMode) {
      return localServer;
    }
    return liveServer;
  } catch (e) {
    debugPrint("Error in _getDomain: $e");
    return liveServer;
  }
}

// Helper function to get image URL
String _getImageUrl() {
  String liveImageUrl = "http://103.145.138.74:3000";
  String localImageUrl = "http://10.10.7.48:5003";

  try {
    if (kDebugMode) {
      return localImageUrl;
    }
    return liveImageUrl;
  } catch (e) {
    debugPrint("Error in _getImageUrl: $e");
    return liveImageUrl;
  }
}

// Helper function to get socket URL
String _getSocketUrl() {
  String liveSocket = "http://103.145.138.74:3001";
  String localSocket = "http://10.10.7.48:3001";

  try {
    if (kDebugMode) {
      return localSocket;
    }
    return liveSocket;
  } catch (e) {
    debugPrint("Error in _getSocketUrl: $e");
    return liveSocket;
  }
}
