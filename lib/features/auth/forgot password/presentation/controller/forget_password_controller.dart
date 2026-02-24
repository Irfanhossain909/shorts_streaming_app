import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/utils/app_utils.dart';
import 'package:testemu/features/auth/repository/auth_repository.dart';

class ForgetPasswordController extends GetxController {
  /// Loading for forget password
  RxBool isLoadingEmail = false.obs;

  /// here all Text Editing Controller
  TextEditingController emailController = TextEditingController();

  /// Auth Repository Instance
  AuthRepository authRepository = AuthRepository.instance;

  /// create Forget Password Controller instance
  static ForgetPasswordController get instance =>
      Get.put(ForgetPasswordController());

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  /// Forget Password Api Call

  Future<void> forgotPasswordRepo() async {
    isLoadingEmail.value = true;
    final response = await authRepository.forgetPassword(
      email: emailController.text,
    );
    if (response) {
      Get.toNamed(
        AppRoutes.verifyEmail,
        arguments: {
          'email': emailController.text,
          'type': 2, // 2 for forgot password
        },
      );
    } else {
      Utils.errorSnackBar(Get.context!, "Error", "Email Not Sent");
    }
    isLoadingEmail.value = false;
  }
}
