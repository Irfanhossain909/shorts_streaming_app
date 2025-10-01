# Project Structure

## Root Directory Structure

```
testemu/
├── lib/                    # Main application code
├── assets/                 # Static assets (images, fonts, etc.)
├── android/               # Android-specific configuration
├── ios/                   # iOS-specific configuration
├── web/                   # Web-specific configuration
├── windows/               # Windows-specific configuration
├── macos/                 # macOS-specific configuration
├── linux/                 # Linux-specific configuration
├── test/                  # Unit and widget tests
├── .env                   # Environment variables
├── pubspec.yaml           # Dependencies and project configuration
└── analysis_options.yaml  # Dart analyzer configuration
```

## Core Architecture (`lib/`)

### Feature-Based Structure
The project follows a **feature-based clean architecture** with clear separation of concerns:

```
lib/
├── main.dart              # Application entry point
├── app.dart              # App configuration and routing setup
├── core/                 # Shared utilities and configurations
└── features/             # Feature modules
```

### Core Module (`lib/core/`)

```
core/
├── component/            # Reusable UI components
│   ├── appbar/          # Custom app bars
│   ├── bottom_nav_bar/  # Navigation components
│   ├── button/          # Button variants
│   ├── card/            # Card components
│   ├── image/           # Image handling components
│   ├── map/             # Map-related components
│   ├── other_widgets/   # Miscellaneous widgets
│   ├── pop_up/          # Modal and popup components
│   ├── review/          # Review and rating components
│   ├── screen/          # Screen templates
│   ├── text/            # Text components
│   └── text_field/      # Input field components
├── config/              # Application configuration
│   ├── api/             # API endpoints and configuration
│   ├── dependency/      # Dependency injection setup
│   ├── languages/       # Internationalization
│   ├── route/           # Navigation routes
│   ├── secret_key/      # API keys and secrets
│   └── theme/           # App theming
├── constants/           # App-wide constants
│   ├── app_colors.dart  # Color definitions
│   ├── app_icons.dart   # Icon constants
│   ├── app_images.dart  # Image asset paths
│   └── app_string.dart  # String constants
├── services/            # External service integrations
│   ├── api/             # HTTP client and API services
│   ├── location/        # Location services
│   ├── notification/    # Push notifications
│   ├── responsive/      # Screen responsiveness
│   ├── socket/          # WebSocket services
│   └── storage/         # Local storage services
└── utils/               # Utility functions and helpers
    ├── enum/            # Enumerations
    ├── extensions/      # Dart extensions
    ├── helpers/         # Helper functions
    └── log/             # Logging utilities
```

### Features Module (`lib/features/`)

Each feature follows a **clean architecture pattern** with these layers:

```
features/
├── auth/                # Authentication features
│   ├── change_password/
│   ├── forgot password/
│   ├── sign in/
│   └── sign up/
├── message/             # Chat and messaging
├── navigation_bar/      # Bottom navigation
├── notifications/       # Push notifications
├── onboarding_screen/   # App onboarding
├── profile/             # User profile management
├── setting/             # App settings
└── splash/              # Splash screen
```

### Feature Structure Pattern

Each feature module follows this consistent structure:

```
feature_name/
├── data/                # Data layer
│   ├── model/          # Data models
│   └── repository/     # Data repositories (if needed)
├── presentation/        # Presentation layer
│   ├── controller/     # GetX controllers (business logic)
│   ├── screen/         # UI screens
│   └── widgets/        # Feature-specific widgets
└── repository/         # Repository implementations (if needed)
```

## Naming Conventions

### Files and Directories
- **Snake_case**: All file and directory names use snake_case
- **Descriptive names**: Files should clearly indicate their purpose
- **Screen suffix**: UI screens end with `_screen.dart`
- **Controller suffix**: Controllers end with `_controller.dart`
- **Model suffix**: Data models end with `_model.dart`

### Classes and Variables
- **PascalCase**: Class names use PascalCase
- **camelCase**: Variable and method names use camelCase
- **Constants**: Use UPPER_SNAKE_CASE for constants

## Asset Organization

```
assets/
└── images/             # All image assets
    ├── icons/          # App icons and small graphics
    ├── backgrounds/    # Background images
    └── illustrations/  # Larger graphics and illustrations
```

## Key Architectural Patterns

1. **GetX Pattern**: Controllers handle business logic, screens handle UI
2. **Repository Pattern**: Data access abstraction (where applicable)
3. **Service Locator**: Dependency injection through GetX
4. **Component-Based UI**: Reusable components in `core/component/`
5. **Feature Isolation**: Each feature is self-contained with minimal cross-dependencies

## Import Organization

Follow this import order in Dart files:
1. Dart core libraries
2. Flutter libraries
3. Third-party packages
4. Local project imports (relative imports for same feature, absolute for cross-feature)

## Code Organization Rules

- Keep controllers lightweight - delegate complex logic to services
- Use const constructors where possible for performance
- Organize widgets by complexity: simple widgets in components, complex screens in features
- Maintain consistent file structure across all features
- Use meaningful variable names that describe the data or functionality

## Code Style Guidelines

### GetX Controller Pattern
- Controllers should extend `GetxController`
- Use reactive variables with `.obs` for state management
- Implement proper lifecycle methods (`onInit`, `onReady`, `onClose`)
- Keep business logic in controllers, UI logic in widgets

### Widget Structure
- Use `StatelessWidget` for static UI components
- Prefer composition over inheritance
- Extract reusable widgets into separate files
- Use `const` constructors wherever possible

### Error Handling
- Use try-catch blocks for async operations
- Implement proper error logging through `core/utils/log/`
- Show user-friendly error messages
- Handle network connectivity issues gracefully

### Performance Best Practices
- Use `ListView.builder` for large lists
- Implement proper image caching with `cached_network_image`
- Dispose controllers and streams properly
- Use `const` widgets to reduce rebuilds