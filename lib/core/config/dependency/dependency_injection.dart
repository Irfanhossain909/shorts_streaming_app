import 'package:get/get.dart';
import 'package:testemu/core/component/map/show_google_map.dart';
import 'package:testemu/features/auth/change_password/presentation/controller/change_password_controller.dart';
import 'package:testemu/features/auth/forgot%20password/presentation/controller/forget_password_controller.dart';
import 'package:testemu/features/auth/sign%20in/presentation/controller/sign_in_controller.dart';
import 'package:testemu/features/auth/sign%20up/presentation/controller/sign_up_controller.dart';
import 'package:testemu/features/home/presentation/controller/home_controller.dart';
import 'package:testemu/features/navigation_bar/presentation/controller/navigation_screen_controller.dart';
import 'package:testemu/features/notifications/presentation/controller/notifications_controller.dart';

class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    // Auth Controllers
    Get.lazyPut(() => SignUpController(), fenix: true);
    Get.lazyPut(() => SignInController(), fenix: true);
    Get.lazyPut(() => ForgetPasswordController(), fenix: true);
    Get.lazyPut(() => ChangePasswordController(), fenix: true);
    Get.lazyPut(() => NavigationScreenController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => NotificationsController(), fenix: true);

    // Common Feature Controllers
    Get.lazyPut(() => ShowGoogleMapController(), fenix: true);
  }
}
