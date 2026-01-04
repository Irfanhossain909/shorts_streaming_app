import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/utils/enum/enum.dart';
import 'package:testemu/core/utils/log/app_log.dart';
import 'package:testemu/features/home/model/banner_model.dart';
import 'package:testemu/features/home/model/category_model.dart';
import 'package:testemu/features/home/model/movie_model.dart';
import 'package:testemu/features/home/model/remainder_model.dart';
import 'package:testemu/features/home/repository/category_repository.dart';

class HomeController extends GetxController {
  CategoryRepository categoryRepository = CategoryRepository.instance;

  // Observable variables
  var selectedCategory = 'popular'.obs;
  var selectedMyListCategory = 'Recently Watched'.obs;
  var selectedLibraryCategory = 'Most Popular'.obs;
  var selectedVipFilter = 'Daily'.obs;
  var selectedRankingFilter = 'Most Popular'.obs;
  var userName = 'Designjot'.obs;
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
  void onInit() {
    super.onInit();
    // Initialize carousel
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
  }

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

  // Current VIP movies based on selected filter
  List<Movie> get currentVipMovies {
    return filteredMoviesBySelectedCategory
        .where((movie) => movie.categoryId == selectedVipFilter.value)
        .toList();
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
    Get.toNamed(AppRoutes.videoPlayer, arguments: {'videoUrl': videoUrl});
  }

  Future<void> onBookmarkTap(
    String title,
    String id,
    ReferenceType referenceType,
  ) async {
    final result = await categoryRepository.toggleBookmark(
      id,
      referenceType.name,
    );
    result.fold(
      (l) {
        Get.snackbar(
          'Bookmark',
          'Added $title to bookmarks',
          colorText: AppColors.background,
        );
      },
      (r) {
        Get.snackbar(
          'Bookmark',
          'Removed $title from bookmarks',
          colorText: AppColors.background,
        );
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

  //--- Carousel Methods ---//
  void _onPageControllerChanged() {
    if (!carouselPageController.hasClients) return;

    if (!carouselPageController.position.isScrollingNotifier.value) {
      final page = carouselPageController.page?.round() ?? 0;
      if (carouselCurrentIndex.value != page) {
        final oldIndex = carouselCurrentIndex.value;
        carouselCurrentIndex.value = page;
        // Only update the specific cards that changed (old center and new center)
        update(['carousel_index_$oldIndex', 'carousel_index_$page']);
      }
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!isUserScrolling.value &&
          bannersList.isNotEmpty &&
          carouselPageController.hasClients) {
        final nextIndex = (carouselCurrentIndex.value + 1) % bannersList.length;
        carouselPageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void onCarouselPageChanged(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (carouselCurrentIndex.value != index) {
        final oldIndex = carouselCurrentIndex.value;
        carouselCurrentIndex.value = index;
        // Only update the specific cards that changed (old center and new center)
        // This minimizes rebuilds
        update(['carousel_index_$oldIndex', 'carousel_index_$index']);
      }
    });
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
