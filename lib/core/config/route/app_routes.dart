import 'package:get/get.dart';
import 'package:testemu/features/auth/change_password/presentation/screen/change_password_screen.dart';
import 'package:testemu/features/auth/forgot%20password/presentation/screen/create_password.dart';
import 'package:testemu/features/auth/forgot%20password/presentation/screen/forgot_password.dart';
import 'package:testemu/features/auth/forgot%20password/presentation/screen/verify_screen.dart';
import 'package:testemu/features/auth/sign%20in/presentation/screen/sign_in_screen.dart';
import 'package:testemu/features/auth/sign%20up/presentation/screen/sign_up_screen.dart';
import 'package:testemu/features/auth/sign%20up/presentation/screen/verify_user.dart';
import 'package:testemu/features/download/presenter/download_menu_screen.dart';
import 'package:testemu/features/download/presenter/download_sesone_list_screen.dart';
import 'package:testemu/features/home/presentation/screen/home_screen.dart';
import 'package:testemu/features/message/presentation/screen/chat_screen.dart';
import 'package:testemu/features/message/presentation/screen/message_screen.dart';
import 'package:testemu/features/my_list/presenter/screen/my_list_scree.dart';
import 'package:testemu/features/navigation_bar/presentation/screen/navigation_screen.dart';
import 'package:testemu/features/notifications/presentation/screen/notifications_screen.dart';
import 'package:testemu/features/onboarding_screen/onboarding_screen.dart';
import 'package:testemu/features/profile/presentation/screen/edit_profile.dart';
import 'package:testemu/features/profile/presentation/screen/profile_screen.dart';
import 'package:testemu/features/setting/presentation/screen/privacy_policy_screen.dart';
import 'package:testemu/features/setting/presentation/screen/setting_screen.dart';
import 'package:testemu/features/setting/presentation/screen/subscription_screen.dart';
import 'package:testemu/features/setting/presentation/screen/delete_account.dart';
import 'package:testemu/features/shorts/presenter/shorts_screen.dart';
import 'package:testemu/features/shorts/presenter/video_detail_screen.dart';
import 'package:testemu/features/splash/splash_screen.dart';

class AppRoutes {
  static const String test = "/test_screen.dart";
  static const String splash = "/splash_screen.dart";
  static const String onboarding = "/onboarding_screen.dart";
  static const String signUp = "/sign_up_screen.dart";
  static const String verifyUser = "/verify_user.dart";
  static const String signIn = "/sign_in_screen.dart";
  static const String forgotPassword = "/forgot_password.dart";
  static const String verifyEmail = "/verify_screen.dart";
  static const String createPassword = "/create_password.dart";
  static const String changePassword = "/change_password_screen.dart";
  static const String notifications = "/notifications_screen.dart";
  static const String chat = "/chat_screen.dart";
  static const String message = "/message_screen.dart";
  static const String profile = "/profile_screen.dart";
  static const String editProfile = "/edit_profile.dart";
  static const String privacyPolicy = "/privacy_policy_screen.dart";
  static const String deleteAccount = "/detele_account_screen.dart";
  static const String setting = "/setting_screen.dart";
  static const String navigation = "/navigation_screen.dart";
  static const String subscription = "/subscription_screen.dart";
  static const String shortScreen = "/shorts_screen.dart";
  static const String home = "/home_screen.dart";
  static const String myListScreen = "/my-list-screen.dart";
  static const String videoDetail = "/video_detail_screen.dart";
  static const String downloadMenu = "/download_menu.dart";
  static const String downloadSesone = "/download_sesone.dart";

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
    GetPage(name: signUp, page: () => SignUpScreen()),
    GetPage(name: verifyUser, page: () => const VerifyUser()),
    GetPage(name: signIn, page: () => SignInScreen()),
    GetPage(name: forgotPassword, page: () => ForgotPasswordScreen()),
    GetPage(name: verifyEmail, page: () => const VerifyScreen()),
    GetPage(name: createPassword, page: () => CreatePassword()),
    GetPage(name: changePassword, page: () => ChangePasswordScreen()),
    GetPage(name: notifications, page: () => const NotificationScreen()),
    GetPage(name: chat, page: () => const ChatListScreen()),
    GetPage(name: message, page: () => const MessageScreen()),
    GetPage(name: profile, page: () => const ProfileScreen()),
    GetPage(name: editProfile, page: () => EditProfile()),
    GetPage(name: privacyPolicy, page: () => const PrivacyPolicyScreen()),
    GetPage(name: deleteAccount, page: () => const DeleteAccountScreen()),
    GetPage(name: setting, page: () => const SettingScreen()),
    GetPage(name: navigation, page: () => const NavigationScreen()),
    GetPage(name: subscription, page: () => const SubscriptionScreen()),
    GetPage(name: shortScreen, page: () => const ShortsFeedScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: myListScreen, page: () => const MyListScree()),
    GetPage(name: videoDetail, page: () => const VideoDetailScreen()),
    GetPage(name: downloadMenu, page: () => const DownloadMenuScreen()),
    GetPage(name: downloadSesone, page: () => const DownloadSesoneListScreen()),
  ];
}
