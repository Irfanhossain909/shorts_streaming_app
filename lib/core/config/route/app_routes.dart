import 'package:get/get.dart';
/* =======================
  🔗 COMMON / CORE SCREENS
======================= */
import 'package:testemu/core/component/screen/no_internet.dart';
/* =======================
  🧠 APP / MAIN SCREENS
======================= */
import 'package:testemu/core/config/route/binding/app_binding.dart';
/* =======================
  🔐 AUTH SCREENS
======================= */
import 'package:testemu/core/config/route/binding/auth_binding.dart';
import 'package:testemu/features/auth/change_password/presentation/screen/change_password_screen.dart';
import 'package:testemu/features/auth/forgot%20password/presentation/screen/create_password.dart';
import 'package:testemu/features/auth/forgot%20password/presentation/screen/forgot_password.dart';
import 'package:testemu/features/auth/sign%20in/presentation/screen/sign_in_screen.dart';
import 'package:testemu/features/auth/sign%20up/presentation/screen/sign_up_screen.dart';
import 'package:testemu/features/auth/verify_email/presentation/screen/verify_screen.dart';
import 'package:testemu/features/download/presenter/download_episod_list_screen.dart';
/* =======================
  ⬇️ DOWNLOAD SCREENS
======================= */
import 'package:testemu/features/download/presenter/download_menu_screen.dart';
import 'package:testemu/features/download/presenter/download_sesone_list_screen.dart';
import 'package:testemu/features/download/presenter/downloaded_shorts_player_screen.dart';
import 'package:testemu/features/download/presenter/downloaded_shorts_screen.dart';
import 'package:testemu/features/home/presentation/screen/home_screen.dart';
/* =======================
  💬 MESSAGE SCREENS
======================= */
import 'package:testemu/features/my_list/presenter/screen/my_list_scree.dart';
import 'package:testemu/features/navigation_bar/presentation/screen/navigation_screen.dart';
import 'package:testemu/features/notifications/presentation/screen/notifications_screen.dart';
import 'package:testemu/features/onboarding_screen/onboarding_screen.dart';
import 'package:testemu/features/profile/presentation/screen/edit_profile.dart';
import 'package:testemu/features/profile/presentation/screen/faqs_screen.dart';
/* =======================
  👤 PROFILE & SETTINGS
======================= */
import 'package:testemu/features/profile/presentation/screen/profile_screen.dart';
import 'package:testemu/features/setting/presentation/screen/delete_account.dart';
import 'package:testemu/features/setting/presentation/screen/privacy_policy_screen.dart';
import 'package:testemu/features/setting/presentation/screen/setting_screen.dart';
import 'package:testemu/features/setting/presentation/screen/subscription_screen.dart';
import 'package:testemu/features/setting/presentation/screen/user_agreement_screen.dart';
/* =======================
  🎬 CONTENT / MEDIA
======================= */
import 'package:testemu/features/shorts/presenter/shorts_screen.dart';
import 'package:testemu/features/shorts/presenter/video_detail_screen.dart';
import 'package:testemu/features/shorts/presenter/video_player_screen.dart';
import 'package:testemu/features/splash/splash_screen.dart';

class AppRoutes {
  /* =======================
    📌 ROUTE NAMES
  ======================= */

  // Core
  static const splash = "/splash";
  static const onboarding = "/onboarding";
  static const noInternet = "/no_internet";

  // Auth
  static const signIn = "/sign_in";
  static const signUp = "/sign_up";
  static const forgotPassword = "/forgot_password";
  static const verifyEmail = "/verify_email";
  static const createPassword = "/create_password";
  static const changePassword = "/change_password";

  // App
  static const navigation = "/navigation";
  static const home = "/home";
  static const notifications = "/notifications";

  // Message
  static const chat = "/chat";
  static const message = "/message";

  // Profile & Settings
  static const profile = "/profile";
  static const editProfile = "/edit_profile";
  static const setting = "/setting";
  static const deleteAccount = "/delete_account";
  static const privacyPolicy = "/privacy_policy";
  static const userAgreement = "/user_agreement";
  static const subscription = "/subscription";
  static const faqs = "/faqs";

  // Media
  static const shorts = "/shorts";
  static const videoDetail = "/video_detail";
  static const videoPlayer = "/video_player";
  static const myList = "/my_list";

  // Download
  static const downloadMenu = "/download_menu";
  static const downloadSeason = "/download_season";
  static const downloadEpisode = "/download_episode";
  static const downloadedShorts = "/downloaded_shorts";
  static const downloadedShortsPlayer = "/downloaded_shorts_player";

  /* =======================
    🚦 GETX ROUTES
  ======================= */
  static final List<GetPage> routes = [
    /// Splash & onboarding
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: onboarding, page: () => const OnboardingScreen()),

