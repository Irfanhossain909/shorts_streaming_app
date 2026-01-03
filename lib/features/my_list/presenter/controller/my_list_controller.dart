import 'package:get/get.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/utils/enum/enum.dart';
import 'package:testemu/core/utils/log/error_log.dart';
import 'package:testemu/features/my_list/model/my_list_model.dart';
import 'package:testemu/features/my_list/repository/my_list_repository.dart';

class MyListController extends GetxController {
  final MyListRepository myListRepository = MyListRepository.instance;
  RxList<Bookmark> bookmarks = <Bookmark>[].obs;
  final List<String> myListCategories = ['Recently Watched', 'My Collection '];
  final RxString selectedMyListCategory = 'Recently Watched'.obs;
  RxList<String> bookmarkCategories = <String>[].obs;
  @override
  void onInit() {
    super.onInit();
    getBookmarks();
  }

  Future<void> getBookmarks() async {
    final result = await myListRepository.getBookmarks();
    result.fold(
      (l) {
        errorLog(l, source: 'My List Controller');
      },
      (r) {
        bookmarks.value = r;
      },
    );
  }

  void selectMyListCategory(String category) {
    selectedMyListCategory.value = category;
    update();
  }

  void onMovieTap(String videoId, String referenceType, String videoUrl) {
    if (referenceType == ReferenceType.Trailer.name) {
      Get.toNamed(AppRoutes.videoPlayer, arguments: {'videoUrl': videoUrl});
    } else if (referenceType == ReferenceType.Movie.name) {
      Get.toNamed(AppRoutes.videoDetail, arguments: {'videoId': videoId});
    } else {
      Get.snackbar('Error', 'Invalid reference type');
    }
  }
}
