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
  final String googleLogin = "/auth/google-login";
  // final String changePassword = "users/change-password";

  //-------------Profile endpoints
  final String editProfile = "/users/profile";

  //------------Core App endpoints
  final String settings = "/settings";
  final String subscription = "/package/users-package";
  final String verifyPurchase = "/subscription/create-iap-subscription";
  final String getCategories = "/category";
  final String getTrailers = "/trailer/all-trailers";
  final String getAllMovies = "/movies/get-movies-for-user";
  final String getVideoDetails = "/movies/get-movies-with-seasons/";
  final String getSeasonVideoDetailsById = "/video/all-season-videos-by/";
  final String getFaqs = "/faq";
  final String getReminders = "/reminder/for-user";
  final String toggleBookmark = "/bookmark/toggle";
  final String getBookmarks = "/bookmark";
  final String addRecentVideos = "/users/add-recently-viewed/";
  final String getRecentVideos = "/users/recently-viewed";
  final String getShortsVideos = "/video/shorts-videos";
  final String toggleLikeVideo = "/like/toggle";
  // // App endpoints
  final String user = "users";
  final String notifications = "/notification";
  String readNotification({required String notificationId}) =>
      "/notification/$notificationId/read";
  final String privacyPolicies = "privacy-policies";
  final String termsOfServices = "terms-and-conditions";
  final String chats = "chats";
  final String messages = "messages";
  final String userAgreement = "user-agreement";
  final String deleteAccount = "/users/delete-account";

  final String loginSlider = "/dynamic-content/key/login";
}

// Helper function to get domain based on environment
String _getDomain() {
  String liveServer = "http://72.62.164.122:5000";
  // String localServer = "https://rakibur5002.binarybards.online";
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
  String liveImageUrl = "http://72.62.164.122:5000";
  String localImageUrl = "http://72.62.164.122:5000";

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
  String liveSocket = "http://72.62.164.122:5000";
  String localSocket = "http://72.62.164.122:5000";

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
