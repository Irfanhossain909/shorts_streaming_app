import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/utils/app_utils.dart';
import 'package:testemu/features/auth/repository/auth_repository.dart';

class VerifyController extends GetxController {
  /// Loading for Verify OTP
  RxBool isLoadingVerify = false.obs;

  /// Auth Api Call
  AuthRepository authRepository = AuthRepository.instance;

  /// this is timer , help to resend OTP send time
  int start = 0;
  Timer? _timer;
  String time = "00:00";

  /// OTP Controller
  TextEditingController otpController = TextEditingController();

  /// Controller Instance
  static VerifyController get instance => Get.put(VerifyController());

  String? email;
  int? type;
  @override
  void onInit() {
    startTimer();
    email = Get.arguments['email'];
    type = Get.arguments['type'];
    super.onInit();
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  /// start Time for check Resend OTP Time
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

  /// Verify OTP Api Call
  Future<void> verifyOtpRepo() async {
    isLoadingVerify.value = true;
    if (type == 2) {
      final response = await authRepository.emailVerify(
        email: email ?? "",
        otp: int.parse(otpController.text),
      );
      if (response) {
        Get.offAllNamed(AppRoutes.signIn);
      } else {
        Utils.errorSnackBar(Get.context!, "Error", "Something went wrong");
      }
    }
    if (type == 2) {
      final response = await authRepository.emailVerify(
        email: email ?? "",
        otp: int.parse(otpController.text),
      );
      if (response) {
        Get.offAllNamed(AppRoutes.signIn);
      } else {
        Utils.errorSnackBar(Get.context!, "Error", "Something went wrong");
      }
    }
    isLoadingVerify.value = false;
  }

  /// Resend Otp Function
  Future<void> resendOtpRepo() async {
    final response = await authRepository.resendOtp(email: email ?? "");
    if (response) {
      // Get.toNamed(AppRoutes.createPassword);
      startTimer();
    } else {
      Utils.errorSnackBar(Get.context!, "Error", "Something went wrong");
    }
  }
}