    /// 🔐 AUTH ROUTES
    GetPage(name: signIn, binding: AuthBinding(), page: () => SignInScreen()),
    GetPage(name: signUp, binding: AuthBinding(), page: () => SignUpScreen()),
    GetPage(
      name: forgotPassword,
      binding: AuthBinding(),
      page: () => ForgotPasswordScreen(),
    ),
    GetPage(
      name: verifyEmail,
      binding: AuthBinding(),
      page: () => VerifyScreen(),
    ),
    GetPage(
      name: createPassword,
      binding: AuthBinding(),
      page: () => CreatePassword(),
    ),
    GetPage(
      name: changePassword,
      binding: AuthBinding(),
      page: () => ChangePasswordScreen(),
    ),

    /// 🧠 MAIN APP ROUTES
    GetPage(
      name: navigation,
      binding: AppBinding(),
      page: () => const NavigationScreen(),
    ),
    GetPage(name: home, binding: AppBinding(), page: () => HomeScreen()),
    GetPage(
      name: notifications,
      binding: AppBinding(),
      page: () => const NotificationScreen(),
    ),

    /// 👤 PROFILE & SETTINGS
    GetPage(
      name: profile,
      binding: AppBinding(),
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: editProfile,
      binding: AppBinding(),
      page: () => EditProfile(),
    ),
    GetPage(name: setting, page: () => const SettingScreen()),
    GetPage(name: deleteAccount, page: () => const DeleteAccountScreen()),
    GetPage(name: privacyPolicy, page: () => const PrivacyPolicyScreen()),
    GetPage(name: userAgreement, page: () => const UserAgreementScreen()),
    GetPage(name: subscription, page: () => const SubscriptionScreen()),
    GetPage(name: faqs, page: () => const FaqsScreen()),

    /// 🎬 MEDIA
    GetPage(name: shorts, page: () => ShortsFeedScreen()),
    GetPage(name: videoDetail, page: () => VideoDetailScreen()),
    GetPage(name: videoPlayer, page: () => const VideoPlayerScreen()),
    GetPage(name: myList, page: () => const MyListScree()),

    /// ⬇️ DOWNLOAD
    GetPage(
      name: downloadMenu,
      binding: AppBinding(),
      page: () => const DownloadMenuScreen(),
    ),
    GetPage(
      name: downloadSeason,
      binding: AppBinding(),
      page: () => const DownloadSesoneListScreen(),
    ),
    GetPage(
      name: downloadEpisode,
      binding: AppBinding(),
      page: () => const DownloadEpisodListScreen(),
    ),
    GetPage(
      name: downloadedShorts,
      binding: AppBinding(),
      page: () => const DownloadedShortsScreen(),
    ),
    GetPage(
      name: downloadedShortsPlayer,
      page: () => const DownloadedShortsPlayerScreen(),
    ),

    /// 🌐 NO INTERNET
    GetPage(name: noInternet, page: () => const NoInternet()),
  ];
}

// import 'package:get/get.dart';
// import 'package:testemu/core/component/screen/no_internet.dart';
// import 'package:testemu/core/config/route/binding/app_binding.dart';
// import 'package:testemu/core/config/route/binding/auth_binding.dart';
// import 'package:testemu/features/auth/change_password/presentation/screen/change_password_screen.dart';
// import 'package:testemu/features/auth/forgot%20password/presentation/screen/create_password.dart';
// import 'package:testemu/features/auth/forgot%20password/presentation/screen/forgot_password.dart';
// import 'package:testemu/features/auth/sign%20in/presentation/screen/sign_in_screen.dart';
// import 'package:testemu/features/auth/sign%20up/presentation/screen/sign_up_screen.dart';
// import 'package:testemu/features/auth/verify_email/presentation/screen/verify_screen.dart';
// import 'package:testemu/features/download/presenter/download_episod_list_screen.dart';
// import 'package:testemu/features/download/presenter/download_menu_screen.dart';
// import 'package:testemu/features/download/presenter/download_sesone_list_screen.dart';
// import 'package:testemu/features/home/presentation/screen/home_screen.dart';
// import 'package:testemu/features/message/presentation/screen/chat_screen.dart';
// import 'package:testemu/features/message/presentation/screen/message_screen.dart';
// import 'package:testemu/features/my_list/presenter/screen/my_list_scree.dart';
// import 'package:testemu/features/navigation_bar/presentation/screen/navigation_screen.dart';
// import 'package:testemu/features/notifications/presentation/screen/notifications_screen.dart';
// import 'package:testemu/features/onboarding_screen/onboarding_screen.dart';
// import 'package:testemu/features/profile/presentation/screen/edit_profile.dart';
// import 'package:testemu/features/profile/presentation/screen/faqs_screen.dart';
// import 'package:testemu/features/profile/presentation/screen/profile_screen.dart';
// import 'package:testemu/features/setting/presentation/screen/delete_account.dart';
// import 'package:testemu/features/setting/presentation/screen/privacy_policy_screen.dart';
// import 'package:testemu/features/setting/presentation/screen/setting_screen.dart';
// import 'package:testemu/features/setting/presentation/screen/subscription_screen.dart';
// import 'package:testemu/features/setting/presentation/screen/user_agreement_screen.dart';
// import 'package:testemu/features/shorts/presenter/shorts_screen.dart';
// import 'package:testemu/features/shorts/presenter/video_detail_screen.dart';
// import 'package:testemu/features/shorts/presenter/video_player_screen.dart';
// import 'package:testemu/features/splash/splash_screen.dart';

