# Technology Stack

## Framework & Language
- **Flutter 3.9.0+**: Cross-platform mobile development framework
- **Dart**: Primary programming language

## State Management & Architecture
- **GetX 4.7.2**: State management, dependency injection, and routing
- **Clean Architecture**: Feature-based modular structure with presentation, data, and domain layers

## Key Dependencies

### UI & Styling
- `flutter_screenutil ^5.9.3`: Responsive screen adaptation
- `google_fonts ^6.2.1`: Custom font integration
- `flutter_svg ^2.2.0`: SVG asset support
- `cupertino_icons ^1.0.8`: iOS-style icons

### Networking & API
- `dio ^5.8.0+1`: HTTP client for API requests
- `pretty_dio_logger ^1.4.0`: API request/response logging
- `cached_network_image ^3.4.1`: Image caching and loading

### Real-time Communication
- `socket_io_client ^3.1.2`: WebSocket communication for chat

### Storage & Configuration
- `shared_preferences ^2.5.3`: Local data persistence
- `flutter_dotenv ^5.2.1`: Environment variable management

### Location & Maps
- `google_maps_flutter ^2.13.1`: Google Maps integration
- `geolocator ^14.0.2`: Location services
- `geocoding ^4.0.0`: Address geocoding

### Media & Files
- `image_picker ^1.1.2`: Camera and gallery access
- `image_cropper ^9.1.0`: Image editing capabilities
- `mime ^2.0.0`: MIME type detection

### Forms & Input
- `intl_phone_field ^3.2.0`: International phone number input
- `pin_code_fields ^8.0.1`: OTP/PIN input fields

### Utilities
- `intl ^0.20.2`: Internationalization and date formatting
- `flutter_html ^3.0.0`: HTML content rendering

## Development Tools
- `flutter_lints ^5.0.0`: Dart/Flutter linting rules
- `flutter_test`: Testing framework

## Common Commands

### Development
```bash
# Install dependencies
flutter pub get

# Run the app (debug mode)
flutter run

# Run on specific device
flutter run -d <device-id>

# Hot reload (during development)
# Press 'r' in terminal or use IDE hot reload
```

### Building
```bash
# Build APK (Android)
flutter build apk --release

# Build App Bundle (Android)
flutter build appbundle --release

# Build iOS (requires macOS and Xcode)
flutter build ios --release

# Build for web
flutter build web --release
```

### Testing & Analysis
```bash
# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
flutter format .
```

### Dependency Management
```bash
# Update dependencies
flutter pub upgrade

# Check for outdated packages
flutter pub outdated

# Clean build cache
flutter clean
```

## Build Configuration
- **Design Size**: 428x926 (configured in ScreenUtilInit)
- **Minimum SDK**: Dart 3.9.0+
- **Target Platforms**: Android, iOS, Web, Windows, macOS, Linux
- **Environment File**: `.env` for configuration variables