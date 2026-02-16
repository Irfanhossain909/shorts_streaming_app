import 'package:get/get.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/constants/app_colors.dart';
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
  final RxSet<String> bookmarkedMovies = <String>{}.obs;

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
      Get.toNamed(
        AppRoutes.videoPlayer,
        arguments: {
          'videoUrl': videoUrl,
          'videoId': videoId, // Pass videoId for progress tracking
        },
      );
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

  //--- Refresh All Data (Pull to Refresh) ---//
  Future<void> refreshMyListData() async {
    try {
      // Load bookmarks and recent videos in parallel
      await Future.wait([getBookmarks(), getRecentVideos()]);

      Get.snackbar(
        'Refreshed',
        'My List updated successfully',
        colorText: Get.theme.colorScheme.onPrimary,
        backgroundColor: Get.theme.primaryColor.withValues(alpha: 0.8),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      errorLog(e, source: 'My List Controller - Refresh');
      Get.snackbar(
        'Error',
        'Failed to refresh data',
        colorText: Get.theme.colorScheme.onError,
        backgroundColor: Get.theme.colorScheme.error,
      );
    }
  }

  Future<void> onBookmarkTap(
    String title,
    String id,
    String referenceType,
  ) async {
    // Check current bookmark state before toggling
    final wasBookmarked = bookmarkedMovies.contains(id);

    final result = await myListRepository.toggleBookmark(id, referenceType);
    result.fold(
      (l) {
        // Error occurred
        Get.snackbar(
          'Error',
          'Failed to update bookmark: $l',
          colorText: AppColors.background,
        );
      },
      (r) async {
        // Success - toggle completed
        await getBookmarks();
        if (wasBookmarked) {
          bookmarkedMovies.remove(id);
          Get.snackbar(
            'Bookmark',
            'Removed $title from bookmarks',
            colorText: AppColors.background,
          );
        } else {
          bookmarkedMovies.add(id);
          Get.snackbar(
            'Bookmark',
            'Added $title to bookmarks',
            colorText: AppColors.background,
          );
        }
      },
    );
  }
}
