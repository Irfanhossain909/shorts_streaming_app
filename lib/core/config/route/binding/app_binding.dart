import 'package:get/get.dart';
import 'package:testemu/features/download/controller/download_episod_controller.dart';
import 'package:testemu/features/download/controller/download_sesone_list_controller.dart';
import 'package:testemu/features/home/presentation/controller/home_controller.dart';
import 'package:testemu/features/message/presentation/controller/chat_controller.dart';
import 'package:testemu/features/message/presentation/controller/message_controller.dart';
import 'package:testemu/features/navigation_bar/presentation/controller/navigation_screen_controller.dart';
import 'package:testemu/features/notifications/presentation/controller/notifications_controller.dart';
import 'package:testemu/features/profile/presentation/controller/edit_profile_controller.dart';
import 'package:testemu/features/profile/presentation/controller/profile_controller.dart';
import 'package:testemu/features/shorts/controller/shorts_controller.dart';

class AppBinding extends Bindings {
  @override
  dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => NavigationScreenController());
    Get.lazyPut(() => NotificationsController());
    Get.lazyPut(() => ChatController());
    Get.lazyPut(() => MessageController());
    Get.lazyPut(() => DownloadEpisodController());
    Get.lazyPut(() => DownloadSesoneListController());
    Get.lazyPut(() => EditProfileController());
    Get.lazyPut(() => ShortsScontroller());
  }
}
