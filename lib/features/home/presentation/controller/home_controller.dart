import 'package:get/get.dart';

class HomeController extends GetxController {
  // Observable variables
  var selectedCategory = 'Popular'.obs;
  var userName = 'Designjot'.obs;

  // Categories
  final List<String> categories = [
    'Popular',
    'New',
    'Originals',
    'VIP',
    'Ranking',
  ];

  // Featured movie
  final featuredMovie = {
    'title': 'ETHERION',
    'duration': 'in 50 min',
    'imageUrl':
        'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=500&h=300&fit=crop',
  };

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
        'title': 'Love After Marriage',
        'imageUrl':
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&h=300&fit=crop',
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
      {
        'title': 'Modern Love Story',
        'imageUrl':
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200&h=300&fit=crop',
        'badge': 'NEW',
      },
    ],
    'Originals': [
      {
        'title': 'Alpha\'s Fake or Fated Mate',
        'imageUrl':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=300&fit=crop',
        'badge': 'ORIGINAL',
      },
      {
        'title': 'The Original Series',
        'imageUrl':
            'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=200&h=300&fit=crop',
        'badge': 'ORIGINAL',
      },
      {
        'title': 'Exclusive Content',
        'imageUrl':
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200&h=300&fit=crop',
        'badge': 'ORIGINAL',
      },
      {
        'title': 'Premium Original',
        'imageUrl':
            'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=200&h=300&fit=crop',
        'badge': 'ORIGINAL',
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
      {
        'title': 'Exclusive VIP Content',
        'imageUrl':
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&h=300&fit=crop',
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
      {
        'title': 'Best of the Year',
        'imageUrl':
            'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=200&h=300&fit=crop',
        'badge': '#4',
      },
    ],
  };

  // Current filtered movies based on selected category
  List<Map<String, dynamic>> get movies {
    return categoryMovies[selectedCategory.value] ?? [];
  }

  // Methods
  void selectCategory(String category) {
    selectedCategory.value = category;
    // Trigger UI update by calling update() to refresh the movies grid
    update();
  }

  void onMovieTap(String title) {
    // Handle movie tap
    Get.snackbar('Movie Selected', title);
  }

  void onWatchTap() {
    // Handle watch button tap
    Get.snackbar('Watch', 'Starting ${featuredMovie['title']}');
  }

  void onBookmarkTap() {
    // Handle bookmark tap
    Get.snackbar('Bookmark', 'Added to bookmarks');
  }
}
