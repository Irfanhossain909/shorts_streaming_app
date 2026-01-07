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

  // -------------------Auth endpoints
  final String signUp = "/users/register";
  final String verifyEmail = "/auth/verify-email";
  final String signIn = "/auth/login";
  final String resendOtp = "/auth/resend-otp";
  final String forgotPassword = "/auth/forget-password";
  // final String verifyOtp = "users/verify-otp";
  final String resetPassword = "/auth/reset-password";
  // final String changePassword = "users/change-password";

  //-------------Profile endpoints
  final String editProfile = "/users/profile";

  //------------Core App endpoints
  final String settings = "/settings";
  final String subscription = "/package/users-package";
  final String getCategories = "/category";
  final String getTrailers = "/trailer/all-trailers";
  final String getAllMovies = "/movies/get-movies-for-user";
  final String getVideoDetails = "/movies/get-movies-with-seasons/";
  final String getSeasonVideoDetailsById = "/video/all-season-videos-by/";
  final String getFaqs = "/faq";
  final String getReminders = "/reminder/for-user";
  final String toggleBookmark = "/bookmark/toggle";
  final String getBookmarks = "/bookmark";
  // // App endpoints
  final String user = "users";
  final String notifications = "notifications";
  final String privacyPolicies = "privacy-policies";
  final String termsOfServices = "terms-and-conditions";
  final String chats = "chats";
  final String messages = "messages";
  final String userAgreement = "user-agreement";
  final String deleteAccount = "delete-account";
}

// Helper function to get domain based on environment
String _getDomain() {
  String liveServer = "http://72.62.164.122:5000";
  String localServer = "http://72.62.164.122:5000";
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
  String liveImageUrl = "https://rakibur5003.binarybards.online";
  String localImageUrl = "https://rakibur5003.binarybards.online";

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
  String liveSocket = "https://rakibur5003.binarybards.online";
  String localSocket = "https://rakibur5003.binarybards.online";

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
