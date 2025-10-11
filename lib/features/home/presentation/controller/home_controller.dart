import 'package:get/get.dart';
import 'dart:async';

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
        'title': 'Second Life, the Godfather\'s Wife',
        'subtitle': 'During the appointment ceremony...',
        'imageUrl':
            'https://images.unsplash.com/photo-1489599735734-79b4fe286040?w=200&h=300&fit=crop',
        'badge': 'VIP',
        'ranking': '1',
      },
      {
        'title': 'Second Life, the Godfather\'s wife',
        'subtitle': 'During the appointment ceremony...',
        'imageUrl':
            'https://images.unsplash.com/photo-1494790108755-2616c9c0b8d3?w=200&h=300&fit=crop',
        'badge': 'VIP',
        'ranking': '2',
      },
      {
        'title': 'Second Life, the Godfather\'s Wife',
        'subtitle': 'During the appointment ceremony...',
        'imageUrl':
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=300&fit=crop',
        'badge': 'VIP',
        'ranking': '3',
      },
      {
        'title': 'Second Life, the Godfather\'s Wife',
        'subtitle': 'During the appointment ceremony...',
        'imageUrl':
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&h=300&fit=crop',
        'badge': 'VIP',
        'ranking': '5',
      },
      {
        'title': 'Second Life, the Godfather\'s Wife',
        'subtitle': 'During the appointment ceremony...',
        'imageUrl':
            'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200&h=300&fit=crop',
        'badge': 'VIP',
        'ranking': '6',
      },
    ],
    'Weekly': [
      {
        'title': 'Elite Weekly Romance',
        'subtitle': 'Weekly exclusive content...',
        'imageUrl':
            'https://images.unsplash.com/photo-1506863530036-1efeddceb993?w=200&h=300&fit=crop',
        'badge': 'VIP',
        'ranking': '1',
      },
      {
        'title': 'Premium Weekly Drama',
        'subtitle': 'Weekly premium series...',
        'imageUrl':
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&h=300&fit=crop',
        'badge': 'VIP',
        'ranking': '2',
      },
      {
        'title': 'Weekly VIP Special',
        'subtitle': 'Special weekly episodes...',
        'imageUrl':
            'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=200&h=300&fit=crop',
        'badge': 'VIP',
        'ranking': '3',
      },
    ],
  };

  // Coming Soon movies
  final List<Map<String, dynamic>> comingSoonMovies = [
    {
      'title': 'Second Life, the Godfather\'s Wife',
      'subtitle': 'Reborn True Princess Returns',
      'imageUrl':
          'https://images.unsplash.com/photo-1489599735734-79b4fe286040?w=200&h=300&fit=crop',
      'releaseDate': '04/24/2025',
    },
    {
      'title': 'Reborn True Princess Returns',
      'subtitle': 'Alpha\'s Fake or Fated Mate',
      'imageUrl':
          'https://images.unsplash.com/photo-1494790108755-2616c9c0b8d3?w=200&h=300&fit=crop',
      'releaseDate': '04/24/2025',
    },
    {
      'title': 'Alpha\'s Fake or Fated Mate',
      'subtitle': 'Married First, Loved Later',
      'imageUrl':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=300&fit=crop',
      'releaseDate': '03/24/2025',
    },
  ];

  // Only on Thisflix movies
  final List<Map<String, dynamic>> onlyOnThisflixMovies = [
    {
      'title': 'The Payback Plan',
      'subtitle': 'Exclusive series',
      'imageUrl':
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&h=300&fit=crop',
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
        'title': 'Second Life, The Godfather\'s Wife',
        'imageUrl':
            'https://images.unsplash.com/photo-1489599735734-79b4fe286040?w=200&h=300&fit=crop',
        'badge': 'POPULAR',
      },
      {
        'title': 'My Poor Ex-wife is a Hidden Heiress',
        'imageUrl':
            'https://images.unsplash.com/photo-1494790108755-2616c9c0b8d3?w=200&h=300&fit=crop',
        'badge': 'POPULAR',
      },
      {
        'title': 'The Billionaire\'s Secret',
        'imageUrl':
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=300&fit=crop',
        'badge': 'POPULAR',
      },
      {
        'title': 'Second Life, The Godfather\'s Wife',
        'imageUrl':
            'https://images.unsplash.com/photo-1489599735734-79b4fe286040?w=200&h=300&fit=crop',
        'badge': 'POPULAR',
      },
      {
        'title': 'My Poor Ex-wife is a Hidden Heiress',
        'imageUrl':
            'https://images.unsplash.com/photo-1494790108755-2616c9c0b8d3?w=200&h=300&fit=crop',
        'badge': 'POPULAR',
      },
      {
        'title': 'The Billionaire\'s Secret',
        'imageUrl':
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=300&fit=crop',
        'badge': 'POPULAR',
      },
    ],
    'New': [
      {
        'title': 'Reborn True Princess Returns',
        'imageUrl':
            'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=200&h=300&fit=crop',
        'badge': 'NEW',
      },
      {
        'title': 'The New Beginning',
        'imageUrl':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=300&fit=crop',
        'badge': 'NEW',
      },
      {
        'title': 'Fresh Start Romance',
        'imageUrl':
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&h=300&fit=crop',
        'badge': 'NEW',
      },
    ],
    'VIP': [
      {
        'title': 'The CEO\'s Substitute Wife',
        'imageUrl':
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=300&fit=crop',
        'badge': 'VIP',
      },
      {
        'title': 'Elite Romance',
        'imageUrl':
            'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200&h=300&fit=crop',
        'badge': 'VIP',
      },
      {
        'title': 'Premium Love Story',
        'imageUrl':
            'https://images.unsplash.com/photo-1506863530036-1efeddceb993?w=200&h=300&fit=crop',
        'badge': 'VIP',
      },
    ],
    'Ranking': [
      {
        'title': 'Return of that Mysterious Girl',
        'imageUrl':
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&h=300&fit=crop',
        'badge': '#1',
      },
      {
        'title': 'Top Rated Romance',
        'imageUrl':
            'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?w=200&h=300&fit=crop',
        'badge': '#2',
      },
      {
        'title': 'Highest Rated Drama',
        'imageUrl':
            'https://images.unsplash.com/photo-1479936343636-73cdc5aae0c3?w=200&h=300&fit=crop',
        'badge': '#3',
      },
    ],
  };

  // Ranking movies data with different filters
  final Map<String, List<Map<String, dynamic>>> rankingMovies = {
    'Most Popular': [
      {
        'title': 'Lycan Princess Won\'t Be Your Luna',
        'subtitle': 'The Wolf King love opera her coldest and the set...',
        'imageUrl':
            'https://images.unsplash.com/photo-1489599735734-79b4fe286040?w=200&h=300&fit=crop',
        'ranking': 1,
        'isHot': true,
      },
      {
        'title': 'Lycan Princess Won\'t Be Your Luna',
        'subtitle': 'The Wolf King love opera her coldest and the set...',
        'imageUrl':
            'https://images.unsplash.com/photo-1494790108755-2616c9c0b8d3?w=200&h=300&fit=crop',
        'ranking': 2,
        'isHot': true,
      },
      {
        'title': 'Lycan Princess Won\'t Be Your Luna',
        'subtitle': 'The Wolf King love opera her coldest and the set...',
        'imageUrl':
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=300&fit=crop',
        'ranking': 3,
        'isHot': true,
      },
      {
        'title': 'Lycan Princess Won\'t Be Your Luna',
        'subtitle': 'The Wolf King love opera her coldest and the set...',
        'imageUrl':
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&h=300&fit=crop',
        'ranking': 4,
        'isHot': true,
      },
      {
        'title': 'Lycan Princess Won\'t Be Your Luna',
        'subtitle': 'The Wolf King love opera her coldest and the set...',
        'imageUrl':
            'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=200&h=300&fit=crop',
        'ranking': 5,
        'isHot': true,
      },
    ],
    'Hottest': [
      {
        'title': 'The CEO\'s Secret Romance',
        'subtitle': 'A billionaire falls for his assistant in this hot...',
        'imageUrl':
            'https://images.unsplash.com/photo-1506863530036-1efeddceb993?w=200&h=300&fit=crop',
        'ranking': 1,
        'isHot': true,
      },
      {
        'title': 'Forbidden Love Story',
        'subtitle': 'Two hearts that shouldn\'t be together but...',
        'imageUrl':
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&h=300&fit=crop',
        'ranking': 2,
        'isHot': true,
      },
      {
        'title': 'Passionate Nights',
        'subtitle': 'A steamy romance that will keep you hooked...',
        'imageUrl':
            'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=200&h=300&fit=crop',
        'ranking': 3,
        'isHot': true,
      },
    ],
    'New Series': [
      {
        'title': 'Fresh Start Romance',
        'subtitle': 'A new beginning leads to unexpected love...',
        'imageUrl':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=300&fit=crop',
        'ranking': 1,
        'isHot': false,
      },
      {
        'title': 'The New Chapter',
        'subtitle': 'Starting over has never been this exciting...',
        'imageUrl':
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&h=300&fit=crop',
        'ranking': 2,
        'isHot': false,
      },
      {
        'title': 'Modern Love Tales',
        'subtitle': 'Contemporary romance for the digital age...',
        'imageUrl':
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200&h=300&fit=crop',
        'ranking': 3,
        'isHot': false,
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
