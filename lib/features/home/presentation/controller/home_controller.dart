import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testemu/core/config/api/api_end_point.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/services/socket/socket_all_oparations.dart';
import 'package:testemu/core/utils/enum/enum.dart';
import 'package:testemu/core/utils/log/app_log.dart';
import 'package:testemu/features/home/model/banner_model.dart';
import 'package:testemu/features/home/model/category_model.dart';
import 'package:testemu/features/home/model/movie_model.dart';
import 'package:testemu/features/home/model/remainder_model.dart';
import 'package:testemu/features/home/repository/category_repository.dart';
import 'package:testemu/features/notifications/data/model/notification_model.dart';
import 'package:testemu/features/notifications/presentation/controller/notifications_controller.dart';
import 'package:testemu/features/profile/presentation/controller/profile_controller.dart';

class HomeController extends GetxController {
  CategoryRepository categoryRepository = CategoryRepository.instance;

  SocketService socketService = SocketService.instance;
  NotificationsController notificationController = Get.put(
    NotificationsController(),
  );

  ProfileController profileController = Get.find<ProfileController>();

  // Observable variables
  var selectedCategory = 'popular'.obs;
  var selectedMyListCategory = 'Recently Watched'.obs;
  var selectedLibraryCategory = 'Most Popular'.obs;
  var selectedVipFilter = 'Daily'.obs;
  var selectedRankingFilter = 'Most Popular'.obs;
  var userName = 'user'.obs;
  var isHeaderSticky = false.obs;
  var searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  // Debounce timer for smooth state updates
  Timer? _debounceTimer;

  // Carousel state
  late PageController carouselPageController;
  final RxInt carouselCurrentIndex = 0.obs;
  Timer? _autoScrollTimer;
  final RxBool isUserScrolling = false.obs;
  final RxSet<String> bookmarkedMovies = <String>{}.obs;

  // Categories
  final List<Category> categories = RxList<Category>();
  final List<Movie> movies = RxList<Movie>();
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;
  final List<Reminder> reminders = RxList<Reminder>();
  final List<String> libraryMovies = ['All', 'Featured', 'Movie'];
  final List<String> libraryMovies2 = [
    'All',
    'Contemporary',
    'Recently Watched',
  ];
  final List<String> libraryMovies3 = ['Realistic', 'Suspense', 'Urban'];

  final List<String> myListCategories = ['Recently Watched', 'My Collection '];

  // VIP sub-filters
  final List<String> vipFilters = ['Daily', 'Weekly'];

  // Ranking sub-filters
  final List<String> rankingFilters = ['Most Popular'];

  // Banners List
  final List<Trailer> bannersList = RxList<Trailer>();

  @override
  void onInit() async {
    super.onInit();

    carouselPageController = PageController(
      viewportFraction: 0.45,
      initialPage: 0,
    );
    carouselPageController.addListener(_onPageControllerChanged);
    _startAutoScroll();

    getCategories();
    getTrailers();
    getMovies();
    getReminders();
    _connectSocket();
    // Reactive listening
    ever(profileController.profileModel, (profile) {
      final userId = profile?.id;
      if (userId != null) {
        appLog("UserId available: $userId -> Calling notification listener");
        _listenNotification(userId);
      }
    });
  }

  // ------- socket notification

  RxInt unreadNotificationCount = 0.obs;

  void _connectSocket() {
    SocketService.instance.initSocket(
      onConnected: () {
        appLog('✅ Socket connected from controller');
      },
    );

    SocketService.instance.connect(ApiEndPoint.domain);
  }

  // void listenNotificationIfProfileExists() {
  //   final userId = profileController.profileModel.value?.id;

  //   if (userId != null) {
  //     // Profile er id thakle notification listener call koro
  //     _listenNotification(userId);
  //   } else {
  //     appLog("Profile ID not available, notifications not listening.");
  //   }
  // }

  // _listenNotification update koro userId parameter accept korar jonno
  void _listenNotification(String uid) {
    SocketService.instance.onEvent('notification::$uid', (data) {
      appLog("Notification received: $data");

      // Convert raw data to Result model
      Result newNotification = Result.fromJson(data);

      // Insert into your controller's notification list
      notificationController.notificationList.insert(0, newNotification);
    });
  }

  // void _listenNotification() {

  //   SocketService.instance.onEvent('notification::$uid', (data) {
  //     appLog("Notification received: $data");

  //     // Convert raw data to Result model
  //     Result newNotification = Result.fromJson(data);

  //     // Insert into your controller's notification list
  //     notificationController.notificationList.insert(0, newNotification);
  //   });
  // }

  // Current filtered movies based on selected category
  List<Movie> get currentMovies {
    return filteredMoviesBySelectedCategory;
  }

