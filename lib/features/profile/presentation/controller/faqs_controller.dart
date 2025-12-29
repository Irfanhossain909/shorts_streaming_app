import 'package:get/get.dart';
import 'package:testemu/core/utils/enum/enum.dart';
import 'package:testemu/features/profile/model/faqs_model.dart';
import 'package:testemu/features/profile/repository/profile_repository.dart';

class FaqsController extends GetxController {
  final ProfileRepository profileRepository = ProfileRepository.instance;

  /// Api status check here
  Status status = Status.completed;

  ///  Faqs model initialize here
  List<FaqsModel> faqs = [];

  /// Faqs Controller instance create here
  static FaqsController get instance => Get.put(FaqsController());

  @override
  void onInit() {
    getFaqsRepo();
    super.onInit();
  }

  /// Faqs Api call here
  Future<void> getFaqsRepo() async {
    status = Status.loading;
    update();
    final response = await profileRepository.getFaqs();
    if (response.isNotEmpty) {
      faqs = response;
      status = Status.completed;
      update();
    } else {
      status = Status.error;
      update();
    }
  }
}
