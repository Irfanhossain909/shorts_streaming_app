
import 'package:get/get.dart';

class NavigationScreenController extends GetxController {
  RxInt selectedIndex = RxInt(0);

  changeIndex(int index) {
    selectedIndex.value = index;
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

  @override
  void onInit() {
    super.onInit();
  }

  // @override
  // void onClose() {
  //   appUserData.dispose();
  //   super.onClose();
  // }
}