  // Movies filtered from backend list based on selected category name
  List<Movie> get filteredMoviesBySelectedCategory {
    if (selectedCategory.value.isEmpty || categories.isEmpty) {
      return movies;
    }

    // Find the selected category from categories list
    final selectedCategoryLower = selectedCategory.value.trim().toLowerCase();
    Category? selectedCategoryObj;
    try {
      selectedCategoryObj = categories.firstWhere(
        (cat) => cat.name.trim().toLowerCase() == selectedCategoryLower,
      );
    } catch (e) {
      selectedCategoryObj = null;
    }

    // If category found, filter by categoryId (more reliable)
    if (selectedCategoryObj != null) {
      return movies
          .where(
            (movie) =>
                movie.categoryId != null &&
                movie.categoryId == selectedCategoryObj!.id,
          )
          .toList();
    }

    // Fallback: filter by category name (case-insensitive)
    return movies
        .where(
          (movie) =>
              movie.category != null &&
              movie.category!.trim().toLowerCase() == selectedCategoryLower,
        )
        .toList();
  }

  // Movies filtered by search query
  List<Movie> get searchedMovies {
    if (searchQuery.value.trim().isEmpty) {
      return [];
    }

    final query = searchQuery.value.trim().toLowerCase();
    return movies
        .where(
          (movie) =>
              movie.title.toLowerCase().contains(query) ||
              (movie.description.toLowerCase().contains(query)) ||
              movie.genre.toLowerCase().contains(query) ||
              movie.tags.any((tag) => tag.toLowerCase().contains(query)),
        )
        .toList();
  }

  // Check if search is active
  bool get isSearchActive => searchQuery.value.trim().isNotEmpty;

  // Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Clear search
  void clearSearch() {
    searchQuery.value = '';
    searchController.clear();
  }

  // Current VIP movies based on selected filter (Daily/Weekly)
  List<Movie> get currentVipMovies {
    final vipMovies = filteredMoviesBySelectedCategory;

    // Get today's date (without time)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (selectedVipFilter.value == 'Daily') {
      // Show only videos created today
      return vipMovies.where((movie) {
        final movieDate = DateTime(
          movie.createdAt.year,
          movie.createdAt.month,
          movie.createdAt.day,
        );
        return movieDate.isAtSameMomentAs(today);
      }).toList();
    } else if (selectedVipFilter.value == 'Weekly') {
      // Show videos created before today
      return vipMovies.where((movie) {
        final movieDate = DateTime(
          movie.createdAt.year,
          movie.createdAt.month,
          movie.createdAt.day,
        );
        return movieDate.isBefore(today);
      }).toList();
    }