// class AppRoutes {
//   static const String test = "/test_screen.dart";
//   static const String splash = "/splash_screen.dart";
//   static const String onboarding = "/onboarding_screen.dart";
//   static const String signUp = "/sign_up_screen.dart";
//   static const String verifyUser = "/verify_user.dart";
//   static const String signIn = "/sign_in_screen.dart";
//   static const String forgotPassword = "/forgot_password.dart";
//   static const String verifyEmail = "/verify_screen.dart";
//   static const String createPassword = "/create_password.dart";
//   static const String changePassword = "/change_password_screen.dart";
//   static const String notifications = "/notifications_screen.dart";
//   static const String chat = "/chat_screen.dart";
//   static const String message = "/message_screen.dart";
//   static const String profile = "/profile_screen.dart";
//   static const String editProfile = "/edit_profile.dart";
//   static const String privacyPolicy = "/privacy_policy_screen.dart";
//   static const String deleteAccount = "/detele_account_screen.dart";
//   static const String setting = "/setting_screen.dart";
//   static const String navigation = "/navigation_screen.dart";
//   static const String subscription = "/subscription_screen.dart";
//   static const String shortScreen = "/shorts_screen.dart";
//   static const String home = "/home_screen.dart";
//   static const String myListScreen = "/my-list-screen.dart";
//   static const String videoDetail = "/video_detail_screen.dart";
//   static const String videoPlayer = "/video_player_screen.dart";
//   static const String downloadMenu = "/download_menu.dart";
//   static const String downloadSesone = "/download_sesone.dart";
//   static const String userAgreement = "/user_agreement.dart";
//   static const String downloadEpisodList = "/download_episod_list.dart";
//   static const String noInternet = "/no_internet.dart";
//   static const String faqsScreen = "/faqs_screen.dart";
//   static List<GetPage> routes = [
//     GetPage(name: splash, page: () => const SplashScreen()),
//     GetPage(name: onboarding, page: () => const OnboardingScreen()),
//     GetPage(name: signUp, binding: AuthBinding(), page: () => SignUpScreen()),
//     // GetPage(name: verifyUser, page: () => const VerifyUser()),
//     GetPage(name: signIn, binding: AuthBinding(), page: () => SignInScreen()),
//     GetPage(
//       name: forgotPassword,
//       binding: AuthBinding(),
//       page: () => ForgotPasswordScreen(),
//     ),
//     GetPage(
//       name: verifyEmail,
//       binding: AuthBinding(),
//       page: () => VerifyScreen(),
//     ),
//     GetPage(
//       binding: AuthBinding(),
//       name: createPassword,
//       page: () => CreatePassword(),
//     ),
//     GetPage(
//       name: changePassword,
//       binding: AuthBinding(),
//       page: () => ChangePasswordScreen(),
//     ),
//     GetPage(
//       name: notifications,
//       binding: AppBinding(),
//       page: () => const NotificationScreen(),
//     ),
//     GetPage(
//       name: chat,
//       binding: AppBinding(),
//       page: () => const ChatListScreen(),
//     ),
//     GetPage(
//       name: message,
//       binding: AppBinding(),
//       page: () => const MessageScreen(),
//     ),
//     GetPage(
//       name: profile,
//       binding: AppBinding(),
//       page: () => const ProfileScreen(),
//     ),
//     GetPage(
//       name: editProfile,
//       binding: AppBinding(),
//       page: () => EditProfile(),
//     ),
//     GetPage(name: privacyPolicy, page: () => const PrivacyPolicyScreen()),
//     GetPage(name: deleteAccount, page: () => const DeleteAccountScreen()),
//     GetPage(name: setting, page: () => const SettingScreen()),
//     GetPage(
//       name: navigation,
//       binding: AppBinding(),
//       page: () => const NavigationScreen(),
//     ),
//     GetPage(name: subscription, page: () => const SubscriptionScreen()),
//     GetPage(name: shortScreen, page: () => const ShortsFeedScreen()),
//     GetPage(name: home, binding: AppBinding(), page: () => HomeScreen()),
//     GetPage(name: myListScreen, page: () => const MyListScree()),
//     GetPage(name: videoDetail, page: () => VideoDetailScreen()),
//     GetPage(name: videoPlayer, page: () => const VideoPlayerScreen()),
//     GetPage(name: faqsScreen, page: () => const FaqsScreen()),
//     GetPage(
//       name: downloadMenu,
//       binding: AppBinding(),
//       page: () => const DownloadMenuScreen(),
//     ),
//     GetPage(
//       name: downloadSesone,
//       binding: AppBinding(),
//       page: () => const DownloadSesoneListScreen(),
//     ),
//     GetPage(name: userAgreement, page: () => const UserAgreementScreen()),
//     GetPage(
//       name: downloadEpisodList,
//       binding: AppBinding(),
//       page: () => const DownloadEpisodListScreen(),
//     ),
//     GetPage(name: noInternet, page: () => const NoInternet()),
//     GetPage(
//       name: editProfile,
//       binding: AppBinding(),
//       page: () => const EditProfile(),
//     ),
//   ];
// }
