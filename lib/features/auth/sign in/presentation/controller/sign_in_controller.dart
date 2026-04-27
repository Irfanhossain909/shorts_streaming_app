import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/services/google_auth_service/apple_auth_service.dart';
import 'package:testemu/core/services/google_auth_service/google_auth_service.dart';
import 'package:testemu/core/services/notification/device_info_service.dart';
import 'package:testemu/core/utils/app_utils.dart';
import 'package:testemu/core/utils/log/app_log.dart';
import 'package:testemu/core/utils/log/error_log.dart';
import 'package:testemu/core/services/storage/storage_keys.dart';
import 'package:testemu/core/services/storage/storage_services.dart';
import 'package:testemu/features/auth/repository/auth_repository.dart';
import 'package:testemu/features/auth/sign%20in/model/login_category_model.dart';
import 'package:testemu/features/notifications/repository/notification_repository.dart';

class SignInController extends GetxController {
  /// Auth Repository instance
  AuthRepository authRepository = AuthRepository.instance;
  DeviceInfoService deviceInfoService = DeviceInfoService.instance;
  RxBool isGoogleLoading = false.obs;

  NotificationRepository notificationRepository =
      NotificationRepository.instance;

  /// Sign in Button Loading variable
  RxBool isLoading = false.obs;
  RxBool isLoadingSlider = false.obs;

  RxBool isDeviceInfoLoading = false.obs;

  RxString platformType = "".obs;

  /// Sign in form key , help for Validation

  /// email and password Controller here
  TextEditingController emailController = TextEditingController(
    text: kDebugMode ? 'neniniy780@pazard.com' : '',
  );
  TextEditingController passwordController = TextEditingController(
    text: kDebugMode ? 'hello123' : "",
  );

  Rxn<LoginsliderModel> loginSliderData = Rxn<LoginsliderModel>();

  // ========================================================
  // Google
  GoogleWebAuthService googleWebAuthService = GoogleWebAuthService();
  Future<void> loginWithGoogle() async {
    isGoogleLoading.value = true;
    try {
      final success = await googleWebAuthService.signIn(); // new service
      if (success == null) {
        Utils.errorSnackBar(
          Get.context!,
          "Google Sign In Failed",
          "Google Sign In",
        );

        return;
      }
      await googleLogin(success.firebaseIdToken);
    } catch (e) {
      Utils.errorSnackBar(
        Get.context!,
        "Login failed. Please try again",
        "Google Sign In",
      );
    } finally {
      isGoogleLoading.value = false;
    }
  }

  // // Apple — এখন platform check দরকার নেই
  AppleWebAuthService appleWebAuthService = AppleWebAuthService();
  Future<void> loginWithApple() async {
    isGoogleLoading.value = true;
    try {
      final success = await appleWebAuthService.signIn(); // new service
      if (success == null) {
        Utils.errorSnackBar(
          Get.context!,
          "Apple Sign In Failed",
          "Apple Sign In",
        );
        return;
      }
      await googleLogin(success.firebaseIdToken);
    } catch (e) {
      Utils.errorSnackBar(
        Get.context!,
        "Login failed. Please try again",
        "Apple Sign In",
      );
    } finally {
      isGoogleLoading.value = false;
    }
  }

  // initializeDeviceInfo — সব platform এ Apple দেখাও
  void initializeDeviceInfo() {
    platformType.value = deviceInfoService.getPlatformType();
    // আর initialize এর দরকার নেই signInWithProvider এ
  }
  // ==============================

  Future<void> googleLogin(String idToken) async {
    final response = await authRepository.googleLogin(idToken: idToken);
    if (response) {
      Utils.successSnackBar(
        Get.context!,
        "Google Login successful",
        "Google Login",
      );
      await updateFCMToken();
      Get.offAllNamed(AppRoutes.navigation);
    } else {
      Utils.errorSnackBar(Get.context!, "Google Login failed", "Google Login");
    }
  }

  Future<void> updateFCMToken() async {
    try {
      final response = await notificationRepository.updateFCMToken();
      if (response) {
        appLog("FCM Token updated", source: "FCM Token");
      } else {
        appLog("FCM Token update failed", source: "FCM Token");
      }
    } catch (e) {
      errorLog(e);
      rethrow;
    }
  }

  /// Sign in Api call here

  Future<void> loginSlider() async {
    isLoadingSlider.value = true;
    final response = await authRepository.loginSlider();
    if (response != null) {
      loginSliderData.value = response;
      appLog(loginSliderData.value?.data?.images?.length.toString());
    } else {
      errorLog(response, source: "Sign In");
    }
    isLoadingSlider.value = false;
  }

  Future<void> signInUser({GlobalKey<FormState>? formKey}) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return;
    }
    isLoading.value = true;
    final response = await authRepository.login(
      email: emailController.text,
      password: passwordController.text,
    );
    if (response) {
      Get.toNamed(AppRoutes.navigation);
      await updateFCMToken();
    } else {
      errorLog(response, source: "Sign In");
    }
    isLoading.value = false;
  }

  Future<void> continueAsGuest() async {
    await LocalStorage.setBool(LocalStorageKeys.isGuest, true);
    Get.offAllNamed(AppRoutes.navigation);
  }

  @override
  void onInit() {
    super.onInit();
    // initializeDeviceInfo();
    initializeDeviceInfo();
    loginSlider();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
