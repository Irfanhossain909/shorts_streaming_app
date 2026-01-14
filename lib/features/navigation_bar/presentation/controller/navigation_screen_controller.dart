import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:testemu/features/shorts/controller/shorts_controller.dart';

class NavigationScreenController extends GetxController {
  RxInt selectedIndex = RxInt(0);

  void changeIndex(int index) {
    final previousIndex = selectedIndex.value;

    // Handle Shorts tab visibility changes
    try {
      if (Get.isRegistered<ShortsScontroller>()) {
        final shortsController = Get.find<ShortsScontroller>();

        // Navigating away from Shorts tab
        if (previousIndex == 1 && index != 1) {
          shortsController.pauseCurrentVideo();
        }
        // Navigating to Shorts tab
        else if (previousIndex != 1 && index == 1) {
          shortsController.onScreenBecameVisible();
        }
      }
    } catch (e) {
      printInfo(info: 'Error handling video state: $e');
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
