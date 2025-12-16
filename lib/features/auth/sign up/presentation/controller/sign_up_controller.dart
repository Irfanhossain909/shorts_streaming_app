import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/utils/app_utils.dart';
import 'package:testemu/features/auth/repository/auth_repository.dart';

class SignUpController extends GetxController {
  AuthRepository authRepository = AuthRepository.instance;

  /// Sign Up Form Key

  bool isPopUpOpen = false;
  RxBool isLoading = false.obs;
  RxBool isLoadingVerify = false.obs;

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

  signUpUser() async {
    if (nameController.text.isEmpty) {
      Utils.errorSnackBar(Get.context!, "Name is required", "Sign Up");
      return;
    }
    if (emailController.text.isEmpty) {
      Utils.errorSnackBar(Get.context!, "Email is required", "Sign Up");
      return;
    }
    if (passwordController.text.isEmpty) {
      Utils.errorSnackBar(Get.context!, "Password is required", "Sign Up");
      return;
    }
    if (confirmPasswordController.text.isEmpty) {
      Utils.errorSnackBar(
        Get.context!,
        "Confirm Password is required",
        "Sign Up",
      );
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      Utils.errorSnackBar(
        Get.context!,
        "Password and Confirm Password do not match",
        "Sign Up",
      );
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
