import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/services/google_auth_service/apple_auth_service.dart';
import 'package:testemu/core/services/google_auth_service/google_auth_service.dart';
import 'package:testemu/core/services/notification/device_info_service.dart';
import 'package:testemu/core/utils/app_utils.dart';
import 'package:testemu/core/utils/log/app_log.dart';
import 'package:testemu/core/utils/log/error_log.dart';
import 'package:testemu/features/auth/repository/auth_repository.dart';
import 'package:testemu/features/notifications/repository/notification_repository.dart';

class SignUpController extends GetxController {
  AuthRepository authRepository = AuthRepository.instance;
  NotificationRepository notificationRepository =
      NotificationRepository.instance;

  /// Sign Up Form Key

  bool isPopUpOpen = false;
  RxBool isLoading = false.obs;
  RxBool isLoadingVerify = false.obs;
  DeviceInfoService deviceInfoService = DeviceInfoService.instance;
  RxBool isGoogleLoading = false.obs;
  RxString platformType = "".obs;

  Timer? _timer;
  int start = 0;

  String time = "";

  static SignUpController get instance => Get.put(SignUpController());

  TextEditingController nameController = TextEditingController(
    text: kDebugMode ? "Namimul Hassan" : "",
  );
  TextEditingController emailController = TextEditingController(
    text: kDebugMode ? "developernaimul00@gmail.com" : '',
  );
  TextEditingController passwordController = TextEditingController(
    text: kDebugMode ? 'hello123' : '',
  );
  TextEditingController confirmPasswordController = TextEditingController(
    text: kDebugMode ? 'hello123' : '',
  );
  TextEditingController otpController = TextEditingController(
    text: kDebugMode ? '123456' : '',
  );

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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

  Future<void> googleLogin(String idToken) async {
    final response = await authRepository.googleLogin(idToken: idToken);
    if (response) {
      Utils.successSnackBar(
        Get.context!,
        "Google Login successful",
        "Google Login",
      );
      Get.offAllNamed(AppRoutes.navigation);
      await updateFCMToken();
    } else {
      Utils.errorSnackBar(Get.context!, "Google Login failed", "Google Login");
    }
  }

  // ==============================

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

  signUpUser({GlobalKey<FormState>? formKey}) async {
    if (formKey?.currentState?.validate() == false) {
      return;
    }
    isLoading.value = true;
    final response = await authRepository.signUp(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
    );
    if (response) {
      Get.toNamed(
        AppRoutes.verifyEmail,
        arguments: {
          "email": emailController.text,
          "type": 1, // 1 for sign up
        },
      );
    } else {
      Utils.errorSnackBar(Get.context!, "Something went wrong", "Sign Up");
    }
    isLoading.value = false;
  }

  void startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    start = 180; // Reset the start value
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (start > 0) {
        start--;
        final minutes = (start ~/ 60).toString().padLeft(2, '0');
        final seconds = (start % 60).toString().padLeft(2, '0');

        time = "$minutes:$seconds";

        update();
      } else {
        _timer?.cancel();
      }
    });
  }
}
