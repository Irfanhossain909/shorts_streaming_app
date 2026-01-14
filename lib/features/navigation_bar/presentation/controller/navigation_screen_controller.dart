import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:testemu/features/shorts/controller/shorts_controller.dart';

class NavigationScreenController extends GetxController {
  RxInt selectedIndex = RxInt(0);

  void changeIndex(int index) {
    // Pause video when navigating away from Shorts tab (index 1)
    if (selectedIndex.value == 1 && index != 1) {
      try {
        // Get the ShortsScontroller if it exists and pause the video
        if (Get.isRegistered<ShortsScontroller>()) {
          final shortsController = Get.find<ShortsScontroller>();
          shortsController.pauseCurrentVideo();
        }
      } catch (e) {
        printInfo(info: 'Error pausing video: $e');
      }
    }

    // Prevent build-during-frame errors by scheduling state change
    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        selectedIndex.value = index;
      });
    } else {
      selectedIndex.value = index;
    }
  }

  initialDataSetUp() {
    // try {
    //   final argData = Get.arguments;
    //   if (argData.runtimeType != Null) {
    //     appUserData.value = argData;
    //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //       update();
    //     });
    //   }
    // } catch (e) {
    //   errorLog("navigation screen initial data setup function", e);
    // }
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  // @override
  // void onClose() {
  //   appUserData.dispose();
  //   super.onClose();
  // }
}
