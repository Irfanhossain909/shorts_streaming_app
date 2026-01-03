import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
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
  final List<String> rankingFilters = ['Most Popular', 'Hottest', 'New Series'];

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

  // Featured movies for carousel
  final List<Map<String, dynamic>> featuredMovies = [
    {
      'title': 'Eternal Fog',
      'duration': 'in 50 min',
      'imageUrl': AppImages.m1,
      // 'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=500&h=300&fit=crop',
    },
    {
      'title': ' The Stairs of Terror',
      'duration': 'in 45 min',
      'imageUrl': AppImages.m3,
      // 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=500&h=300&fit=crop',
    },
    {
      'title': 'The Human Beast',
      'duration': 'in 60 min',
      'imageUrl': AppImages.m5,
      // 'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=500&h=300&fit=crop',
    },
    {
      'title': 'The Mayan Mummies',
      'duration': 'in 38 min',
      'imageUrl': AppImages.m6,
      // 'https://images.unsplash.com/photo-1489599735734-79b4fe286040?w=500&h=300&fit=crop',
    },
    {
      'title': ' The Guardian of the Threshold',
      'duration': 'in 55 min',
      'imageUrl': AppImages.m7,
      // 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=500&h=300&fit=crop',
    },
  ];

  // VIP Movies data with Daily/Weekly filters
  final Map<String, List<Map<String, dynamic>>> vipMovies = {
    'Daily': [
      {
        'title': 'The Stairs of Terror',
        'imageUrl': AppImages.m13,

        'subtitle': 'During the appointment ceremony...',
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1489599735734-79b4fe286040?w=200&h=300&fit=crop',
        'badge': 'VIP',
        'ranking': '1',
      },
      {
        'title': 'The Wilson Sisters ',
        'imageUrl': AppImages.m12,
        'subtitle': 'During the appointment ceremony...',
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1494790108755-2616c9c0b8d3?w=200&h=300&fit=crop',
        'badge': 'VIP',
        'ranking': '2',
      },
      {
        'title': ' The Human Beast',
        'imageUrl': AppImages.m11,
        'subtitle': 'During the appointment ceremony...',
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=300&fit=crop',
        'badge': 'VIP',
        'ranking': '3',
      },
      {
        'title': ' The Mayan Mummies',
        'imageUrl': AppImages.m9,
        'subtitle': 'During the appointment ceremony...',
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&h=300&fit=crop',
        'badge': 'VIP',
        'ranking': '5',
      },
      {
        'title': ' The Guardian of the Threshold',
        'imageUrl': AppImages.m13,

        'subtitle': 'During the appointment ceremony...',
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200&h=300&fit=crop',
        'badge': 'VIP',
        'ranking': '6',
      },
    ],
    'Weekly': [
      {
        'title': ' The Mayan Mummies',
        'imageUrl': AppImages.m9,
        'subtitle': 'During the appointment ceremony...',
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&h=300&fit=crop',
        'badge': 'VIP',
        'ranking': '5',
      },
      {
        'title': ' The Guardian of the Threshold',
        'imageUrl': AppImages.m13,

        'subtitle': 'During the appointment ceremony...',
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200&h=300&fit=crop',
        'badge': 'VIP',
        'ranking': '6',
      },
      {
        'title': ' The Mayan Mummies',
        'imageUrl': AppImages.m9,
        'subtitle': 'During the appointment ceremony...',
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&h=300&fit=crop',
        'badge': 'VIP',
        'ranking': '5',
      },
      {
        'title': ' The Guardian of the Threshold',
        'imageUrl': AppImages.m13,

        'subtitle': 'During the appointment ceremony...',
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200&h=300&fit=crop',
        'badge': 'VIP',
        'ranking': '6',
      },
    ],
  };

  // Coming Soon movies
  final List<Map<String, dynamic>> comingSoonMovies = [
    {
      'title': 'Eternal Fog',
      'imageUrl': AppImages.m1,

      'subtitle': 'During the appointment ceremony...',
      // 'imageUrl':
      //     'https://images.unsplash.com/photo-1489599735734-79b4fe286040?w=200&h=300&fit=crop',
      'releaseDate': '04/24/2025',
    },
    {
      'title': ' Paranormal Phenomeno',
      'imageUrl': AppImages.m2,
      'subtitle': 'During the appointment ceremony...',
      // 'imageUrl':
      //     'https://images.unsplash.com/photo-1494790108755-2616c9c0b8d3?w=200&h=300&fit=crop',
      'releaseDate': '04/24/2025',
    },
    {
      'title': ' The Stairs of Terror',
      'imageUrl': AppImages.m3,
      'subtitle': 'During the appointment ceremony...',
      // 'imageUrl':
      //     'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=300&fit=crop',
      'releaseDate': '04/24/2025',
    },
    {
      'title': '  The Wilson Sisters',
      'imageUrl': AppImages.m4,
      'subtitle': 'During the appointment ceremony...',
      // 'imageUrl':
      //     'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&h=300&fit=crop',
      'releaseDate': '04/24/2025',
    },
    {
      'title': ' The Human Beast',
      'imageUrl': AppImages.m5,

      'subtitle': 'During the appointment ceremony...',
      // 'imageUrl':
      //     'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200&h=300&fit=crop',
      'releaseDate': '04/24/2025',
    },
    {
      'title': ' The Mayan Mummies',
      'imageUrl': AppImages.m6,

      'subtitle': 'Married First, Loved Later',
      // 'imageUrl':
      //     'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=300&fit=crop',
      'releaseDate': '03/24/2025',
    },
    {
      'title': ' The Mayan Mummies',
      'imageUrl': AppImages.m7,

      'subtitle': 'Reborn True Princess Returns',
      // 'imageUrl':
      //     'https://images.unsplash.com/photo-1489599735734-79b4fe286040?w=200&h=300&fit=crop',
      'releaseDate': '04/24/2025',
    },
    {
      'title': ' The Guardian of the Threshold',
      'imageUrl': AppImages.m13,
      'subtitle': 'Alpha\'s Fake or Fated Mate',
      // 'imageUrl':
      //     'https://images.unsplash.com/photo-1494790108755-2616c9c0b8d3?w=200&h=300&fit=crop',
      'releaseDate': '04/24/2025',
    },
    {
      'title': 'The Mark of Hell',
      'imageUrl': AppImages.m8,

      'subtitle': 'Married First, Loved Later',
      // 'imageUrl':
      //     'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=300&fit=crop',
      'releaseDate': '03/24/2025',
    },
  ];

  // Only on Thisflix movies
  final List<Map<String, dynamic>> onlyOnThisflixMovies = [
    {
      'title': ' Eternal Fog',
      'imageUrl': AppImages.m1,

      'subtitle': 'Exclusive series',
      // 'imageUrl':
      //     'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&h=300&fit=crop',
      'views': '48.2K',
    },
    {
      'title': ' Paranormal Phenomenon',
      'subtitle': 'Romance drama',
      'imageUrl': AppImages.m2,
      // 'imageUrl':
      //     'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200&h=300&fit=crop',
      'views': '69.3K',
    },
    {
      'title': ' The Stairs of Terror',
      'subtitle': 'Romance drama',
      'imageUrl': AppImages.m3,
      // 'imageUrl':
      //     'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200&h=300&fit=crop',
      'views': '69.3K',
    },
    {
      'title': ' The Wilson Sisters',
      'subtitle': 'Romance drama',
      'imageUrl': AppImages.m4,
      // 'imageUrl':
      //     'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200&h=300&fit=crop',
      'views': '69.3K',
    },
    {
      'title': ' The Human Beast',
      'subtitle': 'Romance drama',
      'imageUrl': AppImages.m5,
      // 'imageUrl':
      //     'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200&h=300&fit=crop',
      'views': '69.3K',
    },
  ];

  // Category-specific movie data
  final Map<String, List<Map<String, dynamic>>> categoryMovies = {
    'Popular': [
      {
        'title': 'The Stairs of Terror',
        'imageUrl': AppImages.m13,
        // 'https://images.unsplash.com/photo-1489599735734-79b4fe286040?w=200&h=300&fit=crop',
        'badge': 'POPULAR',
      },
      {
        'title': 'The Wilson Sisters ',
        'imageUrl': AppImages.m12,
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1494790108755-2616c9c0b8d3?w=200&h=300&fit=crop',
        'badge': 'POPULAR',
      },
      {
        'title': ' The Human Beast',
        'imageUrl': AppImages.m11,
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=300&fit=crop',
        'badge': 'POPULAR',
      },
      {
        'title': ' The Mayan Mummies',
        'imageUrl': AppImages.m9,
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1489599735734-79b4fe286040?w=200&h=300&fit=crop',
        'badge': 'POPULAR',
      },
      {
        'title': ' The Guardian of the Threshold',
        'imageUrl': AppImages.m13,
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1494790108755-2616c9c0b8d3?w=200&h=300&fit=crop',
        'badge': 'POPULAR',
      },
      {
        'title': 'The Mark of Hell',
        'imageUrl': AppImages.m8,
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=300&fit=crop',
        'badge': 'POPULAR',
      },
    ],
    'New': [
      {
        'title': 'The Stairs of Terror ',
        'imageUrl': AppImages.m7,
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=200&h=300&fit=crop',
        'badge': 'NEW',
      },
      {
        'title': 'The Stairs of Terror',
        'imageUrl': AppImages.m13,
        // 'https://images.unsplash.com/photo-1489599735734-79b4fe286040?w=200&h=300&fit=crop',
        'badge': 'POPULAR',
      },
      {
        'title': 'The Wilson Sisters ',
        'imageUrl': AppImages.m12,
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1494790108755-2616c9c0b8d3?w=200&h=300&fit=crop',
        'badge': 'POPULAR',
      },
      {
        'title': ' The Human Beast',
        'imageUrl': AppImages.m11,
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=300&fit=crop',
        'badge': 'POPULAR',
      },
      {
        'title': ' The Mayan Mummies',
        'imageUrl': AppImages.m9,
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1489599735734-79b4fe286040?w=200&h=300&fit=crop',
        'badge': 'POPULAR',
      },
      {
        'title': ' The Guardian of the Threshold',
        'imageUrl': AppImages.m13,
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1494790108755-2616c9c0b8d3?w=200&h=300&fit=crop',
        'badge': 'POPULAR',
      },
      {
        'title': 'The Mark of Hell',
        'imageUrl': AppImages.m8,
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=300&fit=crop',
        'badge': 'POPULAR',
      },
    ],
    'VIP': [
      {
        'title': ' The Hyena of Terror',
        'imageUrl': AppImages.m4,
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=300&fit=crop',
        'badge': 'VIP',
      },
      {
        'title': 'The Silent Echo ',
        'imageUrl': AppImages.m3,
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200&h=300&fit=crop',
        'badge': 'VIP',
      },
      {
        'title': ' Shadows of Awakening',
        'imageUrl': AppImages.m2,
        // 'https://images.unsplash.com/photo-1506863530036-1efeddceb993?w=200&h=300&fit=crop',
        'badge': 'VIP',
      },
    ],
    'Ranking': [
      {
        'title': 'The Last Page ',
        'imageUrl': AppImages.m1,
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&h=300&fit=crop',
        'badge': '#1',
      },
      {
        'title': 'The Silent Echo ',
        'imageUrl': AppImages.m3,
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200&h=300&fit=crop',
        'badge': 'VIP',
      },
      {
        'title': ' Shadows of Awakening',
        'imageUrl': AppImages.m2,
        // 'https://images.unsplash.com/photo-1506863530036-1efeddceb993?w=200&h=300&fit=crop',
        'badge': 'VIP',
      },
    ],
  };

  // Ranking movies data with different filters
  final Map<String, List<Map<String, dynamic>>> rankingMovies = {
    'Most Popular': [
      {
        'title': ' Shadows of Awakening',
        'imageUrl': AppImages.m2,
        'subtitle': 'The Wolf King love opera her coldest and the set...',
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1489599735734-79b4fe286040?w=200&h=300&fit=crop',
        'ranking': 1,
        'isHot': true,
      },
      {
        'title': 'The Silent Echo ',
        'imageUrl': AppImages.m3,
        'subtitle': 'The Wolf King love opera her coldest and the set...',
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1494790108755-2616c9c0b8d3?w=200&h=300&fit=crop',
        'ranking': 2,
        'isHot': true,
      },
      {
        'title': 'The Stairs of Terror',
        'imageUrl': AppImages.m13,
        'subtitle': 'The Wolf King love opera her coldest and the set...',
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=300&fit=crop',
        'ranking': 3,
        'isHot': true,
      },
      {
        'title': 'The Stairs of Terror',
        'imageUrl': AppImages.m12,
        'subtitle': 'The Wolf King love opera her coldest and the set...',
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&h=300&fit=crop',
        'ranking': 4,
        'isHot': true,
      },
      {
        'title': 'The Stairs of Terror',
        'imageUrl': AppImages.m13,
        'subtitle': 'The Wolf King love opera her coldest and the set...',
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200&h=300&fit=crop',
        'ranking': 5,
        'isHot': true,
      },
    ],
    'Hottest': [
      {
        'title': 'The Stairs of Terror',
        'imageUrl': AppImages.m12,
        'subtitle': 'The Wolf King love opera her coldest and the set...',
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&h=300&fit=crop',
        'ranking': 4,
        'isHot': true,
      },
      {
        'title': ' Shadows of Awakening',
        'imageUrl': AppImages.m2,
        'subtitle': 'The Wolf King love opera her coldest and the set...',
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1489599735734-79b4fe286040?w=200&h=300&fit=crop',
        'ranking': 1,
        'isHot': true,
      },
      {
        'title': 'The Silent Echo ',
        'imageUrl': AppImages.m3,
        'subtitle': 'The Wolf King love opera her coldest and the set...',
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1494790108755-2616c9c0b8d3?w=200&h=300&fit=crop',
        'ranking': 2,
        'isHot': true,
      },
      {
        'title': 'The Stairs of Terror',
        'imageUrl': AppImages.m13,
        'subtitle': 'The Wolf King love opera her coldest and the set...',
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=300&fit=crop',
        'ranking': 3,
        'isHot': true,
      },
      {
        'title': 'The Stairs of Terror',
        'imageUrl': AppImages.m13,
        'subtitle': 'The Wolf King love opera her coldest and the set...',
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200&h=300&fit=crop',
        'ranking': 5,
        'isHot': true,
      },
    ],
    'New Series': [
      {
        'title': 'The Stairs of Terror',
        'imageUrl': AppImages.m13,
        'subtitle': 'The Wolf King love opera her coldest and the set...',
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=300&fit=crop',
        'ranking': 3,
        'isHot': true,
      },
      {
        'title': 'The Stairs of Terror',
        'imageUrl': AppImages.m12,
        'subtitle': 'The Wolf King love opera her coldest and the set...',
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&h=300&fit=crop',
        'ranking': 4,
        'isHot': true,
      },
      {
        'title': 'The Stairs of Terror',
        'imageUrl': AppImages.m13,
        'subtitle': 'The Wolf King love opera her coldest and the set...',
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200&h=300&fit=crop',
        'ranking': 5,
        'isHot': true,
      },
      {
        'title': ' Shadows of Awakening',
        'imageUrl': AppImages.m2,
        'subtitle': 'The Wolf King love opera her coldest and the set...',
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1489599735734-79b4fe286040?w=200&h=300&fit=crop',
        'ranking': 1,
        'isHot': true,
      },
      {
        'title': 'The Silent Echo ',
        'imageUrl': AppImages.m3,
        'subtitle': 'The Wolf King love opera her coldest and the set...',
        // 'imageUrl':
        //     'https://images.unsplash.com/photo-1494790108755-2616c9c0b8d3?w=200&h=300&fit=crop',
        'ranking': 2,
        'isHot': true,
      },
    ],
    'Mystery': [
      {
        'title': 'The Mystery Case',
        'imageUrl':
            'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=200&h=300&fit=crop',
        'badge': 'MYSTERY',
      },
      {
        'title': 'Hidden Secrets',
        'imageUrl':
            'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=200&h=300&fit=crop',
        'badge': 'MYSTERY',
      },
    ],
    'Romance': [
      {
        'title': 'Love Story',
        'imageUrl':
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200&h=300&fit=crop',
        'badge': 'ROMANCE',
      },
      {
        'title': 'Heart to Heart',
        'imageUrl':
            'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=200&h=300&fit=crop',
        'badge': 'ROMANCE',
      },
    ],
  };

  // Current filtered movies based on selected category
  List<Map<String, dynamic>> get currentMovies {
    return categoryMovies[selectedCategory.value] ?? [];
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

  // Current VIP movies based on selected filter
  List<Map<String, dynamic>> get currentVipMovies {
    return vipMovies[selectedVipFilter.value] ?? [];
  }

  // Current ranking movies based on selected filter
  List<Map<String, dynamic>> get currentRankingMovies {
    return rankingMovies[selectedRankingFilter.value] ?? [];
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
      if (!isUserScrolling.value && bannersList.isNotEmpty) {
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
    super.onClose();
  }
}
