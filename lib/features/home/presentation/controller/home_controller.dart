import 'package:get/get.dart';
import 'dart:async';

import 'package:testemu/core/constants/app_images.dart';

class HomeController extends GetxController {
  // Observable variables
  var selectedCategory = 'Popular'.obs;
  var selectedMyListCategory = 'Recently Watched'.obs;
  var selectedLibraryCategory = 'Most Popular'.obs;
  var selectedVipFilter = 'Daily'.obs;
  var selectedRankingFilter = 'Most Popular'.obs;
  var userName = 'Designjot'.obs;
  var isHeaderSticky = false.obs;

  // Debounce timer for smooth state updates
  Timer? _debounceTimer;

  // Categories
  final List<String> categories = [
    'Popular',
    'New',
    'VIP',
    'Ranking',
    'Mystery',
    'Romance',
    'Fantasy',
    'Library',
  ];

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

  // Featured movies for carousel
  final List<Map<String, dynamic>> featuredMovies = [
    {
      'title': 'ETHERION',
      'duration': 'in 50 min',
      'imageUrl':
          'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=500&h=300&fit=crop',
    },
    {
      'title': 'APEX LEGENDS',
      'duration': 'in 45 min',
      'imageUrl':
          'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=500&h=300&fit=crop',
    },
    {
      'title': 'CYBERNIGHT',
      'duration': 'in 60 min',
      'imageUrl':
          'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=500&h=300&fit=crop',
    },
    {
      'title': 'SHADOWBORN',
      'duration': 'in 38 min',
      'imageUrl':
          'https://images.unsplash.com/photo-1489599735734-79b4fe286040?w=500&h=300&fit=crop',
    },
    {
      'title': 'NEON DREAMS',
      'duration': 'in 55 min',
      'imageUrl':
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=500&h=300&fit=crop',
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
      'title': 'The Mark of Hell',
      'imageUrl': AppImages.m8,

      'subtitle': 'Exclusive series',
      // 'imageUrl':
      //     'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&h=300&fit=crop',
      'views': '48.2K',
    },
    {
      'title': 'Married First, Loved Later',
      'subtitle': 'Romance drama',
      'imageUrl':
          'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200&h=300&fit=crop',
      'views': '69.3K',
    },
    {
      'title': 'Married First, Loved Later',
      'subtitle': 'Romance drama',
      'imageUrl':
          'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200&h=300&fit=crop',
      'views': '69.3K',
    },
    {
      'title': 'Married First, Loved Later',
      'subtitle': 'Romance drama',
      'imageUrl':
          'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200&h=300&fit=crop',
      'views': '69.3K',
    },
    {
      'title': 'Married First, Loved Later',
      'subtitle': 'Romance drama',
      'imageUrl':
          'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200&h=300&fit=crop',
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
  List<Map<String, dynamic>> get movies {
    return categoryMovies[selectedCategory.value] ?? [];
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
    selectedCategory.value = category;
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

  void onMovieTap(String title) {
    Get.snackbar('Movie Selected', title);
  }

  void onWatchTap(String title) {
    Get.snackbar('Watch', 'Starting $title');
  }

  void onBookmarkTap(String title) {
    Get.snackbar('Bookmark', 'Added $title to bookmarks');
  }

  void onRemindMeTap(String title) {
    Get.snackbar(
      'Reminder Set',
      'You will be notified when $title is available',
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

  @override
  void onClose() {
    _debounceTimer?.cancel();
    super.onClose();
  }
}
