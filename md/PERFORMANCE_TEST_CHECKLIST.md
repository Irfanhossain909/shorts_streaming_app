# Performance Test Checklist

## Quick Test Guide - 60 FPS Optimization

### ✅ Pre-Test Setup

1. **Clean Build**:
```bash
flutter clean
flutter pub get
flutter run --profile  # Use profile mode for accurate performance testing
```

2. **Enable Performance Overlay** (Optional):
   - Uncomment line 22 in `lib/app.dart`: `showPerformanceOverlay: true,`

---

### 🧪 Test Scenarios

#### 1. App Launch Performance
- [ ] App launches without lag
- [ ] Splash screen transitions smoothly
- [ ] No freeze during socket connection

#### 2. Navigation Performance
- [ ] Bottom navigation tab switches are instant (<200ms)
- [ ] No frame drops when switching between tabs
- [ ] HomeScreen loads smoothly
- [ ] MyList screen loads smoothly
- [ ] Profile screen loads smoothly

#### 3. Home Screen Scrolling
- [ ] Smooth scrolling through movie lists
- [ ] No jank when category filter changes
- [ ] Search results appear without lag
- [ ] Image loading doesn't cause frame drops

#### 4. Shorts Feed
- [ ] Video feed scrolls smoothly at 60 FPS
- [ ] Video transitions are smooth
- [ ] No lag during video playback

#### 5. Search & Filter
- [ ] Category filter switches instantly
- [ ] Search input is responsive
- [ ] Search results load smoothly

---

### 📊 Performance Metrics to Check

#### Using DevTools:
1. Open DevTools: `flutter run --profile` then press 'v' in terminal
2. Go to **Performance** tab
3. Check:
   - [ ] Frame rendering time < 16ms (green bars)
   - [ ] Build phase < 8ms
   - [ ] Rasterizer phase < 8ms
   - [ ] No red bars (dropped frames)

#### Visual Indicators:
- **Green Bars**: Excellent (0-16ms)
- **Yellow Bars**: Warning (16-32ms) - occasional is OK
- **Red Bars**: Problem (>32ms) - needs optimization

---

### 🐛 Known Areas to Watch

1. **Image Loading**: 
   - First load might be slower (network)
   - Should improve with caching

2. **Video Playback**:
   - Hardware dependent
   - May vary on different devices

3. **Network Requests**:
   - Slow network might affect perceived performance
   - Test on good WiFi first

---

### 📱 Device Testing Priority

1. **Low-End Device** (e.g., older Android):
   - Should run at stable 50+ FPS (acceptable)
   
2. **Mid-Range Device**:
   - Should run at 60 FPS consistently

3. **High-End Device**:
   - Should run at solid 60 FPS with no drops

---

### 🔍 Debugging Performance Issues

If you still see performance issues:

1. **Check Timeline in DevTools**:
   - Identify which widgets are rebuilding
   - Look for expensive operations

2. **Enable Performance Overlay**:
```dart
// In app.dart
showPerformanceOverlay: true,
```

3. **Check Console for Warnings**:
   - Look for "Performance Warning" logs
   - Check for memory warnings

4. **Profile Mode vs Debug Mode**:
   - **NEVER** test performance in debug mode
   - Always use: `flutter run --profile`

---

### ✨ Expected Results After Optimization

✅ **Home Screen**: Smooth 60 FPS scrolling
✅ **Navigation**: Instant tab switching (<200ms)
✅ **Animations**: Smooth transitions
✅ **Search**: Responsive without lag
✅ **Scrolling**: No jank or stuttering

---

### 🚀 Quick Commands

```bash
# Clean build
flutter clean && flutter pub get

# Profile mode (for performance testing)
flutter run --profile

# Release mode (production performance)
flutter run --release

# DevTools
flutter pub global activate devtools
flutter pub global run devtools

# Check app size
flutter build apk --analyze-size
```

---

### 📝 Report Template

If issues persist, report using this format:

```
**Device**: [Model, OS version]
**Flutter Version**: [Run: flutter --version]
**Issue**: [Describe the lag/jank]
**Screen**: [Which screen?]
**Action**: [What were you doing?]
**FPS**: [Approximate FPS from overlay]
**Timeline**: [Screenshot from DevTools if possible]
```

---

### 🎯 Success Criteria

The optimization is successful if:
- ✅ Average FPS ≥ 60 on mid-range devices
- ✅ Average FPS ≥ 55 on low-end devices  
- ✅ Less than 5% frame drops during normal usage
- ✅ Navigation feels instant (<200ms)
- ✅ Scrolling feels smooth
- ✅ No visible jank or stuttering

---

*Ready to test? Run: `flutter run --profile`*
