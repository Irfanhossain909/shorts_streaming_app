import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/services/google_auth_service/google_auth_service.dart';
import 'package:testemu/core/utils/app_utils.dart';
import 'package:testemu/core/utils/log/app_log.dart';
import 'package:testemu/core/utils/log/error_log.dart';
import 'package:testemu/features/auth/repository/auth_repository.dart';
import 'package:testemu/features/auth/sign%20in/model/login_category_model.dart';

class SignInController extends GetxController {
  /// Auth Repository instance
  AuthRepository authRepository = AuthRepository.instance;

  /// Sign in Button Loading variable
  RxBool isLoading = false.obs;
  RxBool isLoadingSlider = false.obs;

  /// Sign in form key , help for Validation

  /// email and password Controller here
  TextEditingController emailController = TextEditingController(
    text: kDebugMode ? 'rotames140@badfist.com' : '',
  );
  TextEditingController passwordController = TextEditingController(
    text: kDebugMode ? 'hello123' : "",
  );

  Rxn<LoginsliderModel> loginSliderData = Rxn<LoginsliderModel>();

  // ---------------- GOOGLE SIGN IN ----------------
  GoogleAuthService googleAuthService = GoogleAuthService();
  Future<void> initializeGoogle() async {
    try {
      await googleAuthService.initialize();
    } catch (e) {
      Utils.errorSnackBar(Get.context!, "Google service initialization failed", "Google Sign In");
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final success = await googleAuthService.signIn();

      if (!success) {
        Utils.errorSnackBar(Get.context!, "Google Sign In Failed", "Google Sign In");
        return;
      }

      final idToken = googleAuthService.userData?.idToken;

      if (idToken == null || idToken.isEmpty) {
        Utils.errorSnackBar(Get.context!, "Invalid Google token", "Google Sign In");
        return;
      }

      // await googleAuth(idToken: idToken);
    } catch (e) {
      Utils.errorSnackBar(Get.context!, "Login failed. Please try again", "Google Sign In");
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
    } else {
      errorLog(response, source: "Sign In");
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    loginSlider();
    initializeGoogle();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
