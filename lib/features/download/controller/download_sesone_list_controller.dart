import 'package:get/get.dart';

class DownloadSesoneListController extends GetxController {
  var value = false.obs;
  final selectedItems = <int>{}.obs;

  void valueManupolate() {
    value.value = !value.value;
    if (!value.value) {
      selectedItems.clear();
    }
    update();
  }

  void toggleSelection(int index) {
    if (selectedItems.contains(index)) {
      selectedItems.remove(index);
    } else {
      selectedItems.add(index);
    }
    update();
  }
}
