import 'package:get/get.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/utils/enum/enum.dart';
import 'package:testemu/core/utils/log/app_log.dart';
import 'package:testemu/core/utils/log/error_log.dart';
import 'package:testemu/features/my_list/model/my_list_model.dart';
import 'package:testemu/features/my_list/repository/my_list_repository.dart';
import 'package:testemu/features/shorts/model/recent_videos_model.dart';

class MyListController extends GetxController {
  final MyListRepository myListRepository = MyListRepository.instance;
  RxList<Bookmark> bookmarks = <Bookmark>[].obs;
  final List<String> myListCategories = ['Recently Watched', 'My Collection '];
  final RxString selectedMyListCategory = 'Recently Watched'.obs;
  RxList<String> bookmarkCategories = <String>[].obs;
  RxList<RecentlyViewedItem> recentVideos = <RecentlyViewedItem>[].obs;
  @override
  void onInit() {
    super.onInit();
    getBookmarks();
    getRecentVideos();
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

  Future<void> getRecentVideos() async {
    final result = await myListRepository.getRecentVideos();
    result.fold(
      (l) {
        errorLog(l, source: 'My List Controller');
      },
      (r) {
        // Filter out items with null videoId
        final validVideos = r.where((item) => item.videoId != null).toList();
        recentVideos.assignAll(validVideos);
        appLog(
          'Recent videos: ${recentVideos.length} valid items (filtered from ${r.length} total)',
          source: 'My List Controller',
        );
      },
    );
  }
}
