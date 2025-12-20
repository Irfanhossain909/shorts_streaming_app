import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/utils/log/error_log.dart';
import 'package:testemu/features/auth/repository/auth_repository.dart';

class SignInController extends GetxController {
  /// Auth Repository instance
  AuthRepository authRepository = AuthRepository.instance;

  /// Sign in Button Loading variable
  RxBool isLoading = false.obs;

  /// Sign in form key , help for Validation

  /// email and password Controller here
  TextEditingController emailController = TextEditingController(
    text: kDebugMode ? 'developernaimul00@gmail.com' : '',
  );
  TextEditingController passwordController = TextEditingController(
    text: kDebugMode ? 'hello123' : "",
  );

  /// Sign in Api call here

  Future<void> signInUser({GlobalKey<FormState>? formKey}) async {
    // if (formKey?.currentState?.validate() ?? false) {
    //   return;
    // }
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
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
