import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/utils/app_utils.dart';
import 'package:testemu/features/auth/repository/auth_repository.dart';

class CreatePasswordController extends GetxController {
  AuthRepository authRepository = AuthRepository.instance;

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  RxBool isLoading = false.obs;

  String? verifyToken;

  @override
  void onInit() {
    verifyToken = Get.arguments['verifyToken'];
    super.onInit();
  }

  void createPassword() async {
    isLoading.value = true;
    final response = await authRepository.resetPassword(
      newPassword: newPasswordController.text,
      confirmPassword: confirmPasswordController.text,
      resetToken: verifyToken ?? "",
    );

    if (response) {
      Get.offAllNamed(AppRoutes.signIn);
    } else {
      Utils.errorSnackBar(Get.context!, "Error", "Something went wrong");
    }
    isLoading.value = false;
  }
}
