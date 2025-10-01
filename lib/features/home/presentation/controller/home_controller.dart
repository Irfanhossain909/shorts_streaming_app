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

  // Movie list
  final List<Map<String, dynamic>> movies = [
    {
      'title': 'Second Life, The Godfather\'s Wife',
      'imageUrl':
          'https://images.unsplash.com/photo-1489599735734-79b4fe286040?w=200&h=300&fit=crop',
      'badge': null,
    },
    {
      'title': 'Reborn True Princess Returns',
      'imageUrl':
          'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=200&h=300&fit=crop',
      'badge': 'NEW',
    },
    {
      'title': 'Alpha\'s Fake or Fated Mate',
      'imageUrl':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=300&fit=crop',
      'badge': null,
    },
    {
      'title': 'My Poor Ex-wife is a Hidden Heiress',
      'imageUrl':
          'https://images.unsplash.com/photo-1494790108755-2616c9c0b8d3?w=200&h=300&fit=crop',
      'badge': 'POPULAR',
    },
    {
      'title': 'Return of that Mysterious Girl',
      'imageUrl':
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&h=300&fit=crop',
      'badge': 'POPULAR',
    },
    {
      'title': 'MOVE ASIDE! I\'M THE EX BEYOND YOUR REACH',
      'imageUrl':
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=300&fit=crop',
      'badge': null,
    },
  ];

  // Methods
  void selectCategory(String category) {
    selectedCategory.value = category;
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
