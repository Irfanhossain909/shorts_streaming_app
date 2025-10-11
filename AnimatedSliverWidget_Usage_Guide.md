# AnimatedSliverWidget Usage Guide

## আপনার home_screen.dart-এ AnimatedSliverWidget কিভাবে ব্যবহার করবেন

### 1. Import করুন:
```dart
import 'package:testemu/core/component/other_widgets/animated_sliver_widget.dart';
```

### 2. বিভিন্ন Animation Types:

#### a) Fade Animation:
```dart
AnimatedSliverWidget(
  delay: 200,
  animationType: AnimationType.fade,
  child: YourWidget(),
)
```

#### b) Slide Animation:
```dart
AnimatedSliverWidget(
  delay: 400,
  animationType: AnimationType.slide,
  child: YourWidget(),
)
```

#### c) Scale Animation:
```dart
AnimatedSliverWidget(
  delay: 600,
  animationType: AnimationType.scale,
  child: YourWidget(),
)
```

#### d) Combined Fade + Slide:
```dart
AnimatedSliverWidget(
  delay: 800,
  animationType: AnimationType.fadeSlide,
  child: YourWidget(),
)
```

#### e) Combined Fade + Scale:
```dart
AnimatedSliverWidget(
  delay: 1000,
  animationType: AnimationType.fadeScale,
  child: YourWidget(),
)
```

#### f) All Animations Combined:
```dart
AnimatedSliverWidget(
  delay: 1200,
  animationType: AnimationType.all,
  child: YourWidget(),
)
```

### 3. CustomScrollView এর মধ্যে ব্যবহার:

```dart
CustomScrollView(
  slivers: [
    // Header content
    AnimatedSliverWidget(
      delay: 200,
      animationType: AnimationType.fadeSlide,
      child: YourHeaderWidget(),
    ),
    
    // Movies section
    AnimatedSliverWidget(
      delay: 400,
      animationType: AnimationType.fadeScale,
      child: YourMoviesWidget(),
    ),
    
    // Grid section using AnimatedSliverGrid
    AnimatedSliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.50,
      ),
      staggerDelay: 100, // প্রতিটি item 100ms পরে animate হবে
      animationType: AnimationType.fadeScale,
      children: yourMovieWidgets,
    ),
  ],
)
```

### 4. প্যারামিটার সমূহ:

- **delay**: Animation শুরু হওয়ার আগে কত মিলিসেকেন্ড অপেক্ষা করবে
- **duration**: Animation কতক্ষণ চলবে
- **curve**: Animation এর curve (Curves.easeInOut, Curves.bounceIn, etc.)
- **animationType**: কোন ধরনের animation চান
- **staggerDelay**: (Grid/List এর জন্য) প্রতিটি item কত দেরিতে animate হবে

### 5. আপনার home_screen.dart এ যেভাবে ব্যবহার করেছি:

```dart
// VIP Section
List<Widget> _buildVipSections(HomeController controller) {
  return [
    AnimatedSliverWidget(
      delay: 200,
      animationType: AnimationType.fadeSlide,
      child: SectionHeader(
        title: 'Top VIP Picks',
        // ... other properties
      ),
    ),
    
    SliverToBoxAdapter(child: SizedBox(height: 20.h)),
    
    AnimatedSliverWidget(
      delay: 400,
      animationType: AnimationType.fadeSlide,
      child: _buildVipMoviesGrid(controller),
    ),
    // ... more widgets
  ];
}
```

### 6. স্পেশাল ফিচার:

#### a) Staggered Animation (ক্রমানুসারে Animation):
```dart
AnimatedSliverList(
  staggerDelay: 100, // প্রতিটি item 100ms পরে animate হবে
  children: yourWidgets,
)
```

#### b) Grid Animation:
```dart
AnimatedSliverGrid(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
  ),
  staggerDelay: 50,
  animationType: AnimationType.fadeScale,
  children: yourGridItems,
)
```

### 7. Tips:

1. **Performance**: খুব বেশি animation একসাথে ব্যবহার করবেন না
2. **Delay**: বিভিন্ন section এর জন্য বিভিন্ন delay ব্যবহার করুন (200ms, 400ms, 600ms...)
3. **Duration**: সাধারণত 400-800ms duration ভালো লাগে
4. **Curve**: easeInOut, easeOutCubic এগুলো smooth animation দেয়

### 8. Common Issues:

- **Import Error**: সঠিক path দিয়ে import করুন
- **Build Context**: CustomScrollView এর ভিতরে ব্যবহার করুন
- **Performance**: অনেক animation একসাথে ব্যবহার করলে lag হতে পারে

এই guide অনুসরণ করে আপনি সুন্দর animated sliver widgets তৈরি করতে পারবেন! 🎉