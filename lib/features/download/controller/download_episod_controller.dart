import 'package:get/get.dart';

class DownloadEpisodController extends GetxController {
  var value = false.obs;
  void valueManupolate() {
    value.value = !value.value;
  }
}
