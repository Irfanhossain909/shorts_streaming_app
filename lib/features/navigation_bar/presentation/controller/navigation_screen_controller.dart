import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class NavigationScreenController extends GetxController {
  RxInt selectedIndex = RxInt(0);

  void changeIndex(int index) {
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