    return vipMovies;
  }

  // Current ranking movies based on selected filter
  List<Movie> get currentRankingMovies {
    return filteredMoviesBySelectedCategory
        .where((movie) => movie.categoryId == selectedRankingFilter.value)
        .toList();
  }

  // Methods
  void selectCategory(String category) {
    appLog('selectCategory: $category');
    selectedCategory.value = category.trim().toLowerCase();
    update();
  }

  void selectMyListCategory(String category) {
    selectedMyListCategory.value = category;
    update();
  }

  void selectVipFilter(String filter) {
    selectedVipFilter.value = filter;
    update();
  }

  void selectRankingFilter(String filter) {
    selectedRankingFilter.value = filter;
    update();
  }

  void onMovieTap(String videoId) {
    Get.toNamed(AppRoutes.videoDetail, arguments: {'videoId': videoId});
    //Get.snackbar('Movie Selected', title, colorText: AppColors.background);
  }

  void onWatchTap(String videoUrl) {
    appLog('onWatchTap: $videoUrl');
    // VideoPlayerController will automatically generate videoId from URL if not provided
    Get.toNamed(AppRoutes.videoPlayer, arguments: {'videoUrl': videoUrl});
  }

  Future<void> onBookmarkTap(
    String title,
    String id,
    ReferenceType referenceType,
  ) async {
    // Check current bookmark state before toggling
    final wasBookmarked = bookmarkedMovies.contains(id);

    final result = await categoryRepository.toggleBookmark(
      id,
      referenceType.name,
    );
    result.fold(
      (l) {
        // Error occurred
        Get.snackbar(
          'Error',
          'Failed to update bookmark: $l',
          colorText: AppColors.background,
        );
      },
      (r) {
        // Success - toggle completed
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

  void onRemindMeTap(String title) {
    Get.snackbar(
      'Reminder Set',
      'You will be notified when $title is available',
      colorText: AppColors.background,
    );
  }

  void setStickyState(bool isSticky) {
    // Debounce the state changes to prevent excessive updates
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 50), () {
      if (isHeaderSticky.value != isSticky) {
        isHeaderSticky.value = isSticky;
      }
    });
  }

  //--- Get Categories ---//

  Future<void> getCategories() async {
    isLoading.value = true;
    try {
      final result = await categoryRepository.getCategories();
      result.fold(
        (l) {
          isError.value = true;
          errorMessage.value = l;
        },
        (r) {
          isError.value = false;
          categories.assignAll(r);

          // If selectedCategory isn't coming from backend yet, default to first
          if (r.isNotEmpty) {
            final firstName = r.first.name.trim();
            if (firstName.isNotEmpty) {
              selectedCategory.value = firstName.toLowerCase();
            }
          }
        },
      );
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  //--- Get Trailers ---//

  Future<void> getTrailers() async {
    isLoading.value = true;
    try {
      final result = await categoryRepository.getTrailers();
      result.fold(
        (l) {
          isError.value = true;
          errorMessage.value = l;
        },
        (r) {
          isError.value = false;
          bannersList.assignAll(r);
          // Only update the carousel widget when list initially loads
          update(['banners_list']);
        },
      );
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  //--- Get Movies ---//
  Future<void> getMovies() async {
    isLoading.value = true;
    try {
      final result = await categoryRepository.getAllMovies();
      result.fold(
        (l) {
          isError.value = true;
          errorMessage.value = l;
        },
        (r) {
          isError.value = false;
          movies.assignAll(r);
        },
      );
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  //--- Get Reminders ---//
  Future<void> getReminders() async {
    isLoading.value = true;
    try {
      final result = await categoryRepository.getReminders();
      result.fold(
        (l) {
          isError.value = true;
          errorMessage.value = l;
        },
        (r) {
          isError.value = false;
          reminders.assignAll(r);
        },
      );
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  //--- Refresh All Data (Pull to Refresh) ---//
  Future<void> refreshHomeData() async {
    try {
      // Load all data in parallel for better performance
      await Future.wait([
        getCategories(),
        getMovies(),
        getTrailers(),
        getReminders(),
      ]);

      Get.snackbar(
        'Refreshed',
        'Home data updated successfully',
        colorText: AppColors.white,
        backgroundColor: AppColors.red2.withValues(alpha: 0.8),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to refresh data',
        colorText: AppColors.white,
        backgroundColor: AppColors.red2,
      );
    }
  }

  //--- Carousel Methods ---//
  void _onPageControllerChanged() {
    if (!carouselPageController.hasClients) return;

    // Only update when scrolling is complete to avoid jank during animation
    if (!carouselPageController.position.isScrollingNotifier.value) {
      final page = carouselPageController.page?.round() ?? 0;
      if (carouselCurrentIndex.value != page) {
        final oldIndex = carouselCurrentIndex.value;
        carouselCurrentIndex.value = page;
        // Use post-frame callback to batch updates and reduce jank
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Only update the specific cards that changed (old center and new center)
          // This minimizes rebuilds during auto-scroll
          update(['carousel_index_$oldIndex', 'carousel_index_$page']);
        });
      }
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!isUserScrolling.value &&
          bannersList.isNotEmpty &&
          carouselPageController.hasClients) {
        final nextIndex = (carouselCurrentIndex.value + 1) % bannersList.length;
        // Use a smoother animation curve and slightly longer duration
        // This reduces jank by giving the GPU more time to render
        carouselPageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void onCarouselPageChanged(int index) {
    // Debounce rapid page changes to prevent excessive rebuilds
    if (carouselCurrentIndex.value != index) {
      final oldIndex = carouselCurrentIndex.value;
      carouselCurrentIndex.value = index;
      // Use post-frame callback to batch updates and reduce jank
      // This ensures updates happen after the frame is rendered
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Only update the specific cards that changed (old center and new center)
        // This minimizes rebuilds during auto-scroll
        if (oldIndex >= 0 && oldIndex < bannersList.length) {
          update(['carousel_index_$oldIndex']);
        }
        if (index >= 0 && index < bannersList.length) {
          update(['carousel_index_$index']);
        }
      });
    }
  }

  void onCarouselScrollStart() {
    isUserScrolling.value = true;
  }

  void onCarouselScrollEnd() {
    // Reset after a delay to allow auto-scroll to resume
    Future.delayed(const Duration(seconds: 2), () {
      isUserScrolling.value = false;
    });
  }

  void toggleCarouselBookmark(String title, String id) {
    final wasBookmarked = bookmarkedMovies.contains(title);
    if (wasBookmarked) {
      bookmarkedMovies.remove(title);
    } else {
      bookmarkedMovies.add(title);
    }
    // Only update the specific card whose bookmark changed
    // Find the index of the card with this title
    final index = bannersList.indexWhere((trailer) => trailer.title == title);
    if (index != -1) {
      update(['carousel_bookmark_$index']);
    }
    // Call the original bookmark tap handler
    onBookmarkTap(title, id, ReferenceType.Trailer);
  }

  //--- onClose ---//
  @override
  void onClose() {
    _debounceTimer?.cancel();
    _autoScrollTimer?.cancel();
    carouselPageController.removeListener(_onPageControllerChanged);
    carouselPageController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
