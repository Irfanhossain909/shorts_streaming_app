import 'package:get/get.dart';
import 'package:testemu/features/auth/change_password/presentation/controller/change_password_controller.dart';
import 'package:testemu/features/auth/forgot password/presentation/controller/forget_password_controller.dart';
import 'package:testemu/features/auth/sign in/presentation/controller/sign_in_controller.dart';
import 'package:testemu/features/auth/sign up/presentation/controller/sign_up_controller.dart';
import 'package:testemu/features/auth/verify_email/presentation/controller/verify_controller.dart';

class AuthBinding extends Bindings {
  @override
  dependencies() {
    Get.lazyPut(() => SignUpController());
    Get.lazyPut(() => SignInController());
    Get.lazyPut(() => VerifyController());
    Get.lazyPut(() => ForgetPasswordController());
    Get.lazyPut(() => ChangePasswordController());
  }
}
